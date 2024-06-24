#!/bin/bash


####################### Start ROOT #######################

# Function to execute the TMVAClassificationCategory with ROOT
execute_with_root() {
    root -l TMVA_Cat/ClassificationCategory.C
}
####################### End ROOT #######################


####################### Start Python #######################

# Function to execute Main.py with Python
execute_with_python() {
    selected_models=()
    while true; do
        echo "Choose the model to use:"
        echo "1) BDT"
        echo "2) Neural_Network"
        echo "3) Random_Forest"
        echo "4) SVT"
        echo "5) kNN"
        read -p "Enter the number corresponding to the chosen model (or 'e' to exit): " selected_model
        case $selected_model in
            1)
                if [[ " ${selected_models[@]} " =~ " BDT " ]]; then
                    echo "Number already selected, choose another model."
                else
                    python3 Python_Cat/main.py BDT
                    selected_models+=("BDT")
                fi
                ;;
            2)
                if [[ " ${selected_models[@]} " =~ " Neural_Network " ]]; then
                    echo "Number already selected, choose another model."
                else
                    python3 Python_Cat/main.py Neural_Network
                    selected_models+=("Neural_Network")
                fi
                ;;
            3)
                if [[ " ${selected_models[@]} " =~ " Random_Forest " ]]; then
                    echo "Number already selected, choose another model."
                else
                    python3 Python_Cat/main.py Random_Forest
                    selected_models+=("Random_Forest")
                fi
                ;;
            4)
                if [[ " ${selected_models[@]} " =~ " SVT " ]]; then
                    echo "Number already selected, choose another model."
                else
                    python3 Python_Cat/main.py SVT
                    selected_models+=("SVT")
                fi
                ;;
            5)
                if [[ " ${selected_models[@]} " =~ " kNN " ]]; then
                    echo "Model already chosen, please select another one"
                else
                    python3 Python_Cat/main.py kNN
                    selected_models+=("kNN")
                fi
                ;;
            e)
                echo "Displaying comparative results..."
                break
                ;;
            *)
                echo "Uncorrect choice: please try again"
                ;;
        esac
    done
}

####################### End Python #######################

# Function for deleting pre-existing folders
delete_folders() {
    # Verifica se sono stati passati degli argomenti
    if [ $# -eq 0 ]; then
        echo "Usage: delete_folders folder1 folder2 ..."
        return 1
    fi

    # Itera su tutti gli argomenti passati
    for folder in "$@"; do
        # Verifica se il percorso specificato è una directory esistente
        if [ -d "$folder" ]; then
            # Cancella la cartella e tutti i suoi contenuti
            rm -rf "$folder"
            echo "Folder '$folder' deleted."
        else
            echo "Folder '$folder' not found."
        fi
    done
}


# Deleting pre-existing folders and results from ROOT
delete_folders evaluation_results dataset
rm TMVACC.root
rm plot_ROC/ROC_curve.png
rm ROC_curve.pdf
####################### User Interface #######################

# Print the menu
echo "Choose the desired option:"
echo "1) Perform analysis with ROOT"
echo "2) Perform analysis with Python"

# Read user input and loop until a valid choice is made
while true; do
    read -p "Enter the number corresponding to the chosen option:" choice
    case $choice in
        1)
            echo "Executing analysis with ROOT..."
            execute_with_root
            while true; do
                # Ask user if they want to execute Python analysis
                read -p "Do you want to perform analysis with Python as well? (y/n):" python_choice
                case $python_choice in
                    [Yy]*)
                        echo "Executing analysis with Python..."
                        execute_with_python
                        python3 plot_ROC/ROC_comparison.py "${selected_models[@]}"
                        break
                        ;;
                    [Nn]*)
                        echo "Perfect! Goodbye!"
                        break
                        ;;
                    *)
                        echo "Invalid choice. Please enter 'y' or 'n'."
                        ;;
                esac
            done
            break
            ;;
        2)
            echo "Executing analysis with Python..."
            execute_with_python
            python3 plot_ROC/ROC_comparison.py "${selected_models[@]}"
            while true; do
                read -p "Do you want to perform analysis with ROOT as well? (y/n):" root_choice
                case $root_choice in
                    [Yy]*)
                        echo "Executing analysis with ROOT..."
                        execute_with_root
                        break
                        ;;
                    [Nn]*)
                        echo "Perfect! Goodbye!"
                        break
                        ;;
                    *)
                        echo "Invalid choice. Please enter 'y' or 'n'."
                        ;;
                esac
            done
            break
            ;;
        *)
            echo "Invalid choice. Please enter 1 or 2."
            ;;
    esac
done

####################### End User Interface #######################
