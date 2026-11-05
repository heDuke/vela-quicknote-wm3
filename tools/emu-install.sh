#!/bin/bash
# 安装到正在运行的模拟器并重启应用：bash tools/emu-install.sh <rpk> [clear]
#   clear = 安装后删除应用数据（/data/quickapp/system/<包名>/usr.db）（首次启动会再次显示引导）
P=com.heduke.quicknote
adb shell am stop -t $P >/dev/null 2>&1; sleep 1
adb push "$1" /data/app/qn.rpk >/dev/null && adb shell pm install /data/app/qn.rpk || exit 1
if [ "$2" = clear ]; then adb shell pm clear $P >/dev/null; adb shell rm /data/quickapp/system/$P/usr.db 2>/dev/null; fi  # storage 存在 usr.db；pm clear 只清缓存
sleep 1; adb shell am start -t $P
