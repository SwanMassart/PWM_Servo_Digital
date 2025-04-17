# Topic3-PWM-Based-Servo-Motor-Controller
\
Mantvydas Klimavičius is responsible for programming\
\
Swan MASSART is responsible for programming\
\
Marek Wilczewski is responsible for help with programming and help with filming the short app video + readme file\
\
Roland Policsek is responsible for providing the servos, filming the short app video, creating the readme file and help with programming

## Full project
link: https://github.com/Th0rgrlm/Topic3-PWM-Based-Servo-Motor-Controller/tree/master

## Theoretical description and explanation
Our group decided to make a PWM-Based Servo Motor Controller code. We want to create a controller that will turn the servo motor in the range of 100 degrees. There will be two independent servos connected to the Nexys board, where the function of controlling only one servo will be shown. With turning on or off the switch on the left, it will determine wheter the servo motors will be turning fast or slow (or differently said - rough or fine movement). with turning the right switches on or off will determine which of the connected servos will be operated and which will stay in their position.

## Hardware description of demo application
On the FPGA board there are BTNR, BTNL, BTND and BTNC buttons used. BNTR and BTNL are used to change duty of PWM signal, BTND button is used to shut the system down while it is being pressed and BTNC is used as center (reset) button. This button resets settings of PWM signal and duty is defaultly on 50 %. \
Next in use are switches SW0, SW1 and SW15. First two are meant to switch between up to two servos, depending on which of the switches is turned on, the chosen servo will be moving, and the last one to the left (SW15) is set to switch between fine and rough regulation of duty.\
Pmod ports of the FPGA marked as JA are used to connect the servos, specifically JA7 and JA8 as PWM output (see picture bellow)\
<img src="https://github.com/Th0rgrlm/Topic3-PWM-Based-Servo-Motor-Controller/blob/main/images/Pmod_pinout.png" alt="Pmod out picture" /> 

Servo link: https://www.savoxusa.com/products/savsb2274sg-be-black-edition-high-voltage


## Software description

### Schematic

![imageSchematic](https://github.com/Th0rgrlm/Topic3-PWM-Based-Servo-Motor-Controller/blob/main/images/schematic.png)

### State diagram for BIN2BCD component

<img src="https://github.com/Th0rgrlm/Topic3-PWM-Based-Servo-Motor-Controller/blob/main/images/BIN2BCD_State_Diagram.jpg" alt="State diagram fro BIN2BCD" >
i1 = bin_counter == BIN

i2 = shift_counter == 7

### Component(s) simulation

#### Enable Clock Ratio
<img src="https://github.com/Th0rgrlm/Topic3-PWM-Based-Servo-Motor-Controller/blob/main/images/Simulation/enable_clock_ratio.png" alt="Clock enable ratio Test Bench" /> 

In the single component 'enable_clock_ratio', we use a switch to change the pulse timing of the enable signal that will go to the component Position.

#### Position

<img src="https://github.com/Th0rgrlm/Topic3-PWM-Based-Servo-Motor-Controller/blob/main/images/Simulation/position.png" alt="Position Test Bench" />

Component Position takes input from BTNC, BTNL, BTNR buttons, and SW_Servo. BTNL decreases the value of the signal 'pos', and BTNR increases the value of the signal 'pos'. The signal 'pos' can take values from 200 to 100. BTNC sets the signal 'pos' to 150. The input 'en' is connected to the output of Clock En Ratio, and it checks if BTNL or BTNR has been pressed, and therefore decreases or increases the value of 'pos'. Switch SW_Servo enables the whole component. If the component isn't enabled, it doesn't increase or decrease the value of 'pos'.

<img src="https://github.com/Th0rgrlm/Topic3-PWM-Based-Servo-Motor-Controller/blob/main/images/Simulation/position%20detail.png" alt="Position detail Test Bench" />

#### PWM Generator

<img src="https://github.com/Th0rgrlm/Topic3-PWM-Based-Servo-Motor-Controller/blob/main/images/Simulation/pwm_generator.png" alt="PWM generator Test Bench" />

PWM Generator takes output signals from components clock enable and Position and determines the duty cycle of PWM and assigns the value to the signal 'pwm_out.' The width of the high pulse changes from 1000us to 2000us. It generates a PWM signal with a frequency of 333 Hz.

#### BIN2BCD

<img src="https://github.com/Th0rgrlm/Topic3-PWM-Based-Servo-Motor-Controller/blob/main/images/Simulation/bin2bcd.png" alt="BIN2BCD Test Bench" />

BIN2BCD takes output from component Position, decreases its value by 100, which gives us the current degree of rotation of the servo motor because the servo motors can rotate from 0° to 100°. After that, it splits the whole number into individual digits, then converts those digits from binary code to BCD code and sends that code to BIN2SEG

#### BIN2SEG

It changes BCD code to code that can light up individual segments of a seven-segment display.

#### SEGM Control

<img src="https://github.com/Th0rgrlm/Topic3-PWM-Based-Servo-Motor-Controller/blob/main/images/Simulation/segm_control.png" alt="Segment control Test Bench"/>

SEGM Control takes the output signal of BIN2SEG and displays it as a decimal number on a seven-segment display. It displays digit by digit, activating each individual display with the refresh frequency of the output signal of the clock enable parameterized component.

#### Single Servo Control

<img src="https://github.com/Th0rgrlm/Topic3-PWM-Based-Servo-Motor-Controller/blob/main/images/Simulation/single_servo_control.png" alt="Single Servo control Test Bench"/>

It takes components: Position, BIN2BCD, PWM Generator, and three instances of BIN2SEG, and creates one single component that will remember the position of one servo motor and will only change if it is activated. This component allows us to set up as many servo motors as we need.

<img src="https://github.com/Th0rgrlm/Topic3-PWM-Based-Servo-Motor-Controller/blob/main/images/Simulation/single_servo_control pwm detail.png" alt="Single Servo control Test Bench detail"/>



## Instructions

![imageBTNR1](https://github.com/Th0rgrlm/Topic3-PWM-Based-Servo-Motor-Controller/blob/main/images/btnr1.jpg)\
\
Press the left or right button (BTNL/BTNR) to move the servo in the chosen orientation, in the total range of 100 degrees from left to right. The actual position will be displayed on the 7-segment displays in degrees (0-100).\
\
\
![imageBTNR2](https://github.com/Th0rgrlm/Topic3-PWM-Based-Servo-Motor-Controller/blob/main/images/btnr2.jpg)
![imageBTNL](https://github.com/Th0rgrlm/Topic3-PWM-Based-Servo-Motor-Controller/blob/main/images/btnl.jpg)\
\
Use the two switches most to the right (SW0, SW1) to activate/deactivate the two connected servos. If only SW0 is turned on, only the right servo will be working and vice versa.\
\
\
![imageBTNC](https://github.com/Th0rgrlm/Topic3-PWM-Based-Servo-Motor-Controller/blob/main/images/btnc.jpg)\
\
Press the middle button (BTNC) to reset the position of the servos to the middle position (50 degrees).\
\
\
![image](https://github.com/Th0rgrlm/Topic3-PWM-Based-Servo-Motor-Controller/blob/main/images/sw_speed.jpg)\
\
Use the switch most to the left (SW15) to switch between fine and rough movement of the two servos, technically between slow and fast movement.\
\
\
![imageBTND](https://github.com/Th0rgrlm/Topic3-PWM-Based-Servo-Motor-Controller/blob/main/images/btnd.jpg)\
\
Press the lower button (BTND) to shut down the whole system. As long as this button is pressed, the servos, displays and LED diodes will be turned off.\
\
short app video:\
https://youtu.be/wzy_NoTWGlA?si=6DzQUGHOYftg_hcf

## References

https://en.wikipedia.org/wiki/Double_dabble

https://allaboutfpga.com/vhdl-code-for-binary-to-bcd-converter/
