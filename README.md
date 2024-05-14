# SC-EXAM

This project aims to classify signal and background data using machine learning techniques; in particular, two different approaches have been adopted: first, the TMVA (Toolkit for Multi-Variate Analysis)  code ClassificationCategory.C has been used, then a complementary analysis using a Python function is pursued. The Python analysis aims to implement some complementary methods and is not intended as a comparison; moreover, the TMVA methods show some problems to properly separate signal and background classes, so the Python methods aim to catch some improvements.

1. The TMVA code consists of a classification code that implements 3 different methods, Fisher, Likelihood and H-Matrix; moreover, the same 3 methods are applied to the whole dataset or to differentiate the data according to the absolute value of the eta. The FisherCat, the LikelihoodCat and the HMatrixCat methods train separately the two categories defined by the values of eta; the code aims to show the improvement brought by this technique.
2. The Python analysis implements several methods that are not present in the TMVA code: Neural Network, BDT, Random Forest, k-Nearest Neighbours kNN and the Support Vector Machine SVM. While the first three methods are quite conventional, the last two may require some motivation. The kNN is one of the simplest classification methods, based on the idea of similarity: similar objects are close together in space; it is a simple but effective classification method. In fact, the support vector machine searches for the interplane that maximises the separation between the two classes; if the former is usually chosen for small datasets with a simple data pattern, the latter is usually preferred for datasets of larger dimensions.
The Python analysis is carried out by implementing classes; the choice is driven by the fact that common features appear in the code: data loading and normalisation, implementation of the classifier and evaluation of the model. For this reason, the classes are organised in the include folder with the following names Classifier.py, MetricPrinter.py, DataPreparation.py. The code is executed from main.py.

The user can choose how to perform the analysis by running the bash file ./Main.sh (it is in the "__Bash_folder__" folder), where the user must first choose whether to use python or root to analyse the data, and if the former is chosen, the user must choose between the methods available in python. At the end, the ROC curve is displayed with all the Python methods selected. 

The best choice for the model parameters is made implementing the grid search: it is implemented separately in all the codes (in the folder "grid_search") and run by ./grid_run.sh; it allows to look for the best model parameters which are then implemented in the model definition within classes.

The dataset is composed of two classes of events, signal and background, for each of which five variables are defined: "vars1", "vars2", "vars3", "vars4", "eta". Both the TMVA and Python codes implement the comparison between the whole training data set and the splitting into two different categories according to the value of "eta"; in particular, the training data set is split for the absolute value of eta less or greater than 1.3. After splitting, the data are trained using the other four variables for classification: performing training on a reduced data set should help to distinguish similar features among the data. The comparison between the categorised models and the unsplit ones shows a clear improvement, especially in the case of TMVA, but a slight improvement is also present in the Python code. 

## Folder organization

The project is organized as follow. In the main folder '__SC_EXAM__' there are:
- The folder '__TMVA_Cat__' which contains the TMVA analysis macro '_ClassificationCategory.C_' and a short readme file for commenting code.
- The folder '__Python_Cat__' which contains the main Python code '_main.py_', the folder '__Include__' (see below for more information) which works complementary to the main Python program and a short readme file for commenting the code.
- "_README.md_", which contains general information about the repository.
- The '__grid_search__' folder (see below for more information).
- The '__plot_ROC__' folder (see below for more information).
- The '__Analysis__' folder (see below for more information).
- The '__Classification_Results__' folder which contains results achieved and some comments in a readme file.
- Three bash files named '__Setting.sh__', '__Main.sh__', '__Docker.sh__' for handling the code execution (see below for more information).
- The '__data_backup__' folder contains a backup dataset in case the user does not have `wget` and does not want to install it, or the download fails.

Note also that the '__grid_search__', '__Analysis__', '__TMVA_Cat__', '__Python_Cat__' folders each contain a docker file to set up the docker environment. Now, the dockerfiles of '__TMVA_Cat__', '__Python_Cat__' are executed within the main program, while those of '__grid_search__', '__Analysis__' are not, so if the user wants to use them, he will have to do it manually from the terminal (see the 'How To Run' section for details on how to run the code, of course). To get a better understanding of how the code works and what the workflow is, it is suggested that the user read the comment section 'Some Comments about bash file code'. The code is designed to be executed via bash files, whether or not docker files are used. However, it is also possible to run individual parts of the code (see the 'How to run' section).



### Some comments about subfolders
       
1. The '__Python_Cat/Include__' folder contains all the class definition files:
     -  "_DataPreparation.py_" for data loading, normalization and creation of nunpy arrays; in this file also the splitting of the dataset is reported, together with the division into two differnt categories. The variables used to train the dataset are defined here: "vars1", "vars2", "vars3" and "vars4".
     -  "_Classifier.py_" contains the models definition, testing and evaluation.
     -  "_MetricsPrinter.py_" print the ROC curves and the metrics to evaluate the models.
     -  There is also a short readme file for commenting the code.
       
2. The '__grid_search__' folder contains the codes where the search grid is implemented. This is done separately before constructing classes, thus optimised parameters are then set in the model definition for each classifier. The folder entitled ‘__DataPreparation__’ contains all the code necessary for preparing the dataset, evaluation and grid search (the folder contains: ‘_Data_Evaluation.py_’, ‘_Data_Preparation.py_’, ‘_Grid.py_’). Additionally, a readme file containing comments on the code is provided. 
3. The '__plot_ROC__' folder contains the 'ROC_comparison.py' code and the relative readme named '__ROC_comparison.py__', which is used to perform the comparison between the Python model that the user selects for the analysis. This code relies on the creation of a folder, '__evaluation_results__', which is used to store the results. This folder contains the files 'model_type.txt', which report the background rejection (defined as 1-fpr, the false positive rate) and the signal efficiency (equal to true positive rate, tpr) for each model. Subsequently, the aforementioned folder is cancelled once the requisite analysis has been completed. The folder also contained a short readme file.
4. The '__Analysis__' folder contains the code necessary to perform a preliminary analysis of the dataset ('__Analysis.py__'). The code is accompanied by a readme file, which provides comments on the results. This folder contains also a subfolder named '__python_plots__' which in turn includes the results of the analysis of variables performed running '__Analysis.py__'. this folder is automatically generated from the script '__Analysis.py__' folder and is automatically cancelled by the bash file ('__Setting.sh__') out once the analysis is finished; there the folder is reported to show the results obtained by the preliminary analysis in the dataset.
5. The '__TMVA_Cat__/__TMVA_plot__' folder contains a series of plots generated automatically by the ClassificationCategory.C macro. These include the ROC curve, the PDF distribution for the three methods and the signal probability distribution. Additionally, the folder contains a readme file that provides commentary on the main results.
6. The '__Classification_Results__' folder contains all the plots resulting from the execution (organized in subfolders based on name of model) of the code and a readme with an explanation of the results; in this folder the plots list above are present:
    - The features importance for each python model.
    - The ROC curves for each python model, performing the comparison between the ROC of the full dataset and the ROC from the categorisation.
    - The confusion matrix for each model, both with and without categorisation.
    - The ROC curve obtained for the TMVA methods, both with and without categorisation.
    - The comparative ROC curves for all python models selected.

## Some Comments about bash file code:

In this section, the workings of the two bash files are elucidated. They are kept separate from the initial code explanation for practical and logistical reasons, as they represent a means to execute the programs.

### Main.sh

This script provides an interactive interface for conducting classification analysis using two different platforms, ROOT and Python. It allows users to select models and perform additional analysis if necessary.

1) The main menu prompts users to choose between analysis with ROOT or Python. Depending on the choice, it executes the corresponding analysis and offers the option to conduct additional analysis in Python and compare results with an ROC plot using the `ROC_comparison.py` script.
2) _Function `execute_with_root()`_: Performs classification analysis using TMVAClassificationCategory with ROOT. It utilizes the command `root -l` to execute the ROOT script `ClassificationCategory.C`.
3) _Function `execute_with_python()`_: Enables users to choose from various classification models (BDT, Neural Network, Random Forest, SVM, kNN) and executes the Python script `main.py` with the selected model. After running a model, it asks if users want to perform another analysis in Python.
4) _Function `ask_another_python_analysis()`_: Asks users if they want to conduct another analysis in Python. Returns 0 if users answer 'y' or 'Y', and 1 if they answer 'n' or 'N'.
5) _Function `ask_root_analysis()`_: Inquires if users want to perform the analysis in ROOT. If the answer is 'y' or 'Y', it executes `execute_with_root`.

### Setting.sh

The `Setting.sh` script automates several tasks necessary for setting up and running a project. Here's a breakdown of its functionality:

1. **Downloading File from Google Drive**: The script contains a function `download_from_google_drive()` which downloads a file from Google Drive using the `wget` command. It defines the direct URL of the file on Google Drive and specifies the name of the file to be saved locally. After downloading, it confirms successful download.

2. **Moving Datasets**: Another function `copy_folder()` copies the dataset folder and its contents to different directories, anticipating possible usage scenarios like Docker. It copies the data folder to directories named `Analysis`, `grid_search`, `Py_Cat`, and `TMVA_Cat`.

3. **Checking ROOT and Python Versions**: Two functions, `check_root()` and `check_python()`, verify if ROOT (a data analysis framework) and Python 3 are installed respectively, and if they meet the required versions. It informs the user of the status.

4. **Starting Docker Environment (Optional)**: After checking the availability of ROOT and Python, the script prompts the user whether they want to run the project using Docker. If the user chooses to do so, it runs a Docker setup script and exits.

5. **Handling Unavailability of ROOT or Python**: If either ROOT or Python is not available or if both are unavailable, the script prompts the user about running the project using Docker.

6. **Executing Analysis Code**: The script executes a Python script named `Analysis.py` located in the `Analysis` directory, which likely performs some data analysis tasks.

7. **Removing Temporary Files**: After the analysis is complete, it removes the `python_plots` folder inside the `Analysis` directory.

8. **Starting Machine Learning Process**: Finally, the script executes another script named `Main.sh` to initiate the machine learning process.

This script provides an automated setup for the project, ensuring necessary dependencies are in place and facilitating smooth execution.


### Docker.sh

The `Docker.sh` script facilitates running the project using Docker containers. Here's a detailed explanation of its functionalities:

1. **Start Docker Containers Based on Availability**: Depending on the availability of ROOT and Python (indicated by command line arguments), the script starts the respective Docker containers. If ROOT is available, it starts the ROOT container. If Python is available, it starts the Python container. If either ROOT or Python is unavailable, the script prompts the user whether they want to proceed with Docker usage anyway. If the user chooses to proceed, the script starts the corresponding Docker container and performs necessary setup tasks. Additionally, if Python is started, it copies the `plot_ROC` folder to the `Python_Cat` directory for plotting purposes.
   
2. **Start Docker Container for ROOT**: The script defines a function `start_docker_ROOT()` to initialize a Docker container specifically configured for ROOT, a data analysis framework. It changes directory to `TMVA_Cat` where the Dockerfile for the ROOT container is located. If the Docker image for ROOT doesn't exist, it builds the image. Then, it runs the Docker container interactively with a shell, executing a ROOT script `ClassificationCategory.C`. After the script execution, it prompts the user for further interaction with Docker. Once done, it removes the container.

3. **Start Docker Container for Python**: Another function `start_docker_Python()` is defined to start a Docker container tailored for Python. It changes directory to `Python_Cat` where the Dockerfile for the Python container is located. If the Docker image for Python doesn't exist, it builds the image. Then, it runs the Docker container interactively with a shell. Inside the container, the user is prompted to choose a machine learning model to run (e.g., BDT, Neural Network) or explore other options. Based on the user's input, it executes Python scripts accordingly. It also allows the user to interact with Docker prior to exiting. After the user is done, it removes the container.





# How to run

Clone the repository:

````````````````````````````````````````````````````````
$ git clone https://github.com/edorovati/SC-EXAM.git
````````````````````````````````````````````````````````

Go to the project directory:

`````````````````````````````
$ cd your/path/to/SC-EXAM
`````````````````````````````

There are several ways to execute the code: 

## 1. Using script file

The user needs to execute the script that configures the folder settings and downloads the data:

````````````````````````
$ chmod +x Setting.sh
$ ./Setting.sh
````````````````````````
During the execution of the code, the dataset will be installed and will then be moved to the folders of interest while maintaining a master copy in the root folder. Next, there is a Python and ROOT availability check, and the following things can happen: 

- Case 1, ROOT and Python present: The script allows the user to see some preliminary graphs of the dataset. Then the main program `Main.sh` is run, and from that point on everything is handled by the interface created by this file.
- Case 2, ROOT and/or Python are missing: In this case, the script will take this into account and ask the user if they want to start Docker, given the absence of one or both of the main programs, and move the code execution to another script called `Docker.sh`, which will take care of starting Docker containers depending on what is not present on the user's machine. Note however that in this case the analysis will not be started as it is not part of the main code, so if the user does not have ROOT only then simply follow the instructions to run the '_Analysis.py_' file in the appropriate section. On the other hand, if the user does not have Python, it will be necessary to run the dockerfile inside the '__Analysis__' folder, as shown in the appropriate section. Finally, the code will execute `Docker.sh' if neither ROOT and Python is present; if at least one of the two is present, however, the user will be asked if they want to use docker anyway or run the python code themselves. In the latter case, the code will exit and the user will have to run the code themselves (see below how to do).

Finally, User can perform grid search in the designated folder ("grid_search"). In this case, there's a bash file to execute:

`````````````````````
$ chmod +x Grid.sh
$ ./Grid.sh
`````````````````````

**It's important to note that this code is separate from the others and is not part of the main program.**

## 2. Run individual files without docker

If the user wishes to run the individual files, the following must be done first: download the dataset file (see how to do this below). Alternatively, there may already be a dataset in '__data_backup__', in which case simply rename the '__data__' folder.

``````````````````````````````
$ cd your/path/to/SC-EXAM  
$ mkdir data          
$ wget -O data/toy_sigbkg_categ_offset.root "https://drive.google.com/uc?id=1NDWLpmLKDRPjrspXVl3zLOkXBSRzScV_"
$ cp -r data <desired_folder>
``````````````````````````````````````````````````````````````````````````````````````````````````````````````````

Then the users can:
- Within the "__Analysis__" folder and execute:
  
``````````````````````````````````
 $ python3 Analysis.py
``````````````````````````````````

- Whitin SC-EXAM folder execute:

`````````````````````````````
 $ python3 Python_Cat/main.py <model_name>
`````````````````````````````
     <model_name> = BDT, Neural_Network, kNN, SVT, Random_Forest

Afterwards, it is possible to run main.py with at least one model:

`````````````````````````````
 $ python3 plot_ROC/ROC_comparison.py <model_name1 model_name2 ...>
`````````````````````````````
       <model_name> = BDT, Neural_Network, kNN, SVT, Random_Forest 
       
select more than one model to perform the comparison 

- Whitin '__grid_search__' a grid search could be perfomed


`````````````````````````````
 $ python3 grid_search/<model_name>_Grid.py 
`````````````````````````````
     <model_name> = BDT, NN, KNN, Random_Forest


 - The user can run the ROOT program in the main folder ‘__SC-EXAM__’ as follows:


      `````````````````````````````
       $ root TMVA_Cat/ClassificationCategory.C
      `````````````````````````````

## Only dockerfile

If you prefer to run the dockerfiles directly, follow these instructions:
- Download the dataset file (see how to do this above). Alternatively, there may already be a dataset in '__data_backup__', in which case simply rename the '__data__' folder. Then copy '__data__' in all subfolders. Then you can:
   - Run dockerfile inside '__Analysis__'
   - Run dockerfile inside '__TMVA_Cat__'
   - Run dockerfile inside '__Python_Cat__' (In this case it is also necessary to copy the '__plot_ROC__' folder to '__Python_Cat__').
   - Run dockerfile inside '__grid_search__'
     
- Now, builds a Docker image with the given name:
`````````````````````````````
$ docker build -t <name_image> .
`````````````````````````````
- Lastly, runs a Docker container from the specified image `<name_image>`, ensuring that it is removed automatically (--rm) when it exits and allowing interactive mode (-it) for interaction with the container's shell:

`````````````````````````````
$ docker run --rm -it <name_image>
`````````````````````````````

- You can now execute the desired commands depending on the folder in which you have run the docker:
   - If you have run the dockerfile inside '__Analysis__':

     `````````````````````````````
     $ python3 Analysis.py
     `````````````````````````````

   - If you have run the dockerfile inside '__grid_search__':
     
     `````````````````````````````
     $ chmod +x Grid.sh
     $ ./Grid.sh
     `````````````````````````````
     
  - If you have run the dockerfile inside '__TMVA_Cat__':

    `````````````````````````````
    $ root -l -b -q ClassificationCategory.C
    `````````````````````````````

  - If you have run the dockerfile inside '__Python_Cat__' (Note that the comparison programme could be called after at least one model has been called):
    
     `````````````````````````````
     $ python3 my_project/main.py <model_name>
     $ python3 plot_ROC/ROC_comparison.py
     `````````````````````````````
         <model_name> = BDT, Neural_Network, kNN, SVT, Random_Forest
     



----------------------------------------------------------------------------------------------
**N.B: In the event that the wget download fails, i.e. the downloaded file is seen by the programs as a non-ROOT file, a folder containing the data set will be present in the program: '__data_backup__'. Just rename as '__data__', copy and move it in the folders '__Analysis__', '__grid_search__', '__Python_Cat__' and '__TMVA_Cat__' and follow the instructions above to run the code (section '_without wget_'). The same applies if the user does not have wget installed on the computer and does not wish to install it.**
