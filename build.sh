#!/bin/bash
set -e
set -o pipefail

# Script to set up and build OrangeFox for BlackShark SHARK KLE-H0
# Made by Caullen Omdahl

# Source the configuration file
CONFIG_FILE="$(dirname "$0")/config.sh"
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo "Configuration file config.sh not found. Exiting."
    exit 1
fi

# Log file location
LOG_DIR="$LOG_DIR"  # From config.sh
LOG_FILE="$LOG_DIR/build.log"
STATUS_FILE="$LOG_DIR/status.txt"
BUILD_DIR="$BUILD_DIR"  # From config.sh

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Function to log messages with levels
function log {
    local level="$1"
    shift
    echo -e "$(date '+%Y-%m-%d %H:%M:%S') [$level] - $*" | tee -a "$LOG_FILE"
}

# Ensure the script is not run as root
if [ "$EUID" -eq 0 ]; then
    log "ERROR" "Please do not run this script as root. Exiting."
    exit 1
fi

# Function to handle errors
function error_handler {
    log "ERROR" "An error occurred on line $1."
    exit 1
}

# Trap errors and signals
trap 'error_handler $LINENO' ERR
trap cleanup EXIT INT TERM

# Cleanup function
function cleanup {
    log "INFO" "Cleaning up before exiting..."
    # Add any necessary cleanup commands here
}

# Function to check for required commands
function check_required_commands {
    log "INFO" "Checking for required commands..."
    commands=("git" "curl" "gcc" "make" "java" "repo")
    for cmd in "${commands[@]}"; do
        if ! command -v "$cmd" &>/dev/null; then
            log "ERROR" "Command '$cmd' is required but not installed."
            exit 1
        else
            log "INFO" "Command '$cmd' is available."
        fi
    done
}

# Function to check internet connectivity
function check_internet_connection {
    log "INFO" "Checking internet connectivity..."
    if ! ping -c 1 google.com &>/dev/null; then
        log "ERROR" "No internet connection detected. Please check your network."
        exit 1
    fi
    log "INFO" "Internet connection is active."
}

# Function to check system resources
function check_system_resources {
    log "INFO" "Checking system resources..."

    # Ensure the BUILD_DIR exists before checking resources
    if [ ! -d "$BUILD_DIR" ]; then
        log "INFO" "Build directory $BUILD_DIR does not exist. Creating it..."
        mkdir -p "$BUILD_DIR"
        if [ $? -ne 0 ]; then
            log "ERROR" "Failed to create build directory $BUILD_DIR. Exiting."
            exit 1
        fi
        log "INFO" "Build directory $BUILD_DIR created successfully."
    fi

    # Check available disk space (minimum 60GB)
    REQUIRED_SPACE_GB=60
    AVAILABLE_SPACE_GB=$(df "$BUILD_DIR" --output=avail -BG | tail -1 | tr -dc '0-9')

    if [ "$AVAILABLE_SPACE_GB" -lt "$REQUIRED_SPACE_GB" ]; then
        log "ERROR" "Not enough disk space. Required: ${REQUIRED_SPACE_GB}GB, Available: ${AVAILABLE_SPACE_GB}GB."
        exit 1
    fi

    # Check total RAM (minimum 16GB)
    REQUIRED_RAM_GB=16
    TOTAL_RAM_GB=$(free -g | awk '/^Mem:/{print $2}')

    if [ "$TOTAL_RAM_GB" -lt "$REQUIRED_RAM_GB" ]; then
        log "ERROR" "Not enough RAM. Required: ${REQUIRED_RAM_GB}GB, Available: ${TOTAL_RAM_GB}GB."
        exit 1
    fi

    log "INFO" "System resources are sufficient."
}

# Function to parse command-line options
function usage {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -h, --help      Show this help message and exit"
    echo "  -c, --clean     Clean build output before building"
    exit 0
}

CLEAN_BUILD=false

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -h|--help) usage ;;
        -c|--clean) CLEAN_BUILD=true ;;
        *) echo "Unknown parameter passed: $1"; usage ;;
    esac
    shift
done

# Function to install dependencies
function install_dependencies {
    log "INFO" "Starting dependency installation process..."
    sudo apt-get update | tee -a "$LOG_FILE"

    # Enable 32-bit architecture support
    sudo dpkg --add-architecture i386 | tee -a "$LOG_FILE"
    sudo apt-get update | tee -a "$LOG_FILE"

    # List of required dependencies
    dependencies=(
        bc
        bison
        build-essential
        ccache
        curl
        flex
        g++-multilib
        gcc-multilib
        git
        gnupg
        gperf
        imagemagick
        lib32ncurses5-dev
        lib32readline-dev
        lib32z1-dev
        liblz4-tool
        libncurses5
        libncurses5-dev
        libsdl1.2-dev
        libssl-dev
        libxml2
        libxml2-utils
        lzop
        openjdk-8-jdk
        pngcrush
        rsync
        schedtool
        squashfs-tools
        xsltproc
        zip
        zlib1g-dev
        unzip
        python2
        python2.7
        python3
        python3-pip
        aria2
        file
        jq
        repo
    )

    # Install dependencies
    log "INFO" "Checking for missing packages..."
    missing_packages=()
    for package in "${dependencies[@]}"; do
        if ! dpkg -l | grep -qw "$package"; then
            missing_packages+=("$package")
            log "INFO" "Dependency '$package' is not installed."
        else
            log "INFO" "Dependency '$package' is already installed."
        fi
    done

    if [ "${#missing_packages[@]}" -ne 0 ]; then
        log "INFO" "Installing missing packages: ${missing_packages[*]}"
        sudo apt-get install -y "${missing_packages[@]}" | tee -a "$LOG_FILE"
    else
        log "INFO" "All required dependencies are already installed."
    fi

    # Create a symlink for python2 if it doesn't exist
    if [ ! -e /usr/bin/python2 ]; then
        sudo ln -s /usr/bin/python2.7 /usr/bin/python2
        log "INFO" "Created symlink for python2."
    fi

    log "INFO" "Dependency installation process completed."
}

# Function to configure Git
function configure_git {
    log "INFO" "Configuring Git user information..."
    if ! git config --global user.name &>/dev/null; then
        read -rp "Enter your Git user name: " git_user_name
        git config --global user.name "$git_user_name"
        log "INFO" "Set Git user.name to '$git_user_name'."
    else
        existing_name=$(git config --global user.name)
        log "INFO" "Git user.name is already set to '$existing_name'."
    fi

    if ! git config --global user.email &>/dev/null; then
        read -rp "Enter your Git user email: " git_user_email
        git config --global user.email "$git_user_email"
        log "INFO" "Set Git user.email to '$git_user_email'."
    else
        existing_email=$(git config --global user.email)
        log "INFO" "Git user.email is already set to '$existing_email'."
    fi
}

# Function to set up the build environment
function setup_build_environment {
    log "INFO" "Setting up the build environment..."
    cd "$HOME" || exit
    if [ ! -d "scripts" ]; then
        log "INFO" "Cloning OrangeFox scripts repository..."
        git clone "$SCRIPTS_REPO_URL" | tee -a "$LOG_FILE"
    else
        log "INFO" "OrangeFox scripts repository already exists."
    fi

    cd scripts || exit
    log "INFO" "Running android_build_env.sh script..."
    bash setup/android_build_env.sh | tee -a "$LOG_FILE"
    log "INFO" "Running install_android_sdk.sh script..."
    bash setup/install_android_sdk.sh | tee -a "$LOG_FILE"
    log "INFO" "Build environment setup completed."
}

# Function to sync OrangeFox sources
function sync_orangefox_sources {
    log "INFO" "Syncing OrangeFox sources..."
    if [ ! -d "$BUILD_DIR/.repo" ]; then
        mkdir -p "$BUILD_DIR"
        cd "$BUILD_DIR" || exit
        log "INFO" "Cloning OrangeFox sync repository..."
        git clone "$SYNC_REPO_URL" | tee -a "$LOG_FILE"
        cd sync || exit
        log "INFO" "Running orangefox_sync.sh script..."
        ./orangefox_sync.sh --branch 11.0 --path "$BUILD_DIR" | tee -a "$LOG_FILE"
        log "INFO" "OrangeFox sources synced successfully."
    else
        log "INFO" "OrangeFox sources already synced."
    fi
}

# Function to clone/update the device tree
function clone_device_tree {
    if [ ! -d "$BUILD_DIR/device/blackshark/$DEVICE_CODENAME" ]; then
        log "INFO" "Cloning the device tree..."
        mkdir -p "$BUILD_DIR/device/blackshark"
        git clone "$DEVICE_TREE_REPO_URL" "$BUILD_DIR/device/blackshark/" | tee -a "$LOG_FILE"
        log "INFO" "Device tree cloned successfully."
    else
        log "INFO" "Device tree already exists. Pulling latest changes..."
        cd "$BUILD_DIR/device/blackshark/$DEVICE_CODENAME" || exit
        git pull | tee -a "$LOG_FILE"
        log "INFO" "Device tree updated successfully."
    fi
}

# Function to perform the build
function perform_build {
    # Build OrangeFox
    log "INFO" "Building OrangeFox for BlackShark SHARK KLE-H0..."

    # Start the build process
    OUTPUT_IMAGE="$BUILD_DIR/out/target/product/$DEVICE_CODENAME/$OUTPUT_IMAGE_NAME"
    if [ "$CLEAN_BUILD" = true ]; then
        log "INFO" "Cleaning build output directory..."
        rm -rf "$BUILD_DIR/out"
    fi

    if [ ! -f "$OUTPUT_IMAGE" ]; then
        log "INFO" "Starting the build process..."

        # Export log function and JOBS variable
        export -f log
        JOBS=$(nproc)

        # Run the build commands in an interactive subshell
        bash -i -c "
            cd \"$BUILD_DIR\" || exit 1
            source build/envsetup.sh
            export ALLOW_MISSING_DEPENDENCIES=true
            export FOX_BUILD_DEVICE=\"$DEVICE_CODENAME\"
            export LC_ALL=\"C\"
            log \"INFO\" \"Running lunch command...\"
            lunch omni_${DEVICE_CODENAME}-eng || exit 1
            log \"INFO\" \"Running mka recoveryimage with $JOBS jobs...\"
            mka -j$JOBS recoveryimage || exit 1
        " | tee -a "$LOG_FILE"

        # Capture the exit status
        BUILD_EXIT_STATUS=${PIPESTATUS[0]}

        # Check if the build was successful
        if [ $BUILD_EXIT_STATUS -ne 0 ]; then
            log "ERROR" "Build process failed. Exiting."
            exit 1
        fi

        if [ -f "$OUTPUT_IMAGE" ]; then
            log "INFO" "Build completed successfully! The recovery image is located at $OUTPUT_IMAGE"
        else
            log "ERROR" "Build failed. Recovery image not found."
            exit 1
        fi
    else
        log "INFO" "Recovery image already exists at $OUTPUT_IMAGE. Skipping build."
    fi

    # Final message
    log "INFO" "OrangeFox build process completed successfully!"
}

# Main execution
check_internet_connection
install_dependencies
check_required_commands
check_system_resources
configure_git
setup_build_environment
sync_orangefox_sources
clone_device_tree
perform_build