#!/bin/bash
# 构建：每个机型 gen → 精简 → aiot build（debug）+ aiot release → out/qn-<dev>-{debug,release}.rpk，体积写入 out/sizes.txt
# 用法：bash tools/build.sh [round pro band10 band9]   （release 需要 sign/，先运行 tools/gen-sign.sh）
set -e; cd "$(dirname "$0")/.."
mkdir -p out; : > out/sizes.txt
IME=vendor/ime
for d in ${@:-round pro band10 band9}; do
  node node_modules/vela-wear-m3/bin/vela-wear-m3.js gen --input template --out src --device $d --animation basic --replace >/dev/null
  pill=0; case $d in band*) pill=1;; esac
  # 手环没有键盘页与词库
  if [ $pill = 1 ]; then rm -rf src/pages/kb src/common/ime; else mkdir -p src/common/ime/dict && cp $IME/dict/*.txt src/common/ime/dict/
    # 引擎源码以 .js.in 存放：aiot 会扫描整个工程的 .js 收集 @system 依赖，放在别处会让手环构建误报缺少 system.file
    for f in $IME/js/*.js.in; do cp $f src/common/ime/$(basename $f .in); done; fi
  # 只拷贝代码里引用到的 App 图标
  mkdir -p src/common/ic
  grep -rhoE "/common/ic/[a-z0-9_]+\.png" src/pages | sort -u | while read p; do cp assets/$d/$(basename $p) src/common/ic/; done
  # 自己的应用图标与精简后的许可声明（替换库默认的 logo 与整套 GPL/Demo 法律文本）
  rm -f src/common/img/pager_v*.png   # 本 App 只用横向 Pager
  cp assets/logo.png src/common/logo.png
  rm -rf src/common/legal; mkdir -p src/common/legal
  cp legal/Apache-2.0.txt legal/OFL-1.1-NotoSansSC.txt src/common/legal/
  if [ $pill = 1 ]; then sed '/^#IME/,/^#END/d' legal/NOTICE.txt > src/common/legal/NOTICE.txt
  else sed '/^#IME$/d;/^#END$/d' legal/NOTICE.txt > src/common/legal/NOTICE.txt; mkdir -p src/common/legal/ime; cp legal/ime/*.txt src/common/legal/ime/; fi
  rm -rf dist build
  npx aiot build > out/build-$d.log 2>&1 || { echo "build $d FAILED"; grep -iE "error|错误" out/build-$d.log | head -20; exit 1; }
  cp dist/*.debug.*.rpk out/qn-$d-debug.rpk
  npx aiot release > out/release-$d.log 2>&1 || { echo "release $d FAILED"; tail -20 out/release-$d.log; exit 1; }
  cp dist/*.release.*.rpk out/qn-$d-release.rpk
  echo "$d debug=$(stat -c%s out/qn-$d-debug.rpk) release=$(stat -c%s out/qn-$d-release.rpk) warn=$(grep -c '🟠' out/build-$d.log || true)" | tee -a out/sizes.txt
done
