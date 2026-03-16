#!/usr/bin/env bash

# This script sets up a Python virtual environment and installs dependencies.
# Note that this script is designed to be run in POSIX-compatible environments
# which use Bash.

# Dependencies list.
declare -a packages=("qiskit" "qiskit-aer" "qiskit-algorithms" "matplotlib" "pylatexenc" "qiskit-finance" "qiskit-optimization")

venv="$PWD/venv"

# Check if Python is installed. Prefer python3, but fall back to python.
if command -v python3 &>/dev/null; then
  python="python3"
elif command -v python &>/dev/null; then
  python="python"
else
  echo "Error: failed to find Python in PATH"
  exit 1
fi

# Check if virtual environment exists. If no, create it.
if [[ ! -d "$venv" ]] || [[ -z "$venv" ]]; then
  echo "Creating virtual environment at $venv..."
  if "$python" -m venv "$venv"; then
    echo "Successfully created virtual environment"
  else
    echo "Error: failed to create virtual environment"
    exit 1
  fi
else
  echo "Using virtual environment at $venv"
fi

# Resolve Python and pip paths based on the actual venv layout.
if [[ -x "$venv/Scripts/python.exe" ]] && [[ -x "$venv/Scripts/pip.exe" ]]; then
  python_path="$venv/Scripts/python.exe"
  pip_path="$venv/Scripts/pip.exe"
elif [[ -x "$venv/bin/python" ]] && [[ -x "$venv/bin/pip" ]]; then
  python_path="$venv/bin/python"
  pip_path="$venv/bin/pip"
else
  echo "Error: failed to find a usable Python environment inside $venv"
  exit 1
fi

# Install package dependencies.
for i in "${packages[@]}"; do
  # Check if the package is installed. If no, install package.
  if ! "$pip_path" list --disable-pip-version-check | grep -E "^$i " &>/dev/null; then
    echo "Installing $i..."

    # Install package.
    if "$pip_path" install --quiet --disable-pip-version-check "$i"; then
      echo "Successfully installed $i"
    else
      echo "Error: failed to install $i"
    fi
  else
    echo "$i is installed"
  fi
done