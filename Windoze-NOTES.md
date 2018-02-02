1. On Ubuntu 17.10/qemu 2.10.1, Apple SMC patch is already applied, no need to build from source.
1. Machine type can be `pc-q35-2.10`.
1. USB host devices passthough works, but audio output from USB audio card could be sluggish.
1. CPU type has to stay with Penrye, changing it to SandyBridge or host makes VM crash on boot, but advanced feature flags could be added to enables new CPU features
1. W/o `+vmx` flag, VMware Fusion crashes VM on start.
1. OVMF_CODE.fd comes with system package cannot boot on passthrough video card, has to use the one in this repo.
1. Still don't know how to passthrough USB3 controller card cleanly, the device is always claimed by system xhci driver, which cannot blacklisted entirely, I have to run:
    ```
    echo "0000:02:00.0" > /sys/bus/pci/devices/0000:02:00.0/driver/unbind
    echo 0x1b73 0x1100 > /sys/bus/pci/drivers/vfio-pci/new_id
    ```
    after boot, to force xhci to release the device and bind it to vfio-pci.
    * Running the command if PCI device is already attached to vfio-pci may hang the host OS, I've experienced it once, reason unknown.
1. Installing docker enables netfilter on bridges, which will break VM network, set these to disable:
    ```
    net.bridge.bridge-nf-call-ip6tables = 0
    net.bridge.bridge-nf-call-iptables = 0
    net.bridge.bridge-nf-call-arptables = 0
    ```
1. Screen resolution set in UEFI settings and Clover config.plist must be same, otherwise the screen will be scrambled, but installing nVidia driver seems to fix the issue.
1. UEFI may use a native resolution when it's started the first time, which is the native resolution of the display if it could be detecte, i.e. display is connected via DisplayPort cable.
1. Fresco Logic FL1100 USB 3.0 Host Controller, which AFAIK is the only chipset can be used directly in OSX, seems to have trouble with Windows 10, it crashes *host* when being activated in Windows guest VM.
    1. It could be a hardware issue or a software issue, but it seems to be working well under OSX.
    1. Also it could be some issue when re-attaching it after detaching, but stop the restart OSX VM still works.
    1. Changed a new USB card with same chipset and the problem still exists.
    1. Then I changed to another USB controller which is uPD720202 USB 3.0 Host Controller from Renesas Technology Corp, pciid 1912:0015, it's supported by [GenericUSBXHCI.kext](https://bitbucket.org/RehabMan/os-x-generic-usb3/downloads/), install the kext with [Kext Util](https://www.osx86.net/files/file/4279-kext-utility-latest-version/) and everything works except system seems to be crashed on shutdown and reports an error on next boot.
1. Harddisk bus can be changed from IDE to SATA w/o problem, but not SCSI, and there is no virtio disk driver usable under OSX, so the disk I/O performance is not optimal.
1. NIC can be set to vmxnet3 as it's natively supported by macOS since 10.12.
