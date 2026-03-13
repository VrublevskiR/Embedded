# Solutions of the embedded course tasks

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
