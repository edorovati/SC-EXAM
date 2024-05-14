############################### Start import ###############################

import os
import sys
import numpy as np
import include.DataPreparation as dl #Module for loading data
import include.Classifier as clf #Module for defining classifiers
import include.MetricPrinter as mp #Module for printing metrics

############################### End import ###############################



############################### Main code ###############################
'''
Checks whether the script is executed as a main program and checks whether 
the correct number of arguments has been supplied from the command line.
For example, one should verify that the execution of this code using a Bash
file would be Python3 main.py <name_model>. 
If one wishes to execute this code independently, 
one should enter the following command into the terminal 
(it is not necessary to call other modules).
'''
if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 main.py <model_type>")
        sys.exit(1)
    # Retrieve the model type from command-line arguments
    model_type = sys.argv[1]
    
    if not os.path.exists("evaluation_results"):
        os.makedirs("evaluation_results")
        
    # Dataset
    file1_path = os.path.join('data', 'toy_sigbkg_categ_offset.root')
    ############################### Preparing data ###############################
    
    # Data preparation
    data_prep = dl.DataPreparation(file1_path)
    data_prep.load_data()
    data_prep.prepare_data()

    ############################### Model Definition ###############################
    
    if model_type in ['BDT', 'Neural_Network', 'Random_Forest', 'SVT', 'kNN']:
        classifier = clf.SignalBackgroundClassifier(model_type=model_type,
                                                     X_train=data_prep.X_train,
                                                     X_train_cat1=data_prep.X_train_cat1,
                                                     X_train_cat2=data_prep.X_train_cat2)
    
    else:
        print("The model in question is not supported.")
        sys.exit(1)
        
    ############################### Training & Evaluation ###############################
    
    classifier.train_classifier(data_prep.X_train, data_prep.y_train, data_prep.X_train_cat1, data_prep.y_train_cat1, data_prep.X_train_cat2, data_prep.y_train_cat2, data_prep.feature_names, model_type)
    print("Training time ({}):".format(model_type), classifier.training_time)
    classifier.evaluate_classifier(data_prep.X_test, data_prep.y_test, data_prep.X_test_cat1, data_prep.y_test_cat1, data_prep.X_test_cat2, data_prep.y_test_cat2)
    
############################### Print Results ###############################

# Define the folder path
folder_path = "evaluation_results"

# Define the full path of the output file
output_file = os.path.join(folder_path, model_type + ".txt")

# It is necessary to create the output file required for the Metrics module.
with open(output_file, 'w') as f:
    f.write("accuracy: {}\n".format(classifier.accuracy)) # Accuracy results
    f.write("f1 score: {}\n".format(classifier.f1)) # f1_score results
    f.write("precision: {}\n".format(classifier.precision)) # precision results
    f.write("fpr\ttpr\n") # Printing of TPR and FPR data for ROC plot.
    for i in range(len(classifier.fpr)):
        f.write("{}\t{}\n".format(classifier.fpr[i], classifier.tpr[i]))

            
    ############################### Metrics display ###############################
    
    # Print Roc and Confusion Matrix
    metrics_printer = mp.PrintMetrics(classifier.fpr, classifier.tpr, classifier.fpr_combined, classifier.tpr_combined, classifier.accuracy, classifier.f1, classifier.precision, classifier.accuracy_combined, classifier.f1_combined, classifier.precision_combined, data_prep.y_test, classifier.y_test_combined, classifier.predictions, classifier.predictions_combined)
    metrics_printer.plot_roc_curve()
    metrics_printer.print_metrics()


############################### End ###############################
