#!/bin/bash
# 启动 Vela 模拟器：bash tools/emu-start.sh round|band10 [window]
#   window = 带窗口（在桌面上可见、可用鼠标操作）；默认无窗口。同一时间只跑一个模拟器（adb 序列号都是 emulator-5554）。
case $1 in round) AVD=Vela_Round_466; P=8554; F=18554;; band10) AVD=Vela_Band10_212x520; P=8556; F=18556;; *) echo "round|band10"; exit 1;; esac
pkill -f qemu-system-armel 2>/dev/null; sleep 2
W=-no-window; [ "$2" = window ] && W=
cd /tmp && nohup ~/.vela/sdk/emulator/linux-x86_64/emulator -vela -avd $AVD $W -show-kernel \
  -network-user-mode-options hostfwd=tcp:127.0.0.1:$F-10.0.2.15:101 -grpc $P \
  -qemu -device virtio-snd,bus=virtio-mmio-bus.2 -semihosting > /tmp/emu-$1.log 2>&1 &
for i in $(seq 1 60); do sleep 2; timeout 5 adb shell date >/dev/null 2>&1 && break; done
sleep 8; echo "emulator $1 up (grpc $P)"
