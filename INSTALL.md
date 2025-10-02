# FPGA Toolchain Setup & Project Workflow 🚀

Welcome! This guide is your one-stop-shop for setting up the open-source iCE40 FPGA toolchain. We'll walk you through understanding, installing, and using the tools to bring your digital designs to life on the VSDSquadron FPGA board.

This document is designed for beginners, so we'll explain every step along the way.

### Table of Contents
1.  [**Part 1: What Are We Installing? (The Concepts)**](#part-1-what-are-we-installing-the-concepts)
2.  [**Part 2: How to Install the Tools on Ubuntu 22.04**](#part-2-how-to-install-the-tools-on-ubuntu-2204)
3.  [**Part 3: Did It Work? (Verification)**](#part-3-did-it-work-verification)

[⬅️ Back to the Main README](README.md)

---

## Part 1: What Are We Installing? (The Concepts)

Before we type any commands, let's understand the "digital construction crew" we're about to assemble.

* **`Yosys` (The Synthesizer)**: The architect. It reads your Verilog code (the blueprint) and converts it into a logical description of digital components and wires (a netlist).

* **`nextpnr` (The Place & Route Tool)**: The city planner. It takes the logical components from Yosys and decides where each one will physically sit on the FPGA chip. Then, it figures out how to route all the tiny wires between them.

* **`Project iCEstorm` (The Finalizer & Programmer)**: This is a toolkit for the final steps.
    * `icepack` turns the physical layout from `nextpnr` into the final binary `.bin` file (the bitstream) that the chip understands.
    * `iceprog` takes that `.bin` file and loads (flashes) it onto the FPGA board.

---

## Part 2: How to Install the Tools on Ubuntu 22.04

This section will guide you through the installation process.

> **A Quick Note: Why Install "From Source"?**
> We are going to download the raw source code for these tools and compile it ourselves. This is called "installing from source." We do this because it guarantees we get the absolute latest versions directly from the developers, which often contain important features and bug fixes not available in standard software repositories.

### Option 1: Manual Installation (Recommended for Understanding)

This method walks you through installing each tool one by one. It's the best way to understand what's happening.

#### **Step 2.1: Install Essential Dependencies**
First, we need to install the basic tools and libraries that our FPGA tools depend on.

```bash
# Update your package list
sudo apt-get update

# Install all dependencies with one command
sudo apt-get install -y build-essential clang bison flex libreadline-dev \
gawk tcl-dev libffi-dev git graphviz xdot pkg-config python3 python3-dev \
libftdi-dev qtbase5-dev libboost-all-dev cmake libeigen3-dev zlib1g-dev python-is-python3
```

#### **Step 2.2: Upgrade Cmake**
nextpnr requires a newer version of CMake than Ubuntu provides by default. Let's upgrade it.

```bash
# Remove the old version
sudo apt-get remove -y cmake

# Go to your home directory
cd ~

# Download the installer (as of Oct 2025, v3.27.7 is recent)
wget [https://github.com/Kitware/CMake/releases/download/v3.27.7/cmake-3.27.7-linux-x86_64.sh](https://github.com/Kitware/CMake/releases/download/v3.27.7/cmake-3.27.7-linux-x86_64.sh) -O cmake_installer.sh

# Run the installer
chmod +x cmake_installer.sh
sudo ./cmake_installer.sh --prefix=/usr/local --skip-license

# Clean up and refresh the command path
rm cmake_installer.sh
hash -r
```
#### **Step 2.3: Install Yosys (Synthesis)**
Now, let's build our "architect."

```bash
# Go to your home directory
cd ~

# Download the source code
git clone [https://github.com/YosysHQ/yosys.git](https://github.com/YosysHQ/yosys.git)

# Go into the new folder
cd yosys

# Compile the code (this may take a few minutes)
make -j$(nproc)

# Install it system-wide
sudo make install
```

#### **Step 2.4 Install icestorm (Programming)**
Next, we'll build the tools that pack the bitstream and talk to the board

```bash
# Go to your home directory
cd ~

# Download the source code
git clone [https://github.com/YosysHQ/icestorm.git](https://github.com/YosysHQ/icestorm.git)

# Go into the new folder
cd icestorm

# Compile the code
make -j$(nproc)

# Install it system-wide
sudo make install
```

#### **Step 2.5 Install nextpnr (Place & Route)**
Finally, let's build our "city planner"
```bash
# Go to your home directory
cd ~

# Download the source code
git clone [https://github.com/YosysHQ/nextpnr.git](https://github.com/YosysHQ/nextpnr.git)

# Go into the new folder
cd nextpnr

# Configure the build for iCE40 FPGAs
cmake . -B build -DARCH=ice40 -DCMAKE_INSTALL_PREFIX=/usr/local

# Compile the code (this may take a few minutes)
cmake --build build -j$(nproc)

# Install it system-wide
sudo cmake --install build
```
### Option 2: Automated Script(The easy way)
Instead of manually installing each tool, below is the combined script
```bash
#!/bin/bash
# This script automates the installation of the iCE40 FPGA toolchain on Ubuntu 22.04.
set -e
echo "--- Starting Automated FPGA Toolchain Installation ---"

echo ">>> [STEP 1/6] Installing all necessary dependencies..."
sudo apt-get update
sudo apt-get install -y build-essential clang bison flex libreadline-dev gawk tcl-dev libffi-dev git graphviz xdot pkg-config python3 python3-dev libftdi-dev qtbase5-dev libboost-all-dev cmake libeigen3-dev zlib1g-dev python-is-python3

echo ">>> [STEP 2/6] Upgrading CMake..."
sudo apt-get remove -y cmake
cd ~
wget [https://github.com/Kitware/CMake/releases/download/v3.27.7/cmake-3.27.7-linux-x86_64.sh](https://github.com/Kitware/CMake/releases/download/v3.27.7/cmake-3.27.7-linux-x86_64.sh) -O cmake_installer.sh
chmod +x cmake_installer.sh
sudo ./cmake_installer.sh --prefix=/usr/local --skip-license
rm cmake_installer.sh
hash -r

echo ">>> [STEP 3/6] Building and installing Yosys..."
cd ~
git clone [https://github.com/YosysHQ/yosys.git](https://github.com/YosysHQ/yosys.git)
cd yosys
make -j$(nproc)
sudo make install

echo ">>> [STEP 4/6] Building and installing iCEstorm..."
cd ~
git clone [https://github.com/YosysHQ/icestorm.git](https://github.com/YosysHQ/icestorm.git)
cd icestorm
make -j$(nproc)
sudo make install

echo ">>> [STEP 5/6] Building and installing nextpnr..."
cd ~
git clone [https://github.com/YosysHQ/nextpnr.git](https://github.com/YosysHQ/nextpnr.git)
cd nextpnr
cmake . -B build -DARCH=ice40 -DCMAKE_INSTALL_PREFIX=/usr/local
cmake --build build -j$(nproc)
sudo cmake --install build

echo ""
echo "--- ✅ FPGA Toolchain Installation Complete! ---"
echo "Proceed to Part 3 to verify the installation."
```

## Part 3: Did it work? (Verification)
After installing, it's crucial to check that each tool is working. Open a new terminal and run these commands.
#### Check Yosys:
```bash
yosys --version
```
#### Check nextpnr:
```bash
nextpnr-ice40 --version
```

#### Check icepack:
```bash 
icepack --help
```

#### Check iceprog:
```bash
iceprog --help
```
If all four commands run without errors, your toolchain is ready!
