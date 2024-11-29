#!/bin/sh
qemu-system-x86_64 --enable-kvm -cpu host -smp $(nproc) -nographic -m 512 -bios /usr/share/ovmf/x64/OVMF.4m.fd -device virtio-balloon -device virtio-rng-pci -nic user,model=virtio -drive file=./arch.img,format=raw,if=virtio,aio=native,cache.direct=on
