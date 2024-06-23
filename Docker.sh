#!/bin/bash

# Docker container names
container_name_root="root_with_shell"
container_name_python="py_with_shell"


######################################
# Function to start ROOT container #
######################################

start_docker_ROOT() {
    echo "📊 Starting Docker container for ROOT... 📊"
    cd TMVA_Cat
    # Build Docker container if not exists
    if ! docker image inspect "$container_name_root" &> /dev/null; then
        docker build -t "$container_name_root" .
    fi
    # Run Docker container with interactive shell
    docker run -it --name "$container_name_root" "$container_name_root" /bin/bash -c "root -l -b -q ClassificationCategory.C && while true; do read -p 'Type "exit" to quit. Alternatively, you can engage with Docker prior to exiting: ' input; if [[ \$input == 'exit' ]]; then break; else eval \$input; fi; done"
    docker rm "$container_name_root"
    cd ..
}
##############################################################################


#######################################
# Function to start Python container #
#######################################

start_docker_Python(){
    echo "📊 Starting Docker container for Python... 📊"
    cd Python_Cat
    # Build Docker container if not exists
    if ! docker image inspect "$container_name_python" &> /dev/null; then
        docker build -t "$container_name_python" .
    fi
    # Run Docker container with Python model selection
    docker run -it --name "$container_name_python" "$container_name_python" /bin/bash -c '
        selected_models=""
        while true; do
            read -p "Choose a model to run:
            1️⃣) BDT
            2️⃣) Neural Network
            3️⃣) Random Forest
            4️⃣) SVT
            5️⃣) kNN
            6️⃣) Explore folders before exiting
            Type the number corresponding to your choice: " model_choice
        
            case $model_choice in
                1) model_name="BDT";;
                2) model_name="Neural_Network";;
                3) model_name="Random_Forest";;
                4) model_name="SVT";;
                5) model_name="kNN";;
                6)
                    while true; do
                        read -p "Type exit to quit. Alternatively, you can engage with Docker prior to exiting: " input
                        if [[ $input == 'exit' ]]; then
                            break
                        else
                            eval $input
                        fi
                    done
                    break;;
                *) echo "❌ Invalid choice. Please try again. ❌";;
            esac
        
            if [ "$model_choice" != "exit" ] && [ -n "$model_name" ]; then
                if [[ ! "$selected_models" =~ "$model_name" ]]; then
                    selected_models="$selected_models$model_name"
                    python3 my_project/main.py $model_name
                else
                    echo "⚠️ You have already selected $model_name. Please choose a different model. ⚠️"
                fi
            fi
        done
'


rm -r plot_ROC
docker rm "$container_name_python"
}

##############################################################################


# Depending on availability, start Docker container for ROOT
while true; do
    if [ "$1" -eq 1 ]; then
        start_docker_ROOT
        break
    elif [ "$1" -eq 0 ]; then
        echo "ROOT is available. Would you like to use Docker anyway?"
        read -p "(y/n): " docker_choice
        case $docker_choice in
            [Yy]*)
                start_docker_ROOT
                break
                ;;
            [Nn]*)
                echo "Exiting..."
                break
                ;;
            *)
                echo "❌ Not a valid choice! Please repeat. ❌"
                ;;
        esac
    else
        echo "❌ Not a valid choice! Please repeat. ❌"
        break
    fi
done


# Depending on availability, start Docker container for Python
while true; do
    if [ "$2" -eq 1 ]; then
        cp -r plot_ROC Python_Cat
        start_docker_Python
        break
    elif [ "$2" -eq 0 ]; then
        echo "Python is available. Would you like to use Docker anyway?"
        read -p "(y/n): " docker_choice
        case $docker_choice in
            [Yy]*)
                cp -r plot_ROC Python_Cat
                start_docker_Python
                break
                ;;
            [Nn]*)
                echo "Exiting..."
                exit 1
                ;;
            *)
                echo "❌ Not a valid choice! Please repeat. ❌"
                ;;
        esac
    else
        echo "❌ Not a valid choice! Please repeat. ❌"
        break
    fi
done

