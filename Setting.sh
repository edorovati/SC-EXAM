#!/bin/bash

# Remove dataset folders of previous run
rm -rf "Analysis/data"
rm -rf "TMVA_Cat/data"
rm -rf "grid_search/data"
rm -rf "Python_Cat/data"

########################### Downloading file... ###########################
# Function to download the file from Google Drive
download_from_google_drive() {
    # Direct URL to the file on Google Drive
    google_drive_url="https://drive.google.com/uc?id=1NDWLpmLKDRPjrspXVl3zLOkXBSRzScV_"
    
    # Name of the file to save
    file_name="toy_sigbkg_categ_offset.root"
    
    # Create a directory for storing the downloaded file if it doesn't exist
    mkdir -p "data"
    
    # Download the file using wget
    wget -O "data/$file_name" "$google_drive_url"
    
    echo "File downloaded successfully."
}

# Call the function to download the file from Google Drive
download_from_google_drive
########################### Done! ###########################




########################### Move dataset... ###########################
# Function to copy the folder and its contents. This is done in anticipation of the possible use of dockerfiles, in case dockerfiles are not used, the data folder is searched in the root directory
copy_folder() {
    # Make sure both paths are provided
    if [ $# -ne 2 ]; then
        echo "Usage: copy_folder <source> <destination>"
        return 1
    fi
    
    source="$1"
    destination="$2"
    
    # Check if the source folder exists
    if [ ! -d "$source" ]; then
        echo "Source folder does not exist: $source"
        return 1
    fi
    
    # Copy the folder and its contents to the destination folder
    cp -r "$source" "$destination"
    
    echo "Folder copied successfully from $source to $destination"
}

# Use function to copy dataset into Analysis and grid_search folders
copy_folder "data" "Analysis"
copy_folder "data" "grid_search"
copy_folder "data" "Python_Cat"
copy_folder "data" "TMVA_Cat"
########################### Done! ###########################




########################### Check ROOT and Python ###########################

available_ROOT=0 # These variables are a tool to indicate the presence of ROOT and/or Python
available_PY=0 # and used to start dockerfile

# Function to check if ROOT is installed and has the correct version
check_root() {
    # Check if 'root' command is available
    if command -v root >/dev/null 2>&1; then
        # Get ROOT version
        root_version=$(root-config --version)
        echo "Root version: $root_version"
        required_root_version="6.30.06"  # Specific required version of ROOT
        
        # Compare ROOT version with required version
        if [[ "$root_version" != *"$required_root_version"* ]]; then
            echo "Incorrect version of ROOT installed. Required version: $required_root_version"
            available_ROOT=1 # It now indicates the absence of ROOT
        else
            echo "ROOT is installed and has the correct version ($required_root_version)."
        fi
    else
        echo "ROOT is not installed. Please install ROOT before proceeding."
        available_ROOT=1 # It now indicates the absence of ROOT
    fi
}

# Function to check if Python 3 is installed and has the correct version
check_python() {
    # Check if 'python3' command is available
    if command -v python3 >/dev/null 2>&1; then
        # Get Python 3 version
        python_version=$(python3 --version | cut -d' ' -f2)
        required_python_version="3.12.3"  # Specific required version of Python 3
        
        # Compare Python 3 version with required version
        if [ "$(printf "%s\n" "$required_python_version" "$python_version" | sort -V | head -n1)" != "$required_python_version" ]; then
            echo "Incorrect version of Python 3 installed. Required version: $required_python_version"
            available_PY=1 # It now indicates the absence of PY
        else
            echo "Python 3 is installed and has the correct version ($required_python_version)."
        fi
    else
        echo "Python 3 is not installed. Please install Python 3 before proceeding."
        available_PY=1 # It now indicates the absence of PY
    fi
}

# Check if both ROOT and Python 3 are installed and have the correct versions
check_root
check_python
########################### Done! ###########################




########################### Starting Docker Bash ###########################

# Function to inform the user about the option to run the project using a Docker container
inform_about_docker() {
    echo "Would you like to run the project using Docker?"
    read -p "(y/n): " docker_choice
    case $docker_choice in
        [Yy]*)
            echo "Running the project using Docker..."
            chmod +x Docker.sh
            ./Docker.sh $available_ROOT $available_PY
            exit 1;;
        [Nn]*)
            echo "Exiting..."
            exit 1
            ;;
        *)
            echo "Not a valid choice! Please repeat."
            inform_about_docker
            ;;
    esac
}

########################### Done! ###########################




########################### Check Availability ###########################

# Function to check if at least one of ROOT or Python is unavailable and call inform_about_docker
check_unavailability() {
    if [ "$available_ROOT" -eq 1 ] || [ "$available_PY" -eq 1 ]; then # ROOT OR Python not available
        inform_about_docker
        exit 1
    fi

    if [ "$available_ROOT" -eq 1 ] && [ "$available_PY" -eq 1 ]; then #ROOT AND Python not available
        inform_about_docker
        exit 1 # If neither is present, there's no reason to continue the code.
    fi
}

# Call function to check unavailability of ROOT or Python and call inform_about_docker if necessary
check_unavailability


########################### Done! ###########################



########################### Show dataset... ###########################
# Execute Analysis code
cd Analysis

while true; do
    read -p "Would you like to perform a preliminary analysis?(y/n)" analysis_choice
    case $analysis_choice in
        [Yy]*)
            python3 "Analysis.py"
            # Rimuovi la cartella "python_plots" all'interno della directory "Analysis"
            rm -rf "Analysis/python_plots"
            cd ..
            break  # Esci dal ciclo mentre dopo aver eseguito l'analisi
            ;;
        [Nn]*)
            cd ..
            break  # Esci dal ciclo mentre senza eseguire l'analisi
            ;;
        *)
            echo "Not a valid choice! Please repeat."
            ;;
    esac
done
            
########################### Done! ###########################



########################### Start ML ###########################
chmod +x Main.sh
./Main.sh
########################### Done! ###########################
