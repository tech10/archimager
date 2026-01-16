#!/bin/sh
qemu-system-x86_64 --enable-kvm -cpu host -smp $(nproc) -nographic -m 1024 -device virtio-balloon -device virtio-rng-pci -nic user,model=virtio -drive file=./arch.img,format=raw,if=virtio,aio=native,cache.direct=on
