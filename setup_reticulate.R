# Setup script to install Python packages for reticulate
# Run this script in R to set up your Python environment

# Load reticulate
library(reticulate)

# Check if Python is available
if (!py_available()) {
  cat("Python is not available. Please install Python first.\n")
  cat("You can install Python from: https://www.python.org/downloads/\n")
  cat("Or use: install.packages('reticulate')\n")
  cat("Then run: reticulate::install_python()\n")
} else {
  cat("Python is available!\n")
  cat("Python version:", py_config()$version, "\n")
}

# Install packages from requirements.txt
# This will install all packages listed in requirements.txt
cat("Installing Python packages from requirements.txt...\n")

# Method 1: Use py_run_string to execute pip install -r requirements.txt
tryCatch({
  py_run_string("
import subprocess
import sys
result = subprocess.run([sys.executable, '-m', 'pip', 'install', '-r', 'requirements.txt'], 
                       capture_output=True, text=True)
if result.returncode == 0:
    print('Successfully installed packages from requirements.txt')
else:
    print('Error installing packages:', result.stderr)
")
}, error = function(e) {
  cat("Method 1 failed, trying alternative approach...\n")
})

# Method 2: Install key packages individually (if the above doesn't work)
cat("Installing key packages individually...\n")
key_packages <- c(
  "pandas==2.3.2",
  "numpy==2.3.2", 
  "scikit-learn==1.7.2",
  "matplotlib==3.10.5",
  "seaborn==0.13.2",
  "scipy==1.16.2",
  "statsmodels==0.14.5"
)

for (pkg in key_packages) {
  cat("Installing", pkg, "...\n")
  tryCatch({
    py_install(pkg, pip = TRUE)
    cat("✓ Successfully installed", pkg, "\n")
  }, error = function(e) {
    cat("✗ Failed to install", pkg, ":", e$message, "\n")
  })
}

cat("Installation complete!\n")
cat("You can now run your index.qmd file with both R and Python code.\n")
