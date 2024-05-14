# Preliminary Analysis

Within the `Analysis` folder, you'll find the `Analysis.py` script, designed for conducting preliminary analysis on the dataset. Specifically, it generates and documents the following plots within the `python_plots` folder. This folder is automatically generated within the `Analysis` directory during the analysis process, and subsequently deleted by the bash file. However, it remains in the repository to showcase the results to the user.

### Main Results:

- **Histograms of Variables:** 
  - Histograms for all five variables are depicted for both signal and background classes. Notably, "var1" and "var2" exhibit considerable overlap between the two classes compared to the other variables, while "var4" demonstrates distinct class separation, indicating it plays a pivotal role in classification. The histograms of "var1", "var2", "var3", and "var4" showcase Gaussian distributions, while "eta" distribution is relatively uniform across both classes.
 
<p align="center">
  <img width=800" height="560" src="https://github.com/edorovati/SC-EXAM/blob/main/Analysis/python_plots/vars_histogram.png">
</p>

- **Normalised Variable Histograms:**
  - Histograms of normalised "var1", "var2", "var3", and "var4" are presented, confirming the same distributions as previously observed. These plots validate the efficacy of the normalisation procedure, with variables distributed in the range [-1, 1].
 
<p align="center">
  <img width="800" height="560" src="https://github.com/edorovati/SC-EXAM/blob/main/Analysis/python_plots/normalized_histogram.png">
</p>

- **Variable Distribution as a Function of "eta":**
  - The distribution of "var1", "var2", "var3", and "var4" relative to "eta" is illustrated, indicating no conspicuous variations between signal and background classes. Both classes exhibit uniform variable distributions within the range of eta [-1.3, 1.3], with noticeable shifts for absolute eta values exceeding 1.3. Categorisation is applied to this region due to discernible changes in variable trends.
 
<p align="center">
  <img width="800" height="560" src="https://github.com/edorovati/SC-EXAM/blob/main/Analysis/python_plots/scatter_eta_vs_vars.png">
</p>

- **Scatter Plots of Variables:**
  - Scatter plots of "var1", "var2", "var3", and "var4" against each other are displayed alongside the correlation matrix to examine potential correlations between training variables. Points in the scatter plots populate uniformly without distinct patterns or curves, indicating absence of correlation between variables. However, the scatterplot of variables against themselves appears as a straight line. While variable correlation can offer advantages such as noise reduction and pattern recognition facilitation, it may introduce redundant information and lead to overfitting. Notably, no significant differences are observed between signal and background events.
 
<p align="center">
  <img width="800" height="800" src="https://github.com/edorovati/SC-EXAM/blob/main/Analysis/python_plots/scatter_plot_vars_vs_vars.png">
</p>

- **Correlation Matrices:**
  - Correlation matrices are presented, showcasing variables absolutely correlated along the diagonals and weakly or not correlated otherwise, consistent with observations from scatter plots. Once again, no notable discrepancies are observed between signal and background events.
 
<p align="center">
  <img width="800" height="400" src="https://github.com/edorovati/SC-EXAM/blob/main/Analysis/python_plots/correlation_matrixes.png">
</p>
