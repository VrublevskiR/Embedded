# Embedded Systems Course Solutions

This repository contains the completed homework for the Embedded Systems course.

## Repository Structure

* 📂 **[Task 1: ARM Assembly](./Task%201)** — Implementation of a C mathematical function using the classic 32-bit ARM instruction set.
* 📂 **[Task 2: Blinking LED](./LED_Timer_part_1)** — STM32 LED control with adjustable blinking frequency using a hardware timer (TIM6) and external button interrupts (EXTI).
* 📂 **[Task 3: Advanced LED & Duty Cycle](./LED_Timer_part_2)** — Advanced STM32 LED control featuring variable frequency and duty cycle modes using a hybrid approach (TIM6 + `HAL_GetTick()` polling).

## [Task 1: ARM Assembly in QEMU](./Task%201/calculate.s)

### Solution Description
This is implementation of the `calculate.c` function using the classic 32-bit ARM instruction set.
```c
uint32_t calculate(uint32_t repeat, uint32_t x, uint32_t y)
{
    uint32_t max = 10;
    uint32_t res = 0;
    for (int i = 0; i < repeat; i++)
    {
        uint32_t sum = x + y;
        uint32_t mul = x * y;
        res += sum + mul;
        x = (sum < max) ? sum : max;
    }
    return res;
}
```
Arguments are passed to the function via registers `R0`, `R1`, and `R2`

### Build and Run Instructions
To compile and execute the program, you need to install `qemu-user` and `binutils-arm-linux-gnueabihf`. Then, you should execute following commands:
```bash
arm-linux-gnueabihf-as calculate.s -o calculate.o
arm-linux-gnueabihf-ld calculate.o -o calculate
qemu-arm ./calculate
```
To print returned value:
```bash
echo $?
```
### Example
For the input values `repeat = 2`, `x = 2`, and `y = 3`, the execution result is returned to the terminal as the exit code:
```bash
34
```
## [Task 2: STM32 Blinking LED with Button Control](./LED_Timer_part_1)

### Solution Description
This project implements a blinking LED controlled by a user button on the STM32F746G-DISCO board.
- **TIM6 (Basic Timer)** is configured with interrupts to toggle the LED state.
- **EXTI (External Interrupt)** is used to handle button presses.
- Each button press doubles the LED blinking frequency (from 1 Hz up to 16 Hz). Upon reaching the maximum, the frequency resets back to 1 Hz.

### Build and Run Instructions
To build and run the project:
1. Open the project in **STM32CubeIDE**.
2. Build the project by clicking **Project -> Build Project**.
3. Connect the STM32 board via USB.
4. Click **Run -> Debug** (or the bug icon) to flash the firmware onto the MCU and start execution.

### Example
By default, `LED1` blinks at **1 Hz**.
Pressing the blue user button (`USER_Btn`) increases the frequency:
`1 Hz` -> `2 Hz` -> `4 Hz` -> `8 Hz` -> `16 Hz` -> `1 Hz`...

## [Task 3: Advanced Blinking LED with Duty Cycle Control](./Task%203)

### Solution Description
This project extends the previous task by introducing duty cycle management using a combination of a hardware timer and software polling.
- **Button Polling:** Instead of EXTI, the user button is continuously polled in the `while(1)` loop. `HAL_GetTick()` is used to calculate the press duration, effectively implementing software debouncing (> 50 ms) and distinguishing between short and long presses.
- **TIM6 (Basic Timer):** Configured to trigger interrupts every half-period. In the default mode, it toggles the LED state to maintain a symmetric 50% duty cycle.
- **Hybrid Timing Approach:** For the custom duty cycle mode, the TIM6 interrupt turns the LED on at the beginning of each full period. The `while(1)` loop constantly checks the elapsed time via `HAL_GetTick()` and turns the LED off exactly 50 ms after it was turned on.

### Build and Run Instructions
To build and run the project:
1. Open the project in **STM32CubeIDE**.
2. Build the project by clicking **Project -> Build Project**.
3. Connect the STM32 board via USB.
4. Click **Run -> Debug** (or the bug icon) to flash the firmware onto the MCU and start execution.

### Example
By default, `LED1` blinks at **1 Hz** with a **50% duty cycle** (500 ms ON, 500 ms OFF).
- **Short press (> 50 ms and < 1s):** Doubles the LED blinking frequency (`1 Hz` -> `2 Hz` -> `4 Hz` -> `8 Hz` -> `16 Hz` -> `1 Hz`...).
- **Long press (>= 1s):** Toggles the duty cycle mode. The LED will switch to a fixed **50 ms ON** time (staying OFF for the remainder of the period), regardless of the current frequency. A subsequent long press restores the 50% duty cycle mode.
