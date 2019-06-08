#!/bin/bash
#
# Test the wheel file in a new Anaconda environment

# Handle errors
source scripts/dev/includes/error_handling.sh

# Include constants
source scripts/dev/includes/constants.sh

# Get arguments
WHEEL_FILENAME=$1

# Print the goal of this script
echo "Test the wheel file $WHEEL_FILENAME"

################################################################################
# Clean Up Old Stuff
################################################################################

echo "Clean up old stuff"

# Remove the old Conda environment
conda remove -y -n "$TEST_CONDA_ENV_NAME" --all

# Remove the test directory
rm -rf "$TEST_DIR"

################################################################################
# Set Up
################################################################################

echo "Set up"

# Create a Conda environment
conda create -y -n "$TEST_CONDA_ENV_NAME" python=$TEST_PYTHON_VERSION

# Activate the Conda environment
source activate "$TEST_CONDA_ENV_NAME"

# Install the wheel file
pip install "$WHEEL_FILENAME"

# Create a new temporary directory
mkdir -p "$TEST_DIR"

# Copy the examples to the test directory
cp -r "examples/" "$TEST_DIR/examples/"

# Change the working directory to the test directory
cd "$TEST_DIR"

################################################################################
# Run Tests
################################################################################

echo "Run tests"

# Run the examples
noodles run examples/two_locals/spec.yml
noodles clean examples/two_locals/clean.yml

################################################################################
# Tear Down
################################################################################

echo "Tear down"

# Change the working directory back to the root directory
cd -

# Remove the test directory
rm -rf "$TEST_DIR"

# Deactivate the Conda environment
source deactivate

# Remove the Conda environment
conda remove -y -n "$TEST_CONDA_ENV_NAME" --all

################################################################################
# Print Success Message
################################################################################

echo "Successfully tested the wheel file $WHEEL_FILENAME"
