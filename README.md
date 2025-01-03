# Two_choice_operant_assay repository

![Schematic of the assay](Images/operantAssayImage.png)

The two choice operant assay designed in the Murugan lab at Emory is a self-paced, automated social-sucrose operant assay in which mice are trained to associate two separate choice ports with access to either a sucrose reward or a same sex conspecific (social reward) ([Isaac et al.,2024](https://www.nature.com/articles/s41467-024-52294-6#Sec10))

The operant arena (12 in x 12 in x 12 in) is set up with two nose poke choice ports on one wall(Product ID: 1009, Sanworks Bpod). The reward zones are on the adjacent walls such that the social reward zone is on the wall furthest from its associated choice port and the sucrose reward zone is on the wall furthest from its associated choice port. The social reward zone consists of a square (2 in x 2 in) opening in the acrylic box covered by an automatic metal gate powered by a stepper motor connected to an Arduino microprocessor. A social target box (3 in x 3 in x 3 in) with one side covered in metal bars is positioned behind the automatic gate to permit investigation of the social target by the experimental mouse when the gate is opened. The sucrose reward zone consists of a reward port connected to a valve (Product ID: 1009, Sanworks Bpod) that is attached to a sucrose reservoir. 

## Overview

This repository includes - 
1. Bpod
   * Bpod's MATLAB control software (added from [Bpod_Gen2 repository](https://github.com/sanworks/Bpod_Gen2) from Bpod Sanworks)
   * Custom-written GUI for accessing the two choice assay Bpod protocols (on MATLAB)
   * Bpod protocols for the two choice assay (including the training protocols)

2. Arduino
   * Arduino code for the control of the social gate
   
4. Analysis
   * Bonsai for behavioral tracking in the two choice assay 

## Wiring for the two choice assay

![Schematic of the assay](Images/wiringdiagram.png)

Software control of the assay is via the Bpod state machine which is programmed interfaces with the two choice ports and the sucrose reward port in the operant chamber. It also communicates with the automated social gate through timed TTL pulses. The social gate is connected to a conveyor belt which is powered by a stepper motor. The power of the stepper motor is driven by a microstep driver which can be controlled through the orientation of the DIP switches. The stepper motor receives its input from the Arduino which controls the movement of the gate after receiving a pulse from the Bpod. 
