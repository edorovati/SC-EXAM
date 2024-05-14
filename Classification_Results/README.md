# Main Results:
The main goal of the TMVA analysis is to show the improvement brought by the introduction of the categories; looking at the distribution of "vars1", "vars2", "vars3" and "vars4" as a function of "eta", a change in trend is evident for the value eta=+/-1.3 (see Analysis.py results). This means that isolating the two categories allows to train the feature with a more obvious similarity with respect to the whole dataset and leads to an improved performance, as shown in the TMVA analysis results. The ROC is higher for the LikelihoodCst methods (0.912), followed by FisherCat with 0.911 and HMatrixCat with 0.890; the methods without categories have lower values (from 0.810 for Fisher to 0.759 for H-Matrix). The signal efficiency for the test data set, computed at 30% of the background, is this time higher for the HMstricCat method (0.916), with 0.915 for the LikelihoodCat and 0.909 for the FisherCat; the categorisation again leads to better performances, as the values for Fisher, Likelihood and H-Matrix with input categories are 0.738, 0.630 and 0.740 respectively.

<p align="center">
  <img width="500" height="380" src="https://github.com/edorovati/SC-EXAM/blob/main/Classification_Results/TMVA_ROC.png">
</p>

The improvement is less obvious, but still present in the Python code; probably this is due to the fact that the Python models chosen show better performances with respect to the TMVA ones, making a further improvement difficult; in general, the ROC curve shows higher performances for the Neural Network, but very close to the BDT and to the kNN curves. The lower curve seems to be that of SVT, although the models perform very similarly and there are no major differences.

<p align="center">
  <img width="500" height="380" src="https://github.com/edorovati/SC-EXAM/blob/main/Classification_Results/Comparative_ROC.png">
</p>

The models are evaluated throughout in terms of accuracy, precision, recall and f1-score:
- Accuracy is the number of correct predictions over the total number of predictions made by the model;
- Precision is the number of correct true predictions over the total number of true predictions made by the model;
- Recall is the ability of the model to correctly recognise the positive predictions: is the number of true positives over the sum of true positives and false negatives;
- The F1 score is the weighted average between precision and recall;

All these metrics show values around 75% when the whole dataset is trained together, while they reach around 85% when the categorisation is implemented; even in this case, slightly higher values are given by the Neural Network, the BDT and the KNN, while the lower ones are given by the SVT.
The above-mentioned values are printed on the screen for both the categorisation and training of the entire dataset; for accuracy, simply the value is reported, whereas for the other metrics, the value is reported for both the signal class (1) and background (0).

The confusion matrix is instead displayed in the form of an image for each model, for analysis with and without the categories; in general for the former case an improvement is evident: oughly all models show, out of 4000 test data, 1400 true positive events and 1500 true negative events without categories, values that rise to 1600 and 1700 respectively with the introduction of the categories. 

Finally, the importance of the features for classification is also shown: all models rely most on "vars4" for classification, which has the more distinct distribution between signal and background; looking at the histograms of the other three variables, the signal and background distributions appear more overlapped. This means that "vars4" carries more useful information for the classification goal. The only model that differs is the kNN: since it is based on the similarity between the data, all the features are treated in the same way: the similarity concept is seen as distances between points in the feature space, and such a distance is calculated for all the features for classification.

In the following all the above-mentioned images are display for each model: BDT, Neural Network, Random Forest, SVT and kNN, respectively.

### BDT results:
<p align="center">
  <img width="350" height="250" src="https://github.com/edorovati/SC-EXAM/blob/main/Classification_Results/BDT/BDT_CM.png">
  <img width="350" height="250" src="https://github.com/edorovati/SC-EXAM/blob/main/Classification_Results/BDT/BDT_cat_CM.png">
  <img width="350" height="250" src="https://github.com/edorovati/SC-EXAM/blob/main/Classification_Results/BDT/BDT_ROC.png">
  <img width="350" height="250" src="https://github.com/edorovati/SC-EXAM/blob/main/Classification_Results/BDT/BDT_vars.png">
</p>

### Neural Network results:
<p align="center">
  <img width="350" height="250" src="https://github.com/edorovati/SC-EXAM/blob/main/Classification_Results/NN/NN_CM.png">
  <img width="350" height="250" src="https://github.com/edorovati/SC-EXAM/blob/main/Classification_Results/NN/NN_cat_CM.png">
  <img width="350" height="250" src="https://github.com/edorovati/SC-EXAM/blob/main/Classification_Results/NN/NN_ROC.png">
  <img width="350" height="250" src="https://github.com/edorovati/SC-EXAM/blob/main/Classification_Results/NN/NN_vars.png">
</p>

### Random Forest results:
<p align="center">
  <img width="350" height="250" src="https://github.com/edorovati/SC-EXAM/blob/main/Classification_Results/RF/RF_CM.png">
  <img width="350" height="250" src="https://github.com/edorovati/SC-EXAM/blob/main/Classification_Results/RF/RF_cat_CM.png">
  <img width="350" height="250" src="https://github.com/edorovati/SC-EXAM/blob/main/Classification_Results/RF/RF_ROC.png">
  <img width="350" height="250" src="https://github.com/edorovati/SC-EXAM/blob/main/Classification_Results/RF/RF_vars.png">
</p>

### SVT results:
<p align="center">
  <img width="350" height="250" src="https://github.com/edorovati/SC-EXAM/blob/main/Classification_Results/SVT/SVT_CM.png">
  <img width="350" height="250" src="https://github.com/edorovati/SC-EXAM/blob/main/Classification_Results/SVT/SVT_cat_CM.png">
  <img width="350" height="250" src="https://github.com/edorovati/SC-EXAM/blob/main/Classification_Results/SVT/SVT_ROC.png">
  <img width="350" height="250" src="https://github.com/edorovati/SC-EXAM/blob/main/Classification_Results/SVT/SVT_vars.png">
</p>

### kNN results:
<p align="center">
  <img width="350" height="250" src="https://github.com/edorovati/SC-EXAM/blob/main/Classification_Results/kNN/kNN_CM.png">
  <img width="350" height="250" src="https://github.com/edorovati/SC-EXAM/blob/main/Classification_Results/kNN/kNN_cat_CM.png">
  <img width="350" height="250" src="https://github.com/edorovati/SC-EXAM/blob/main/Classification_Results/kNN/kNN_ROC.png">
  <img width="350" height="250" src="https://github.com/edorovati/SC-EXAM/blob/main/Classification_Results/kNN/kNN_vars.png">
</p>

## Conclusions:
The main goal of this code is to show how categorisation improves the results; in particular, the training dataset is divided according to the values of a spectator variables. It allows to train feature with more similar behaviour, improving reliability of the trained model. This is visible both on python and TMVA codes.
It is also important to note that not all variables are equally employed for training; in particular, it seems that "var4" is the more useful to discriminate signal and background: it is also visible from its distribution of signal and background. All the methods employed rely more on "var4" except for the kNN, since it discriminate among signal and background events just looking to the vicinity concept, equally for all the feature.

