import uproot
import numpy as np
import matplotlib.pyplot as plt
import os

'''---------------------DATA LOADING-------------------------------------------'''

# Creates the directory if it does not exist
output_folder = "python_plots"
if not os.path.exists(output_folder):
    os.makedirs(output_folder)

#Folder containing the trees
folder_path = "data"

#Uploading the root file
file_path = os.path.join(folder_path, "toy_sigbkg_categ_offset.root")
file = uproot.open(file_path)

#Catching the signal and background tree
sig_tree = file["TreeS"]
bkg_tree = file["TreeB"]

# Printing the number of entries for signal and background
num_signals = sig_tree.num_entries
num_backgrounds = bkg_tree.num_entries

print("Number of events in the signal dataset:", num_signals)
print("Number of events in the background dataset:", num_backgrounds)


#Extracting the varibales from the signal and background trees
signal_arrays = sig_tree.arrays()
bkg_arrays = bkg_tree.arrays()

var1_signal = signal_arrays["var1"]
var2_signal = signal_arrays["var2"]
var3_signal = signal_arrays["var3"]
var4_signal = signal_arrays["var4"]
eta_signal=signal_arrays["eta"]

var1_background = bkg_arrays["var1"]
var2_background = bkg_arrays["var2"]
var3_background = bkg_arrays["var3"]
var4_background = bkg_arrays["var4"]
eta_background=bkg_arrays["eta"]

'''-------------------------------HISOGRAMS--------------------------------------------'''


# Plotting the histogram for all the variables
plt.figure(figsize=(10, 8))

plt.subplot(2, 3, 1)
plt.hist(var1_signal, bins=50, alpha=0.5, label='Signal')
plt.hist(var1_background, bins=50, alpha=0.5, label='Background')
plt.xlabel('var1')
plt.ylabel('Counts')
plt.legend()

plt.subplot(2, 3, 2)
plt.hist(var2_signal, bins=50, alpha=0.5, label='Signal')
plt.hist(var2_background, bins=50, alpha=0.5, label='Background')
plt.xlabel('var2')
plt.ylabel('Counts')
plt.legend()

plt.subplot(2, 3, 3)
plt.hist(var3_signal, bins=50, alpha=0.5, label='Signal')
plt.hist(var3_background, bins=50, alpha=0.5, label='Background')
plt.xlabel('var3')
plt.ylabel('Counts')
plt.legend()

plt.subplot(2, 3, 4)
plt.hist(var4_signal, bins=50, alpha=0.5, label='Signal')
plt.hist(var4_background, bins=50, alpha=0.5, label='Background')
plt.xlabel('var4')
plt.ylabel('Counts')
plt.legend()

plt.subplot(2, 3, 5)
plt.hist(eta_signal, bins=50, alpha=0.5, label='Signal')
plt.hist(eta_background, bins=50, alpha=0.5, label='Background')
plt.xlabel('eta')
plt.ylabel('Counts')
plt.legend()

plt.savefig(os.path.join(output_folder, "vars_histogram.png"))
plt.tight_layout()
plt.show()

'''-----------------------------NORMALIZATION-----------------------------'''

# Conversion into numpy arrays
var1_signal_np = var1_signal.to_numpy()
var2_signal_np = var2_signal.to_numpy()
var3_signal_np = var3_signal.to_numpy()
var4_signal_np = var4_signal.to_numpy()

var1_background_np = var1_background.to_numpy()
var2_background_np = var2_background.to_numpy()
var3_background_np = var3_background.to_numpy()
var4_background_np = var4_background.to_numpy()

# Computing the maximum for each variables
max_var1_signal = var1_signal_np.max()
max_var2_signal = var2_signal_np.max()
max_var3_signal = var3_signal_np.max()
max_var4_signal = var4_signal_np.max()

max_var1_background = var1_background_np.max()
max_var2_background = var2_background_np.max()
max_var3_background = var3_background_np.max()
max_var4_background = var4_background_np.max()

# Signal and background data are divided by the maximum to be normalized
var1_signal_normalized = var1_signal / max_var1_signal
var2_signal_normalized = var2_signal / max_var2_signal
var3_signal_normalized = var3_signal / max_var3_signal
var4_signal_normalized = var4_signal / max_var4_signal

var1_background_normalized = var1_background / max_var1_background
var2_background_normalized = var2_background / max_var2_background
var3_background_normalized = var3_background / max_var3_background
var4_background_normalized = var4_background / max_var4_background

'''-------------------NORMALIZATION_HISTOGRAMS---------------------------------------'''

variables_signal = [var1_signal, var2_signal, var3_signal, var4_signal]
variables_background = [var1_background, var2_background, var3_background, var4_background]

# Histograms of normalized variables
plt.figure(figsize=(10, 8))

plt.subplot(2, 2, 1)
plt.hist(var1_signal_normalized, bins=50, alpha=0.5, label='Signal (Normalized)')
plt.hist(var1_background_normalized, bins=50, alpha=0.5, label='Background (Normalized)')
plt.xlabel('var1 (Normalized)')
plt.ylabel('Counts')
plt.legend()

plt.subplot(2, 2, 2)
plt.hist(var2_signal_normalized, bins=50, alpha=0.5, label='Signal (Normalized)')
plt.hist(var2_background_normalized, bins=50, alpha=0.5, label='Background (Normalized)')
plt.xlabel('var2 (Normalized)')
plt.ylabel('Counts')
plt.legend()

plt.subplot(2, 2, 3)
plt.hist(var3_signal_normalized, bins=50, alpha=0.5, label='Signal (Normalized)')
plt.hist(var3_background_normalized, bins=50, alpha=0.5, label='Background (Normalized)')
plt.xlabel('var3 (Normalized)')
plt.ylabel('Counts')
plt.legend()

plt.subplot(2, 2, 4)
plt.hist(var4_signal_normalized, bins=50, alpha=0.5, label='Signal (Normalized)')
plt.hist(var4_background_normalized, bins=50, alpha=0.5, label='Background (Normalized)')
plt.xlabel('var4 (Normalized)')
plt.ylabel('Counts')
plt.legend()

plt.savefig(os.path.join(output_folder, "normalized_histogram.png"))
plt.tight_layout()
plt.show()

'''------------------------SCATTER_PLOTS-------------------------------'''

# Scatter plot for vars1, vars2, vars3, vars4
#all the variables are printed as a function of each other

variables_signal = [var1_signal, var2_signal, var3_signal, var4_signal]
variables_background = [var1_background, var2_background, var3_background, var4_background]
fig, axs = plt.subplots(4, 4, figsize=(10, 10))

for i in range(4):
    for j in range(4):
            axs[i, j].scatter(variables_signal[j], variables_signal[i], alpha=0.5)
            axs[i, j].scatter(variables_background[j], variables_background[i], alpha=0.5)
            axs[i, j].set_xlabel(f'var{j+1}')
            axs[i, j].set_ylabel(f'var{i+1}')
            axs[i, j].legend(['Signal', 'Background'])
    
plt.savefig(os.path.join(output_folder, f"scatter_plot_vars_vs_vars.png"))
plt.tight_layout()
plt.show()

'''--------------------ETA_DEPENDENCE------------------------------------------'''


# Plotting each variables in function of eta
fig, axs = plt.subplots(2, 2, figsize=(10, 10))

for i, (var_s, var_b) in enumerate(zip(variables_signal, variables_background)):
    row = i // 2  # Calcolo della riga
    col = i % 2   # Calcolo della colonna
    axs[row, col].scatter(eta_signal, var_s, alpha=0.5)
    axs[row, col].scatter(eta_background, var_b, alpha=0.5)
    axs[row, col].set_xlabel('eta')
    axs[row, col].set_ylabel(f'var{i+1}')
    axs[row, col].legend(['Signal', 'Background'])

plt.savefig(os.path.join(output_folder, f"scatter_eta_vs_var{i+1}.png"))
plt.tight_layout()
plt.show()

'''--------------------CORRELATION MATRIXES----------------------------------------'''
#Put the numpy arrays of each variable into columns and then calculate the transposed
X_signal = np.vstack((var1_signal_np, var2_signal_np, var3_signal_np, var4_signal_np)).T
X_background = np.vstack((var1_background_np, var2_background_np, var3_background_np, var4_background_np)).T

# Computing correlation matrix
# rowvar=False means that the columns represent the variables and the rows the observations
signal_corr_matrix = np.corrcoef(X_signal, rowvar=False)
background_corr_matrix = np.corrcoef(X_background, rowvar=False)

# Definition of the variables name
variable_names = ['var1', 'var2', 'var3', 'var4']

# Plot of the correlation matrix
plt.figure(figsize=(10, 5))
plt.subplot(1, 2, 1)
plt.imshow(signal_corr_matrix, cmap='coolwarm', aspect='auto')
plt.title('Signal Correlation Matrix')
plt.xticks(ticks=np.arange(len(variable_names)), labels=variable_names)
plt.yticks(ticks=np.arange(len(variable_names)), labels=variable_names)
plt.colorbar()

plt.subplot(1, 2, 2)
plt.imshow(background_corr_matrix, cmap='coolwarm', aspect='auto')
plt.title('Background Correlation Matrix')
plt.xticks(ticks=np.arange(len(variable_names)), labels=variable_names)
plt.yticks(ticks=np.arange(len(variable_names)), labels=variable_names)
plt.colorbar()

plt.savefig(os.path.join(output_folder, f"correlation_matrixes.png"))
plt.tight_layout()
plt.show()


