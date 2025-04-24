# Topic3-PWM-Based-Servo-Motor-Controller
\
Mantvydas Klimavičius is responsible for programming\
\
Swan MASSART is responsible for programming\
\
Marek Wilczewski is responsible for help with programming and help with filming the short app video + readme file\
\
Roland Policsek is responsible for presentation, filming the short app video, creating the readme file and help with programming


## Full project
link: https://github.com/SwanMassart/PWM_Servo_Digital

## Theoretical description and explanation
Our goal was to make a PWM-Based Servo Motor Controller code. We wanted to create a controller that will turn the servo motor in the range from -90 to 90 degrees. There will be two independent servos connected to the Nexys board, where the function of controlling only one servo will be shown. By toggling the switch on the left we can decide between fast and slow mode. By switching the two swtiches on the right we can decide which servo to be rotated.

## Hardware description of demo application
On the FPGA board there are BTNR, BTNL, BTND and BTNC buttons used. BNTR and BTNL are used to change duty of PWM signal, BTND button is used to shut the system down while it is being pressed and BTNC is used as center (reset) button. This button resets settings of PWM signal and duty is defaultly on 50 %. \
Next in use are switches SW0, SW1 and SW15. First two are meant to switch between up to two servos, depending on which of the switches is turned on, the chosen servo will be moving, and the last one to the left (SW15) is set to switch between fine and rough regulation of duty.\
Pmod ports of the FPGA marked as JA are used to connect the servos, specifically JA7 and JA8 as PWM output (see picture bellow)\
<img src="https://github.com/Th0rgrlm/Topic3-PWM-Based-Servo-Motor-Controller/blob/main/images/Pmod_pinout.png" alt="Pmod out picture" /> 

Servo used in the project: https://www.friendlywire.com/projects/ne555-servo-safe/SG90-datasheet.pdf


## Software description

### Schematic
<img src="https://github.com/SwanMassart/PWM_Servo_Digital/blob/main/pictures/SCTICS.png" />

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

The pwm_generator is a VHDL module that creates a PWM signal with a configurable duty cycle based on the input POS. It uses a counter that counts clock cycles up to a maximum value defined by C_END. The PWM output stays high from the start of the cycle until the counter reaches POS - 1, then goes low until the counter hits C_END - 1, after which it resets and starts again. The module only operates when en is high and resets both the counter and output when rst is active.

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
Press the middle button (BTNC) to reset the position of the servos to the middle position (50 degrees).\
\
\
![image](https://github.com/SwanMassart/PWM_Servo_Digital/blob/main/pictures/l_switch.jpg)\
\
Use the switch most to the left (SW15) to switch between fine and rough movement of the two servos, technically between slow and fast movement.\
\
\
![imageBTND](https://github.com/SwanMassart/PWM_Servo_Digital/blob/main/pictures/lower.jpg)\
\
Press the lower button (BTND) to shut down the whole system. As long as this button is pressed, the servos, displays and LED diodes will be turned off.\
\
short project video : https://youtube.com/shorts/tw2kckGUeao?feature=shared

## References

https://en.wikipedia.org/wiki/Double_dabble

https://allaboutfpga.com/vhdl-code-for-binary-to-bcd-converter/

https://susta.cz/doc/UvodDoVHDL2_sequential.pdf
