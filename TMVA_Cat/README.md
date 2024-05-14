# ClassificationCategory.C
The TMVA training phase begins with the initialization of a factory object containing configuration options. The output histograms and trees are then written to a user-created root file. Configuration options include:

- **Verbose Flag:** Controls the verbosity of the output.
- **Colored Screen Output:** Enables colored output on the screen (Color=True).
- **Transformations List:** Specifies transformations to be applied (I;D;P;G,D= Identity, Decorrelation, PCA, Gaussian+Decorrelation).
- **Output Visualization Flag:** Determines whether output visualization is enabled (Silent=False).
- **Progress Visualization:** Controls visualization of training, testing, and evaluation progress (DrawProgressBar=True).

The training dataset is loaded using the DataLoader object. Input variables are specified using the AddVariable method, which takes the variable name as a string and its type ("F"=float, including double).  Signal and background events are in two different trees: in our code, the same weight is given to both and no additional cuts are used to distinguish between the two classes. The "AddSpectator" method is used to add variables that are not used during the training, the test or the evaluation ("eta" in this case), called spectator variables; they are copied into the tree and used for correlation tests.

Next, the dataset is split into training and testing parts using the `PrepareTrainingAndTestTree()` method, which offers several options:

- **nTrain_Signal and nTrain_Background:** Indicate the number of events for training; if they are set to zero, the whole dataset is used (the same for testing).
- **SplitMode:** Determines how events are chosen (`Random`, `Alternate`, `Block`), with the option to set the seed of the random generator for reproducibility. _SplitSeed=0_ corresponds to a different series of numbers each time, while for SplitSeed=100 the generator uses the same series each time TMVA is run.
- **NormMode:** Implements data normalization, with NumEvents being the default choice.

The methods are then booked, trained, tested and evaluated: the booking method takes as arguments the selected method as a unique type enumerator, the user-defined name and a list of configuration options including PDF histogram settings, as the interpolation method, the number of bins and the number of smoothing cycles. The following methods are chosen:

1. **Fisher Discriminants:** The classification is performed in a space of transformed variables with zero linear correlation, by distinguishing the means of the signal and background distributions; in this way, projecting the two classes in the new space, events of the same class are very close to each other.
2. **Likelihood:** It builds PDFs that reproduce the input variables for signal and background; the likelihood of belonging to a class for each event is obtained by multiplying the signal probability densities of all the input variables, which are assumed to be independent, and normalising it by the sum of the signal and background likelihoods. signal and background likelihoods. Correlations between the variables are ignored, so this approach is also called "naive Bayes estimator".
3. **H-Matrix:** : Gaussian classifier commonly used to discriminate one class (signal) of a feature vector from another (background); the correlated elements of the vector are assumed to be Gaussian distributed and the inverse of the covariance matrix is the H-Matrix. Discrimination is done by exploring differences in the mean of the vector elements and works very similarly to the Fisher discriminant, so it is implemented as a comparison.

The data set is then divided into two different parts according to the absolute value of the variable eta, so for each method two categories are defined using the option `TMVA::Types::kCategory`. The Category method allows the user to divide the training data into disjoint subpopulations with different characteristics, going beyond a simple subclassification of the original feature space.

Independent training is performed in each of these disjoint regions, thus reducing the correlation between the training variables, improving the modelling and consequently increasing the classification performance. The method takes as first argument the region where each of the sub-classifiers is applied, the second argument is present if not alla variables are considered for such a category, the third argument is the internal enumerator to specify the classifier (which can be different for the two categories), the fourth method is the user-defined name and finally the fifth argument are the configuration options. 

The first three methods are compared with the case where categories are used, and for all of them an improvement is visible when looking at the ROC curve and the ROC-integer value.

