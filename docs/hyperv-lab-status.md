# Hyper-V lab baseline (user-reported)

Last updated: 2026-10-23

The laptop details below were supplied by the lab owner and should be rechecked before making changes.

- Host OS: Windows 10 Pro (reported version value: 2009)
- Hyper-V feature: Enabled
- Physical memory: approximately 15.79 GB
- Free memory at inspection: approximately 3.0-3.08 GB
- Logical processors: 8
- Network Bridge: 192.168.1.5/24
- Hyper-V Default Switch adapter: 172.28.64.1/20
- VPN interface: ProTUN, 10.2.0.2/32
- Switches reported: Hyper-V (Internal) and Default Switch (Internal)
- VMs initially listed: 3CX, LB-01, VM-01, VM-02, WEB-01, WEB-02, all Off at that time
- A subsequent detailed inspection returned only 3CX with a 4 GB startup memory setting, dynamic memory enabled, Generation 1, and disk path D:\Hyper-V\3CX\Virtual Hard Disks\3CX.vhdx. Re-run Get-VM to resolve this discrepancy before provisioning.

## Decisions

- Do not modify existing switches, VPN routes, or the 3CX VM.
- Do not assume the existing VMs contain Windows Server or Ubuntu; inspect each VM and its disk/OS details first.
- Because free host memory is about 3 GB, avoid starting additional guests until memory has been freed and rechecked.
- Start with one powered-off test VM, then install a guest OS manually and validate the lifecycle in small steps.
- Provisioning remains a local lab operation; Jenkins is not yet wired to execute PowerShell on the Hyper-V host.
