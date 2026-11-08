# 临时记事 · Wear M3（com.experiment.quicknote.wm3）

小米 Vela JS 快应用：随手记下停车位、取件码等小事，到期自动清理。界面基于 vela-wear-m3（Wear OS Material 3 移植）。

## 功能
- **新建先选类型**：停车 / 取件码 / 储物柜 / 自定义，下方还有「一键记下」常用短语。
  - 圆屏、Pro：「自定义」打开键盘页，支持拼音、英文、符号，改编自喵喵输入法，采用 Gboard 风格和 M3 配色。
  - 手环：「自定义」是先从短语库选一句，再用数字键盘补数字（可不填）。
- **列表**：左滑卡片露出置顶和删除，删除后 4 秒内可撤销。详情页没有删除按钮，可延长有效期、改有效期、置顶、标记完成。
- **到期清理**：每次打开时清理已过期的记事。最多保存 20 条。
- **设置**：
  - 按类型设默认期限；
  - 编辑快捷短语（圆屏、Pro 可用键盘自己写；所有机型都能从短语库添加、排序、删除、恢复默认）；
  - 使用引导（再看一遍）；
  - 支持作者（捐赠目前不开放）；
  - 关于与许可。
- **首次启动引导**：4 页横向翻页，每页都能跳过，末页「开始使用」。完成或跳过后写入 4 条「教程」记事。教程记事永不过期，可以删除，只写入一次；重看引导不会重复写入。
- **返回**：在左边缘（距边 20–40px）向右滑，或在任意一行上向右滑。

## 存储
UnQLite（system.storage）：一个索引键加每条记事一个键，另有一个设置键。

## 构建
```bash
npm ci
bash tools/gen-sign.sh                 # 首次：生成本地签名（sign/ 不提交）
bash tools/build.sh                    # 四个机型 → out/qn-<机型>-{debug,release}.rpk，体积见 out/sizes.txt
QN_FAST=1 bash tools/build.sh band10   # 测试包：1 小时按 1 分钟计算，用来验证到期清理
```
- 机型：round（S3/S4 圆屏 466）、pro（手环 8/9 Pro 336×480）、band10（212×520）、band9（192×490）。
- 手环构建不含键盘页和词库。
- 输入法引擎源码以 `vendor/ime/js/*.js.in` 存放，构建时复制成 `.js`。

## 模拟器与预览
- `tools/emu-start.sh round|band10 [window]`：启动模拟器。
- `tools/emu-install.sh <rpk> [clear]`：安装；加 `clear` 会同时清空数据。
- `tools/emu-drive.js`：脚本化点击、滑动、截图。
- `tools/preview.js` + `tools/cases.js`：Chrome 设计预览。
- `tools/compose.py`：生成四机型拼图。

## 许可
- 本应用以 [GPL-3.0-or-later](LICENSE) 开源，© heDuke。
- 第三方声明见 `legal/NOTICE.txt`，随包放在 `/common/legal/`：
  - vela-wear-m3 中改编自 AndroidX 的部分与 Material Symbols 图标：Apache-2.0；
  - Noto Sans SC：OFL-1.1；
  - 喵喵输入法（NEORUAA）与 pinyinjs（小茗同学）：MIT。
