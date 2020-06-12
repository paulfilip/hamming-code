# hamming-code
An Assembly program that generates Hamming code from input or checks the correctness of Hamming codes. In case of incorrect generated codes, it can correct it
The program simulates a 4 KB memory : 1024 x 32 bits. This generates the Hamming code for all 1024 memory locations

## Example :
- Generating Hamming code (7,4)
  Input : 1011 => output: 0110011
  Input : 1010 => output: 1011010

- Checking Hamming code (7,4)
  Input: 0110011 => Output: Correct
  Input: 1011010 => Output: Correct
  Input: 1001010 => Output: Incorrect; Error on bit 3 ; Correct: 1011010
