# Task 01: led_blue

## 1. Verilog code functionality

* In the `top.v` file, I analyzed the inbuilt primitives of the **iCE40UP5K** and learnt about the `SB_RAM`, `SB_PLL`, `SB_I2C`, and `SB_SPI` primitives in this FPGA.
* Learnt the distinction between **Hard IP** and **Soft IP**. Hard IP is a pre-designed and fabricated circuit in the FPGA ready for use and is different from soft ip which I worked on Artix-7 FPGA with the Vivado IP Catalog.
* To make the LED colour blue permanent, the `SB_RGBA_DRV` primitive is not actually required, as it is used for PWM modulation of R, G, and B to produce a blend of new colours.
* The `SB_HFOSC` primitive is used to produce 4 clock signals by dividing the FPGA's inbuilt 48MHz crystal oscillator. The `DIV` parameter is used to get the following frequencies:
    * `"0b00"` = 48 Mhz
    * `"0b01"` = 24 Mhz
    * `"0b10"` = 12 Mhz
    * `"0b11"` = 6 Mhz
* The `defparam` statement is used to modify constants like `RGB_CURRENT`, which controls the brightness of the LED. I also got to know a value of `0` is forbidden, and higher brightness draws more current and can damage the circuit.

### Code Modifications
* I got the idea of using the clock divider and `test_wire` to control the blue LED by passing it as the PWM signal to the `SB_RGBA_DRV` primitive.
* Modified the clock divider to make a 1Hz clock to see the blinking and used the `test_wire` as `blink_enable`.
* Thus, I connected the `blink_enable` wire to I/O pin 3 and added logic in the program such that if `blink_enable` is high, it should make the `blue_led` blink.

---

## 2. Pin Mapping Details (PCF File)

| Logic Signal Name | Physical Pin Name (Board) |
| :---------------- | :------------------------ |
| `led_red`         | **39** |
| `led_blue`        | **40** |
| `led_green`       | **41** |
| `clk_12Mhz`       | **20** |
| `blink_enable`    | **3** |

---

## 3. Challenges Faced and Solutions Implemented
### Blink_enable and ground connection
When the wire is connected to ground, as expected the blinking is disabled but when i remove the wire it blinks eventhough i enabled blink when the wire is connected to supply, i understood that when the io pin is in open impedance(floating) there is a weak pull up internal resistor which causes the power supply and gives a high signal to blink_anble wire,thus used it to avoid extra power suplly wire to be taken from 3v3 pin in fpga board

### Toolchain Setup
The first challenge was the tools setup in Ubuntu, which took me 2 days. I researched building the tools from their open-source GitHub repositories to ensure I was using updated, less buggy versions. I created detailed documentation for installing the toolchain on Ubuntu 22.04.

### Makefile & Board Programming
* I made changes to the `Makefile`. I removed the `terminal` and `cycle` commands as my project is simple and doesn't require Git updates or embedded communication.
* To flash the bitstream, `make flash` didn't work initially. I found out that I needed `sudo` access for the tool to access the USB port.
* I added a new Makefile command, `clean`, which uses `iceprog -e` to erase the FPGA's memory. This is useful because the board runs the previously programmed design on startup. I also enabled 



`sudo` for this command.

### FPGA Workflow
* I now understand the use of a `.gitignore` file for version control.
* The workflow is as follows:
    1.  **Yosys**: Produces a netlist (`.json` file) from the Verilog (`top.v`) file.
    2.  **next-pnr**: Takes the netlist and performs placement and routing, producing an ASCII file.
    3.  **icetime**: Checks for timing violations.
    4.  **icepack**: Creates the final binary file (`top.bin`).
    5.  **iceprog**: Dumps the binary file to the FPGA board.
Thus these intermediate files produced during project shouldnt be uploaded in github,thus when i git push these files are ignored using the file types mentioned in .gitignore file
---

## 4. Project Demo Video

Watch the project demo video here:

https://github.com/user-attachments/assets/290c23e5-0fca-4357-93c9-af9839186d23

