# ! Changes are cooking ! 

To be updated with the latest efforts in proof-of-concept branch [btstack-senseunit](https://github.com/head5man/btstack-GCC-devcontainer-max3263X/tree/btstack-senseunit)

## btstack max32630fthr build container

### extracting max32640 firmware support files from SDK

After EOL announcement for Arm MBedOS this repository gathers instructions to setup build alternate platforms. When gathering information about max32630 the problem is that it is not recommended for new designs and using the most up-to-date sdk [MaximMicrosSDK_linux.run](https://download.analog.com/sds/exclusive/SFW0018720B/MaximMicrosSDK_linux.run) is a no-go because msdk does not support max32630(fthr).


Apart from components that can be installed via os packages there are two key componets that is required to build a executable binary. One is mcu specific libraries and instructions for example `(MAX3263X)PeriphDriver`, startup assembly, linker script, compiler makefile etc. The other is a generic [arm-toolchain](https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads).


It turns out that instructions and packages exist for setting up a Windows build environment [github.com/analogdevicesinc/ARM-DSP](https://github.com/analogdevicesinc/ARM-DSP), [maxim-micro-sdk-maximsdk-installation-and-maintenance-user-guide.pdf](https://www.analog.com/media/en/technical-documentation/user-guides/maxim-micro-sdk-maximsdk-installation-and-maintenance-user-guide.pdf).


The toolchain package is a windows executable and one has to first register an account to analog.com [Maxim ARM Cortex Toolchain](https://download.analog.com/sds/exclusive/SFW0001500A/ARMCortexToolchain.exe). Exploring the files after installation it turns out that it contains GCC sources, makefiles and compiled archives contained in folder `MaximInstallFolder/Firmware/MAX32630X`.


### Selecting platform for the build

My first plan was to quickly fabricate cordio drivers for PAN1326B/CC256X to use the familiar MBedOS - CE. That quickly became a mess of non-working half-implementated source files without actually gaining any insights. And thus without knowing the implementation details of initialing cc256x with service pack and HCI protocol it became evident it was not going to end well. So the decision was made to try out btstack as an alternative.

### container for btstack port

Using the makefiles (and a lot of trial and error) for examples in `port/max32630fthr` I was able to create docker file containing instructions to create build environment based on ubuntu 22.04.

The vanilla template makefile `port\max32630fthr\template\Makefile` requires some modifications (missing sources) to build all the examples but can be used to build the most basic examples e.g. `led_counter`.

