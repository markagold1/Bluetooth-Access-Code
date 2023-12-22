# Bluetooth Access Code Generator

BTACCESSCODE is a MATLAB and GNU Octave compatible implementation of the Bluetooth *Access Code*. The *access code* is used in the physical layer for device detection and synchronization.

The implementation uses only primitive functions without any dependencies on MATLAB toolboxes or GNU Octave packages. Because of this it will likely run on most any version.  It has been tested with MATLAB versions R2019b, R2020b, and R2022b as well as GNU Octave versions 3.8.2, 6.4.2, and 8.3.0.

![Sync word construction](./images/syncword.png "Construction of the sync word.")

# Files
* btaccesscode.m - Calculate access code from Lower Address Part
* btsyncgen.m - The "workhorse", calculate 64-bit sync word from Lower Address Part
* test_accesscode.m - Test access code calculation against test data from the Standard
* test_syncgen.m - Test sync word calculation against test data from the Standard
* load_test_data.m - Load test data from the Standard into the workspace

# Examples
### 1. Calculate Access Code using a sample from Appendix G of [1]

~~~~
>> [acbin,acstr,achex] = btaccesscode(0x61650c);
>> disp(achex)
aec4c69b54c29a18d5
~~~~

### 2. Run the Access Code test suite.

~~~~
>> test_accesscode
Success! 130 tests ran and passed.
~~~~

# References
1. **[Bluetooth Core Specification, Version 5.4 Vol 2, Parts B and G](https://www.bluetooth.com/specifications/specs/core-specification-5-4/)**  


> Written with [StackEdit](https://stackedit.io/).
