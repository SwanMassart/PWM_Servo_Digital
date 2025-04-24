# Topic3-PWM-Based-Servo-Motor-Controller
\
Mantvydas Klimavičius is responsible for programming\
\
Swan MASSART is responsible for programming\
\
Marek Wilczewski is responsible for help with programming and help with filming the short app video + readme file\
\
Roland Policsek is responsible for presentation, filming the short app video, creating the readme file and help with programming

"Les absents ont toujours tort."

## Full project
link: https://github.com/SwanMassart/PWM_Servo_Digital

## Theoretical description and explanation
The goal was to make PWM-Based Servo Motor Controller code. We wanted to create a controller that will turn the servo motor in the range from -90 to 90 degrees. There will be two independent servos connected to the Nexys board, where the function of controlling only one servo will be shown. By toggling the switch on the left we can decide between fast and slow mode. By switching the two swtiches on the right we can decide which servo to be rotated.

## Hardware description of demo application
The FPGA board contains BTNR, BTNL, BTND and BTNC buttons to controll the servos. BNTR and BTNL are used to change duty of PWM signal, BTND button is used to shut the system down while it is being pressed and BTNC is used as center button. This button resets settings of PWM signal and duty is defaultly on 50 %. \
Next in use are switches SW0, SW1 and SW15. First two are mean    t to switch between up to two servos, depending on which of the switches is turned on, the chosen servo will be moving, and the last one to the left is set to switch between fine and rough regulation of duty.\
Pmod ports of the FPGA marked as JA are used to connect the servos, specifically JA7 and JA8 as PWM output\
The servo signal wire is conneted to the PWM control pin 7 and 8 on the board.
<img src="https://github.com/Th0rgrlm/Topic3-PWM-Based-Servo-Motor-Controller/blob/main/images/Pmod_pinout.png" alt="Pmod out picture" /> 

Servo used in the project: https://www.friendlywire.com/projects/ne555-servo-safe/SG90-datasheet.pdf


## Software description

### Schematic
<img src="(https://github.com/SwanMassart/PWM_Servo_Digital/tree/main/pictures)" />

### Component(s) simulation

<img src="https://github.com/SwanMassart/PWM_Servo_Digital/blob/main/%7BD32BF380-1D11-4EB1-8826-C83B300E2BF2%7D.png" />
bcd1 is from 0 to 9, bcd10 is from 0 to 9 and finally bdc100 is 0 and 1

## Instructions
\
Press the left or right button (BTNL/BTNR) to move the servo in the chosen orientation, in the total range of 100 degrees from left to right. The actual position will be displayed on the 7-segment displays in degrees (0-100).\
\
\
![imageBTNR2](https://github.com/SwanMassart/PWM_Servo_Digital/blob/main/pictures/r_button.jpg)\
![imageBTNL](https://github.com/SwanMassart/PWM_Servo_Digital/blob/main/pictures/rigt_button.jpg)\
\
Use the two switches most to the right (SW0, SW1) to activate/deactivate the two connected servos. If only SW0 is turned on, only the right servo will be working and vice versa.\
\
\
![imageBTNC](https://github.com/SwanMassart/PWM_Servo_Digital/blob/main/pictures/full_circuit.jpg)\
\
Press the middle button (BTNC) to reset the position of the servos to the middle position.\
\
\
![image](https://github.com/SwanMassart/PWM_Servo_Digital/blob/main/pictures/l_switch.jpg)\
\
Use the switch SW15 residing most to the left to switch between slow and fast movement.\
\
\
![imageBTND](https://github.com/SwanMassart/PWM_Servo_Digital/blob/main/pictures/lower.jpg)\
\
Press the lower button (BTND) to shut down the whole system. As long as this button is pressed, the servos, displays and LED diodes will be turned off.\
\
short project video : https://youtube.com/shorts/tw2kckGUeao?feature=shared

## References

https://allaboutfpga.com/vhdl-code-for-binary-to-bcd-converter/

https://susta.cz/doc/UvodDoVHDL2_sequential.pdf
