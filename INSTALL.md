# 🚀 FPGA Toolchain Setup for Ubuntu 22.04

Welcome! This guide is your one-stop-shop for setting up the open-source iCE40 FPGA toolchain. We'll walk you through understanding, installing, and using the tools to bring your digital designs to life on the VSDSquadron FPGA board.

This guide is designed for beginners, so every step will be explained along the way.

### Table of Contents

1. [**Part 1: What Are We Installing? (The Concepts)**](#part-1-what-are-we-installing-the-concepts)
2. [**Part 2: How to Install the Tools on Ubuntu 22.04**](#part-2-how-to-install-the-tools-on-ubuntu-2204)
3. [**Part 3: Did It Work? (Verification)**](#part-3-did-it-work-verification)

[⬅️ Back to the Main README](README.md)

---

## Part 1: What Are We Installing? (The Concepts)

Before typing any commands, let’s understand the "digital construction crew" we’re about to assemble:

* **`Yosys` (The Synthesizer)** – The architect. It reads your Verilog code (the blueprint) and converts it into a logical description of digital components and wires (a netlist).
* **`nextpnr` (The Place & Route Tool)** – The city planner. It decides where each logical block will sit on the FPGA and how to route the wires between them.
* **`Project iCEstorm` (The Finalizer & Programmer)** – The final step:

  * `icepack` turns the layout into a `.bin` bitstream file the FPGA understands.
  * `iceprog` flashes the `.bin` onto the FPGA board.

---

## Part 2: How to Install the Tools on Ubuntu 22.04

We’ll install everything **from source** (latest versions, straight from developers).

### Option 1: Manual Installation (Recommended for Understanding)

#### **Step 2.1: Install Essential Dependencies**

```bash
# Update your package list
sudo apt-get update

# Install all dependencies
sudo apt-get install -y build-essential clang bison flex libreadline-dev \
gawk tcl-dev libffi-dev git graphviz xdot pkg-config python3 python3-dev \
libftdi-dev qtbase5-dev libboost-all-dev cmake libeigen3-dev zlib1g-dev python-is-python3
```

#### **Step 2.2: Upgrade CMake**

```bash
# Remove the old version
sudo apt-get remove -y cmake

# Download the installer
cd ~
wget https://github.com/Kitware/CMake/releases/download/v3.27.7/cmake-3.27.7-linux-x86_64.sh -O cmake_installer.sh

# Run the installer
chmod +x cmake_installer.sh
sudo ./cmake_installer.sh --prefix=/usr/local --skip-license

# Clean up and refresh PATH
rm cmake_installer.sh
hash -r
```

#### **Step 2.3: Install Yosys (Synthesis)**

```bash
cd ~
git clone https://github.com/YosysHQ/yosys.git
cd yosys
make -j$(nproc)
sudo make install
```

#### **Step 2.4: Install iCEstorm (Programming)**

```bash
cd ~
git clone https://github.com/YosysHQ/icestorm.git
cd icestorm
make -j$(nproc)
sudo make install
```

#### **Step 2.5: Install nextpnr (Place & Route)**

```bash
cd ~
git clone https://github.com/YosysHQ/nextpnr.git
cd nextpnr
cmake . -B build -DARCH=ice40 -DCMAKE_INSTALL_PREFIX=/usr/local
cmake --build build -j$(nproc)
sudo cmake --install build
```

---

### Option 2: Automated Script (The Easy Way)

If you prefer a hands-off approach, this single script performs all the manual steps above automatically.

1.  Save the script below as `install_fpga_tools.sh`.
2.  Make it executable with the command: `chmod +x install_fpga_tools.sh`
3.  Run it from your terminal with: `./install_fpga_tools.sh`
<details>
<summary><strong>➡️ Click here to view the all-in-one installation script</strong></summary>

```bash
#!/bin/bash
# Automated iCE40 FPGA toolchain installation on Ubuntu 22.04
set -e
echo "--- Starting Automated FPGA Toolchain Installation ---"

echo ">>> [STEP 1/6] Installing dependencies..."
sudo apt-get update
sudo apt-get install -y build-essential clang bison flex libreadline-dev gawk tcl-dev libffi-dev git graphviz xdot pkg-config python3 python3-dev libftdi-dev qtbase5-dev libboost-all-dev cmake libeigen3-dev zlib1g-dev python-is-python3

echo ">>> [STEP 2/6] Upgrading CMake..."
sudo apt-get remove -y cmake
cd ~
wget https://github.com/Kitware/CMake/releases/download/v3.27.7/cmake-3.27.7-linux-x86_64.sh -O cmake_installer.sh
chmod +x cmake_installer.sh
sudo ./cmake_installer.sh --prefix=/usr/local --skip-license
rm cmake_installer.sh
hash -r

echo ">>> [STEP 3/6] Installing Yosys..."
cd ~
git clone https://github.com/YosysHQ/yosys.git
cd yosys
make -j$(nproc)
sudo make install

echo ">>> [STEP 4/6] Installing iCEstorm..."
cd ~
git clone https://github.com/YosysHQ/icestorm.git
cd icestorm
make -j$(nproc)
sudo make install

echo ">>> [STEP 5/6] Installing nextpnr..."
cd ~
git clone https://github.com/YosysHQ/nextpnr.git
cd nextpnr
cmake . -B build -DARCH=ice40 -DCMAKE_INSTALL_PREFIX=/usr/local
cmake --build build -j$(nproc)
sudo cmake --install build

echo ""
echo "--- ✅ FPGA Toolchain Installation Complete! ---"
echo "Proceed to Part 3 to verify the installation."
```

</details>

---

## Part 3: Did It Work? (Verification)

Open a new terminal and run these:

#### **Check Yosys**

```bash
yosys --version
```
Expect: `Yosys 0.38...`

#### **Check nextpnr**

```bash
nextpnr-ice40 --version
```
Expect: `nextpnr-ice40 v0.6...`

#### **Check icepack**

```bash
icepack --help
```
Should show usage/help.

#### **Check iceprog**

```bash
iceprog --help
```
Should show usage/help.
---
