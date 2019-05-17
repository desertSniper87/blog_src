title: Installing debian mips on qemu
slug: debian-mips-qemu
category: computing
date: 2019-05-09
modified: 2019-05-09
<!-- Status: draft -->



```bash
./qemu/build/mips-softmmu/qemu-system-mips \
-m 256 \
-M malta \
-kernel vmlinux-3.2.0-4-4kc-malta \
-hda debian_wheezy_mips_standard.qcow2 \
-append "root=/dev/sda1 console=tty0" \
-net user,hostfwd=tcp::10022-:22 \
-net nic
```

```bash
sysctl -w net.ipv4.ping_group_range='0 2147483647'
```

[https://people.debian.org/TLIDEaurel32/qemu/mips/](https://people.debian.org/~aurel32/qemu/mips/)