
# Table of Contents

1.  [Vivado Makefile Template Project](#org05adc54)
    1.  [Usage](#orgb5613c4)



<a id="org05adc54"></a>

# Vivado Makefile Template Project

Avoiding the Vivado GUI and creating a design flow using GNU Make from scratch can be difficult. This project aims to reduce the time to setup such a project and provide a baseline.
Scripts and workflow are based on the [CVA6 Project](https://github.com/openhwgroup/cva6).


<a id="orgb5613c4"></a>

## Usage

To build the project run

    make

in the project root.
The **BOARD** and **TOP**-Module can be changed via CLI:

    make BOARD=zedboard TOP=top_module_name

Artifacts of the build process can all be found in `work_dir` with the bit file programmable using.

    make program

Simulation is not yet included in the Makefile

