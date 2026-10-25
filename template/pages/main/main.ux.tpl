<template>
<!-- 临时记事 1.0：单页应用。所有“屏”共用一个页面（列表 / 详情 / 有效期 / 新建 / Picker / 数字键盘 / 设置 / 短语 / 关于 / 引导），
     共享一份库运行时与样式，手环包比多页面小约一半。返回键 / 右滑由 overlayBack() 弹出内部屏栈。
     库的 layout.describe 只读模板里第一个 <list>：下面这个注释里的空 list 让 PAGE_LAYOUT 为空，行高由本页 relayout() 提供。
     <list></list> -->
<div class="page" onswipe="onPageSwipe">
<list class="lst" id="lst" if="{{isList}}" onscroll="onScroll">
<list-item type="padt" class="li-padt"></list-item>
<list-item type="hdr" class="li-hdr" for="{{hdrRows}}"><div class="lh"><text class="t-titleM c-on tc">{{$item.t}}</text></div></list-item>
<list-item type="dh" class="li-dh" for="{{dhRows}}"><div class="dh">
  <div class="dh-r"><div class="icc {{$item.bg}}"><image class="ic-sec" src="{{$item.ic}}"></image></div><text class="dh-app">{{$item.app}}</text></div>
  <text class="dh-v">{{$item.v}}</text><text class="dh-m {{$item.soon ? 'nc-soon' : ''}}">{{$item.m}}</text>
</div></list-item>
<list-item type="note" class="li-card" for="{{cards}}">
<!-- #if pill -->
<!-- #component transforming-list-item {"style": "$item.st", "content": "<div class=\"sr\"><div class=\"nc {{$item.rv ? 'nc-rv' : ''}}\" if=\"{{!$item.hc}}\" style=\"{{feedback[$item.id] || {opacity:1}}}\" ontouchstart=\"tDown($idx)\" ontouchmove=\"tMove($idx)\" ontouchend=\"tUp($idx)\" onclick=\"openNote($idx)\"><div class=\"nc-h\"><image class=\"nc-ic\" src=\"{{$item.ic}}\"></image><text class=\"nc-app\">{{$item.app}}</text><image class=\"nc-pin\" if=\"{{$item.pin}}\" src=\"/common/ic/a_pin.png\"></image><div class=\"nc-sp\"></div></div><text class=\"nc-ttl\">{{$item.ttl}}</text><text class=\"nc-tm2 {{$item.soon ? 'nc-soon' : ''}}\">{{$item.tm2}}</text></div><div class=\"sa-s\" if=\"{{$item.rv}}\" ontouchstart=\"tDown($idx)\" ontouchmove=\"tMove($idx)\" ontouchend=\"tUp($idx)\" onclick=\"pinRow($idx)\"><image class=\"sa-ic\" src=\"/common/ic/s_pin.png\"></image></div><div class=\"sa-p\" if=\"{{$item.rv}}\" ontouchstart=\"tDown($idx)\" ontouchmove=\"tMove($idx)\" ontouchend=\"tUp($idx)\" onclick=\"delRow($idx)\"><image class=\"sa-ic\" src=\"/common/ic/s_del.png\"></image><text class=\"sa-t\">删除</text></div><div class=\"undo\" if=\"{{$item.ud}}\" onclick=\"undoRow($idx)\"><image class=\"ic-24\" src=\"/common/ic/u_undo.png\"></image><text class=\"undo-t\">撤销删除</text></div></div>"} -->
<!-- #else -->
<!-- #component transforming-list-item {"style": "$item.st", "content": "<div class=\"sr\"><div class=\"nc {{$item.rv ? 'nc-rv' : ''}}\" if=\"{{!$item.hc}}\" style=\"{{feedback[$item.id] || {opacity:1}}}\" ontouchstart=\"tDown($idx)\" ontouchmove=\"tMove($idx)\" ontouchend=\"tUp($idx)\" onclick=\"openNote($idx)\"><div class=\"nc-h\"><image class=\"nc-ic\" src=\"{{$item.ic}}\"></image><text class=\"nc-app\">{{$item.app}}</text><image class=\"nc-pin\" if=\"{{$item.pin}}\" src=\"/common/ic/a_pin.png\"></image><div class=\"nc-sp\"></div><text class=\"nc-tm {{$item.soon ? 'nc-soon' : ''}}\">{{$item.tm}}</text></div><text class=\"nc-ttl\">{{$item.ttl}}</text></div><div class=\"sa-s\" if=\"{{$item.rv}}\" ontouchstart=\"tDown($idx)\" ontouchmove=\"tMove($idx)\" ontouchend=\"tUp($idx)\" onclick=\"pinRow($idx)\"><image class=\"sa-ic\" src=\"/common/ic/s_pin.png\"></image></div><div class=\"sa-p\" if=\"{{$item.rv}}\" ontouchstart=\"tDown($idx)\" ontouchmove=\"tMove($idx)\" ontouchend=\"tUp($idx)\" onclick=\"delRow($idx)\"><image class=\"sa-ic\" src=\"/common/ic/s_del.png\"></image></div><div class=\"undo\" if=\"{{$item.ud}}\" onclick=\"undoRow($idx)\"><image class=\"ic-24\" src=\"/common/ic/u_undo.png\"></image><text class=\"undo-t\">撤销删除</text></div></div>"} -->
<!-- #endif -->
</list-item>
<list-item type="empty" class="li-empty" for="{{emptyRows}}"><div class="empty"><image class="e-ic" src="/common/ic/e_note.png"></image><text class="e-t">还没有记事</text><text class="e-b">$[pill ? "点下方 + 记下停车位、取件码" : "点 + 记下停车位、取件码"]</text></div></list-item>
<list-item type="tpl" class="li-row" for="{{tpls}}">
<!-- #component transforming-list-item {"style": "$item.st", "content": "<div class=\"btn btn-ic bt\" style=\"{{feedback[$item.id] || {opacity:1}}}\" ontouchstart=\"rDown($item.id)\" ontouchend=\"release($item.id)\" ontouchmove=\"rMove\" onclick=\"tapTpl($idx)\"><div class=\"icc {{$item.bg}}\"><image class=\"ic-sec\" src=\"{{$item.ic}}\"></image></div><div class=\"bcol\"><text class=\"t-labelM c-onS lab\">{{$item.t}}</text><text class=\"t-labelS c-onSV lab\">{{$item.s}}</text></div></div>"} -->
</list-item>
<list-item type="act" class="li-row" for="{{acts}}">
<!-- #component transforming-list-item {"style": "$item.st", "content": "<div class=\"btn {{$item.cls}}\" style=\"{{feedback[$item.id] || {opacity:1}}}\" ontouchstart=\"rDown($item.id)\" ontouchend=\"release($item.id)\" ontouchmove=\"rMove\" onclick=\"tapAct($idx)\"><image class=\"ic24\" src=\"{{$item.ic}}\"></image><div class=\"bcol2\"><text class=\"t-labelM c-onS lab-w\">{{$item.t}}</text><text class=\"t-labelS c-onSV lab-w\" if=\"{{$item.s}}\">{{$item.s}}</text></div></div>"} -->
</list-item>
<list-item type="ab" class="li-row" for="{{abRows}}"><div class="tlc" style="{{$item.st}}"><div class="ab"><text class="ab-t">{{$item.t}}</text><text class="ab-s">{{$item.s}}</text></div></div></list-item>
<list-item type="sub" class="li-sub" for="{{subRows}}"><div class="lsub"><text class="t-titleS c-onS">{{$item.t}}</text></div></list-item>
<list-item type="act2" class="li-row" for="{{acts2}}">
<!-- #component transforming-list-item {"style": "$item.st", "content": "<div class=\"btn {{$item.cls}}\" style=\"{{feedback[$item.id] || {opacity:1}}}\" ontouchstart=\"rDown($item.id)\" ontouchend=\"release($item.id)\" ontouchmove=\"rMove\" onclick=\"tapAct2($idx)\"><image class=\"ic24\" src=\"{{$item.ic}}\"></image><div class=\"bcol2\"><text class=\"t-labelM c-onS lab-w\">{{$item.t}}</text><text class=\"t-labelS c-onSV lab-w\" if=\"{{$item.s}}\">{{$item.s}}</text></div></div>"} -->
</list-item>
<list-item type="phr" class="li-row" for="{{phRows}}">
<!-- #component transforming-list-item {"style": "$item.st", "content": "<div class=\"btn bt\">$[(pill || rect) ? \"\" : \"<image class=\\\"ic24\\\" src=\\\"{{$item.ic}}\\\"></image>\"]<text class=\"t-labelM c-onS ph-l $[(pill || rect) ? \"\" : \"ml-a\"]\">{{$item.t}}</text><div class=\"ph-b {{$idx === 0 ? 'dis' : ''}}\" onclick=\"phUp($idx)\"><image class=\"ic24\" src=\"/common/ic/i_up.png\"></image></div><div class=\"ph-b\" onclick=\"phDel($idx)\"><image class=\"ic24\" src=\"/common/ic/i_close.png\"></image></div></div>"} -->
</list-item>
<list-item type="rb" class="li-row" for="{{radios}}">
<!-- #component transforming-list-item {"style": "$item.st", "content": "<div class=\"btn {{sel === $idx ? 'bpc' : 'bt'}}\" style=\"{{feedback[$item.id] || {opacity:1}}}\" ontouchstart=\"rDown($item.id)\" ontouchend=\"release($item.id)\" ontouchmove=\"rMove\" onclick=\"choose($idx)\"><div class=\"bcol2 grow\"><text class=\"t-labelM c-onS lab-r\">{{$item.t}}</text><text class=\"t-labelS {{sel === $idx ? 'c-onPCv' : 'c-onSV'}} lab-r\">{{$item.s}}</text></div><div class=\"radio {{sel === $idx ? '' : 'radio-off'}}\"><div class=\"radio-dot {{sel === $idx ? '' : 'radio-dot-off'}}\"></div></div></div>"} -->
</list-item>
<list-item type="padb" class="li-ebpad"></list-item>
</list>

<!-- 停车 / 储物柜：PickerGroup（原生 picker） -->
<div class="pk" if="{{scr === 'picker'}}">
  <text class="pk-l">{{pkLabel}}</text>
  <div class="pk-g">
    <div class="pk-col"><picker class="pk-c pk-c1" type="text" data-rows="$[PKN]" range="{{r1}}" selected="{{s1}}" onchange="ch1"></picker></div>
    <text class="pk-sep">{{sep}}</text>
    <div class="pk-col"><picker class="pk-c pk-c2" type="text" data-rows="$[PKN]" range="{{r2}}" selected="{{s2}}" onchange="ch2"></picker></div>
  </div>
</div>

<!-- 取件码：数字键盘（键位静态展开：for 内 onclick 带 $item 嵌套参数在模拟器上取值不可靠） -->
<div class="np" if="{{scr === 'numpad'}}">
  <text class="np-l">{{npLabel}}</text>
  <div class="np-pv"><text class="np-txt {{draft.length > 7 ? 'np-txt-s' : ''}}"><span>{{draft}}</span><span class="np-cs">|</span></text>
<!-- #if !pill -->
  <div class="np-ok {{draft || numKind === 'cus' ? '' : 'dis'}}" onclick="saveCode"><image class="ic-24" src="/common/ic/i_check.png"></image></div>
<!-- #endif -->
  </div>
  <div class="np-row"><div class="np-k" onclick="key('1')"><text class="np-n">1</text></div><div class="np-k" onclick="key('2')"><text class="np-n">2</text></div><div class="np-k" onclick="key('3')"><text class="np-n">3</text></div></div>
  <div class="np-row"><div class="np-k" onclick="key('4')"><text class="np-n">4</text></div><div class="np-k" onclick="key('5')"><text class="np-n">5</text></div><div class="np-k" onclick="key('6')"><text class="np-n">6</text></div></div>
  <div class="np-row"><div class="np-k" onclick="key('7')"><text class="np-n">7</text></div><div class="np-k" onclick="key('8')"><text class="np-n">8</text></div><div class="np-k" onclick="key('9')"><text class="np-n">9</text></div></div>
  <div class="np-row"><div class="np-k np-ks" onclick="key('-')"><text class="np-n">-</text></div><div class="np-k" onclick="key('0')"><text class="np-n">0</text></div><div class="np-k np-ks" onclick="key('bk')"><image class="ic-24" src="/common/ic/i_bksp.png"></image></div></div>
</div>

<block if="{{isList}}">
<!-- #include @wear/timetext.tpl -->
<!-- #include @wear/scrollind.tpl -->
</block>
<block if="{{ebOn}}">
<image class="scrim" if="{{isList}}" src="/common/img/scrim.png" style="{{ebSt}}"></image>
<div class="scrim2" if="{{isList}}" style="{{ebSt}}"></div>
<div class="eb" style="{{ebSt}}" ontouchstart="rDown('eb')" ontouchmove="rMove" ontouchend="release('eb')" onclick="tapEb"><image class="eb-img" src="/common/img/edge_button.png"></image><image class="eb-ic" if="{{scr === 'list'}}" src="/common/img/add_onPrimary_32.png"></image><image class="eb-ic" if="{{scr !== 'list'}}" src="/common/img/check_onPrimary_32.png"></image></div>
</block>

<!-- 首次使用引导：4 页 HorizontalPager（左右滑）+ PageIndicator；1–3 页「跳过」，末页「开始使用」 -->
<div class="ob" if="{{scr === 'oobe'}}" ontouchstart="obDown" ontouchmove="obMove" ontouchend="obUp">
  <div class="ob-pg" for="{{obPg}}" tid="tk">
    <div class="ob-ill" if="{{$item.k === 0}}"><div class="ob-c ob-pc"><image class="ob-big" src="/common/ic/o_note.png"></image></div></div>
    <div class="ob-ill" if="{{$item.k === 1}}"><div class="ob-eb"><image class="ob-sm" src="/common/ic/o_add.png"></image></div>
      <div class="ob-row"><div class="ob-dot bg-td"><image class="ob-ic16" src="/common/ic/c_park.png"></image></div><div class="ob-dot bg-sd"><image class="ob-ic16" src="/common/ic/c_pkg.png"></image></div><div class="ob-dot bg-pd"><image class="ob-ic16" src="/common/ic/c_note.png"></image></div>
      <div class="ob-dot bg-sd"><image class="ob-ic16" src="/common/ic/c_edit.png"></image></div>
      </div></div>
    <div class="ob-ill" if="{{$item.k === 2}}"><div class="ob-row"><div class="ob-card"><text class="ob-ct">$[pill ? "B2" : "B2 · C"]</text></div><div class="ob-a ob-as"><image class="ob-sm" src="/common/ic/o_pin.png"></image></div><div class="ob-a ob-ap"><image class="ob-sm" src="/common/ic/o_del.png"></image></div></div></div>
    <div class="ob-ill" if="{{$item.k === 3}}"><div class="ob-c ob-tc"><image class="ob-big" src="/common/ic/o_timer.png"></image></div></div>
    <text class="ob-t">{{$item.t}}</text>
    <text class="ob-b">{{$item.b}}</text>
  </div>
  <div class="ob-btn">
    <div class="cbtn ob-skip" if="{{obi < 3}}" onclick="obEnd"><text class="ob-st">跳过</text></div>
    <div class="cbtn ob-go" if="{{obi === 3}}" onclick="obEnd"><image class="cbtn-ic" src="/common/ic/i_check.png"></image><text class="ob-gt">开始使用</text></div>
  </div>
  <div class="pager-box" style="{{pagerBox}}"><image class="pager-background" src="{{pagerBackground}}"></image><div class="page-dot {{$item.on ? 'dot-on' : ''}}" style="{{$item.st}}" for="{{dots}}" tid="id"></div><div class="selected-dot" style="{{$item.st}}" for="{{worm}}" tid="id"></div></div>
</div>

<!-- AlertDialog（全部清除 / 已满） -->
<div class="ovl {{dlgOut ? 'ovl-out' : 'ovl-in'}}" if="{{dlgOn}}" onswipe="onPageSwipe">
  <div class="dlg-col">
    <image class="ic24" src="/common/img/delete_onBackground_24.png"></image>
    <text class="t-titleM c-onS dlg-title">{{dlgTitle}}</text>
    <text class="t-bodyM c-on dlg-text">{{dlgText}}</text>
  </div>
  <div class="dlg-x {{pressId === 'dx' ? 'p-in' : ''}}" ontouchstart="press('dx')" ontouchend="release('dx')" onclick="dlgCancel"><image class="ic28" src="/common/img/close_primary_28.png"></image></div>
  <div class="dlg-ok {{pressId === 'dk' ? 'dlg-okp' : ''}}" ontouchstart="press('dk')" ontouchend="release('dk')" onclick="dlgOk"></div>
  <image class="dlg-okic" src="/common/img/check_onPrimary_28.png" onclick="dlgOk"></image>
</div>
<!-- #include @wear/confirm.tpl -->
<div class="edge-bk" if="{{scr !== 'list' && scr !== 'oobe'}}" ontouchstart="bDown" ontouchmove="bMove"></div>
</div>
</template>
<style>
/* #include @wear/m3.css */
/* #include @wear/buttons.css */
/* #include @wear/toggles.css */
/* #include @wear/edge.css */
/* #include @wear/overlay.css */
/* #include @wear/confirm.css */
/* #include @wear/pager.css */
$[dlgCss()]
/* #include app.css */
/* #include input.css */
/* #include oobe.css */
</style>
<script>
// #include @wear/base_head.js
import { pagerState } from '../../common/m3.js'
import { loadNotes, loadCfg, saveCfg, putNote, dropNote, saveIdx, MAX } from '../../common/store.js'
import { H1, EK, EL, DEF, expAt, at, hm, rem, newId } from '../../common/qn.js'
import { unlocked } from '../../common/gate.js'
let cfTimer = null
let confirmEpoch = 0
const EBH = $[EBH]
const PILL = $[pill ? 'true' : 'false']
const KB = $[pill ? 'false' : 'true'] // 自定义键盘只在圆屏 / 方屏
// 行高（px），与 app.css / m3.css 中的类一致
const RH = { padt: $[VP], hdr: $[dp(48)], dh: $[HDH], note: $[CARDH + GAP], empty: $[dp(pill ? 150 : 104)], row: $[ROW], sub: $[dp(48)], padb: $[EBPAD] }
const SWX = $[dp(32)]
const VER = '1.0.0'
// 类型：名称、卡片小图标、彩色圆底图标、圆底色
const T = {
  park: { n: '停车', a: '/common/ic/a_park.png', c: '/common/ic/c_park.png', bg: 'bg-td' },
  pkg: { n: '取件码', a: '/common/ic/a_pkg.png', c: '/common/ic/c_pkg.png', bg: 'bg-sd' },
  lock: { n: '储物柜', a: '/common/ic/a_lock.png', c: '/common/ic/c_lock.png', bg: 'bg-pd' },
  ph: { n: '提醒', a: '/common/ic/a_note.png', c: '/common/ic/c_note.png', bg: 'bg-pd' },
  cus: { n: '记事', a: '/common/ic/a_edit.png', c: '/common/ic/c_edit.png', bg: 'bg-sd' },
  tut: { n: '教程', a: '/common/ic/a_tut.png', c: '/common/ic/c_tut.png', bg: 'bg-td' }
}
// 内置短语库：[文字, 卡片图标, 按钮图标]
const LIB = [
  ['回电话', '/common/ic/a_call.png', '/common/ic/i_call.png'], ['买东西', '/common/ic/a_cart.png', '/common/ic/i_cart.png'],
  ['带钥匙', '/common/ic/a_key.png', '/common/ic/i_key.png'], ['吃药', '/common/ic/a_med.png', '/common/ic/i_med.png'],
  ['拿快递', '/common/ic/a_pkg.png', '/common/ic/i_note.png'], ['取衣服', '/common/ic/a_note.png', '/common/ic/i_note.png'],
  ['倒垃圾', '/common/ic/a_note.png', '/common/ic/i_note.png'], ['充电', '/common/ic/a_note.png', '/common/ic/i_note.png'],
  ['喝水', '/common/ic/a_note.png', '/common/ic/i_note.png'], ['关窗', '/common/ic/a_note.png', '/common/ic/i_note.png'],
  ['交电费', '/common/ic/a_note.png', '/common/ic/i_note.png'], ['开会', '/common/ic/a_note.png', '/common/ic/i_note.png']
]
const PHDEF = ['回电话', '买东西', '带钥匙', '吃药']
const PHMAX = 8
function lib(t) { for (let i = 0; i < LIB.length; i++) if (LIB[i][0] === t) return LIB[i]; return [t, '/common/ic/a_note.png', '/common/ic/i_note.png'] }
// 引导结束后放进列表的教程记事（不过期，读完可自行删除）：[内容, 提示]
const TUT = [['左滑我试试', '置顶/删除'], ['点开看详情', '改有效期'], ['点 + 新建', '选类型/自定义'], ['到期自动清理', '不用手动删']]
const OB = [
  ['临时记事', '随手记下停车位、取件码$[pill ? "" : "等小事"]，到期自动清理'],
  ['点 + 新建', '$[pill ? "先选类型，也可自定义或点常用短语" : "先选类型，自定义可以用键盘写"]'],
  ['左滑卡片', '置顶或删除，删错了可以撤销'],
  ['到期自动清理', '$[pill ? "点开记事可改有效期或标记完成" : "点开记事能改有效期，✓ 标记完成"]']
]
const AZ = 'ABCDEFGHJKLMNPQRSTUVWXYZ'.split('')
const NUM = []
for (let n = 1; n <= 60; n++) NUM.push(n < 10 ? '0' + n : '' + n)
const PK = {
  park: { label: '$[pill ? "楼层 · 区位" : "停车位置"]', r1: ['B3', 'B2', 'B1', '1F', '2F', '3F', '4F', '5F'], s1: 1, r2: AZ, s2: 2, sep: '·', fmt: (a, b) => a + ' · ' + b + ' 区' },
  lock: { label: '$[pill ? "区 · 柜号" : "储物柜"]', r1: AZ, s1: 0, r2: NUM, s2: 0, sep: '-', fmt: (a, b) => a + ' 区 ' + b + ' 号' }
}
// 模块级状态（非 UI）
let notes = []          // 全部记事（存储顺序）
let cfg = {}
let stack = []          // 内部屏栈
let view = []           // 列表卡片对应的记事（排序后）
let numKind = 'pkg', cusPh = '', cusList = [], lastY = 0, moved = 0, rx0 = 0, ry0 = 0, bx0 = 0, bgo = 0, swiped = 0, tsw = 0, tx0 = 0, ty0 = 0, tx = 0, ty = 0
let undo = null         // { n, timer }
let detailId = '', expMode = '', defKind = '', pkKind = 'park'
let obX0 = 0, obX = 0
let groups = []         // TLC：[[数组名, 首行 top, 行高]]
export default {
  private: {
// #include @wear/base_data.js
    isHome: true, tlcOn: true, tlcBase: -1, scr: 'boot', isList: false, ebOn: false, ebSt: {},
    hdrRows: [], dhRows: [], cards: [], emptyRows: [], tpls: [], acts: [], abRows: [], subRows: [], acts2: [], phRows: [], radios: [], sel: -1,
    dlgOn: false, dlgOut: false, dlgTitle: '', dlgText: '', dlgKind: '', cfOn: false, cfOut: false,
    npLabel: '取件码', pkLabel: '', r1: [], r2: [], s1: 0, s2: 0, sep: '', draft: '',
    obi: 0, obPg: [], pageIndex: 0, pageCount: 4, dots: [], worm: [], pageWindow: 0, pagerBox: {}, pagerBackground: ''
  },
  onInit() { this.reload(true) },
  pageShow() { if (this.scr !== 'boot') this.reload(false) }, // 从键盘页返回 / 回到前台：重读存储并清理过期
  // ---------- 数据 ----------
  reload(first) {
    loadCfg(c => {
      cfg = c; if (!cfg.ek) cfg.ek = {}; if (!cfg.ph) cfg.ph = PHDEF.slice()
      loadNotes(list => {
        const added = list.length > notes.length
        notes = list; this.sweep()
        if (first) { stack = []; this.go(cfg.oobe ? 'list' : 'oobe') }
        else if (added && this.scr === 'create') this.saved() // 键盘页新建后：确认动画 → 回列表
        else this.render()
      })
    })
  },
  sweep() { // 清理已到期
    const now = Date.now(), keep = notes.filter(n => !n.exp || n.exp > now)
    if (keep.length !== notes.length) { notes.filter(n => n.exp && n.exp <= now).forEach(n => dropNote(n.id)); notes = keep; saveIdx(notes) }
  },
  onTick() { if (this.scr === 'list' && !undo && !this.cards.some(c => c.rv)) { this.sweep(); this.render() } }, // 每分钟：清理到期 + 刷新剩余时间
  ek(k) { return (cfg.ek && cfg.ek[k]) || DEF[k] || 'today' },
  add(k, v, ic) {
    if (notes.length >= MAX) { this.showFull(); return false }
    const now = Date.now(), e = this.ek(k), n = { id: newId(now), k, v, ic: ic || '', ct: now, ek: e, exp: expAt(e, now), pin: false }
    notes.push(n); putNote(n); saveIdx(notes); return true
  },
  saved() { this.showConfirm(); this.later(() => { this.hideConfirm(); stack = []; this.go('list') }, 1500) },
  // ---------- 屏栈 ----------
  go(s, push) { if (push !== false && this.scr !== 'boot' && this.scr !== s && stack[stack.length - 1] !== s) stack.push(s); else if (!stack.length) stack.push(s); this.scr = s; this.render(true) },
  open(s) { this.vib(); this.flushUndo(); stack.push(s); this.scr = s; this.render(true) },
  popScr() { stack.pop(); if (!stack.length) stack = ['list']; this.scr = stack[stack.length - 1]; this.render(true) },
  overlayBack() {
    if (this.cfOn) { this.hideConfirm(); return true }
    if (this.dlgOn) { this.closeDlg(); return true }
    if (this.scr === 'oobe' && !cfg.oobe) return false
    if (this.scr === 'list' && this.cards.some(c => c.rv)) { this.cards.forEach((c, j) => { if (c.rv) this.setCard(j, { rv: false }) }); return true }
    if (stack.length > 1) { this.popScr(); return true }
    return false
  },
  // ---------- 渲染 ----------
  render(reset) {
    const s = this.scr, L = { hdrRows: [], dhRows: [], cards: [], emptyRows: [], tpls: [], acts: [], abRows: [], subRows: [], acts2: [], phRows: [], radios: [] }
    const hdr = t => { L.hdrRows = [{ t }] }
    const act = (arr, id, ic, t, sub, fn, cls) => L[arr].push({ id, ic, t, s: sub || '', fn, cls: cls || 'bt', st: IDENT })
    const now = Date.now()
    if (s === 'list') {
      hdr('临时记事')
      view = notes.slice().sort((a, b) => (b.pin ? 1 : 0) - (a.pin ? 1 : 0) || b.ct - a.ct)
      L.cards = view.map(n => this.card(n, now))
      if (!view.length) L.emptyRows = [{ id: 'e' }]
      if (view.length > 1) act('acts2', 'clr', '/common/ic/i_sweep.png', '$[pill ? "清空" : "全部清除"]', '', 'askClear', 'bc')
      act('acts2', 'set', '/common/ic/i_set.png', '设置', '', 'toSet', 'bc')
    } else if (s === 'detail') {
      const n = notes.find(x => x.id === detailId)
      if (!n) { this.popScr(); return }
      const t = T[n.k] || T.cus
      L.dhRows = [{ ic: t.c, bg: t.bg, app: t.n, v: n.v, m: n.exp ? '剩 ' + rem(n.exp, now) + '$[pill ? "\\n" : " · "]' + at(n.exp, now) + (at(n.exp, now).length > 5 ? '' : ' 清除') : (n.k === 'tut' ? '教程 · 不会过期' : '不会过期'), soon: n.exp && n.exp - now < H1 }]
      if (n.exp) act('acts', 'ext', '/common/ic/i_more.png', '$[pill ? "延长" : "延长 1 小时"]', '$[pill ? "+1 小时" : "到 "]' + ($[pill ? 'false' : 'true'] ? at(n.exp + H1, now) : ''), 'extend')
      act('acts', 'exp', '/common/ic/i_timer.png', '有效期', n.exp ? EL[n.ek] || '自定义' : '不过期', 'toExpNote')
      act('acts', 'pin', n.pin ? '/common/ic/i_pinf.png' : '/common/ic/i_pin.png', n.pin ? '取消置顶' : '置顶', n.pin ? '$[pill ? "已置顶" : "当前已置顶"]' : '排在最前', 'togglePin')
    } else if (s === 'expiry') {
      const n = expMode === 'note' ? notes.find(x => x.id === detailId) : null
      hdr(expMode === 'note' ? '有效期' : T[defKind].n + '$[pill ? "" : "默认"]')
      const cur = n ? (n.exp ? n.ek : 'never') : this.ek(defKind)
      EK.forEach((k, i) => {
        let sub = ''
        if (k === 'never') sub = '手动删除'
        else if (n) sub = '到 ' + at(expAt(k, now), now)
        else sub = { h1: '从新建算起', h3: '从新建算起', today: '当天 23:59', tmr: '次日 23:59', d3: '从新建算起' }[k]
        L.radios.push({ id: 'r' + i, t: EL[k], s: sub, st: IDENT })
      })
      this.sel = EK.indexOf(cur)
    } else if (s === 'create') {
      hdr('新建记事')
      L.tpls = [
        { id: 't0', ic: T.park.c, bg: T.park.bg, t: '停车', s: '$[pill ? "楼层+区位" : "楼层 + 区位"]', fn: 'toPark', st: IDENT },
        { id: 't1', ic: T.pkg.c, bg: T.pkg.bg, t: '取件码', s: '数字键盘', fn: 'toNumpad', st: IDENT },
        { id: 't2', ic: T.lock.c, bg: T.lock.bg, t: '储物柜', s: '$[pill ? "区+柜号" : "区 + 柜号"]', fn: 'toLock', st: IDENT }
      ]
      // 自定义：圆屏/Pro 打开键盘；手环 = 从短语库选一句 + 可选数字
      L.tpls.push({ id: 't3', ic: T.cus.c, bg: T.cus.bg, t: '自定义', s: KB ? '键盘输入' : '短语+数字', fn: KB ? 'toKb' : 'toCus', st: IDENT })
      L.subRows = [{ t: '一键记下' }]
      const pe = EL[this.ek('ph')]
      cfg.ph.forEach((p, i) => act('acts2', 'p' + i, lib(p)[2], p, pe + '$[pill ? "" : "后清除"]'.replace('今天内后清除', '今天内').replace('明天后清除', '到明天').replace('不过期后清除', '不过期'), 'savePh'))
      act('acts2', 'phed', '/common/ic/i_lib.png', '编辑短语', '', 'toPhed', 'bc')
    } else if (s === 'set') {
      hdr('设置')
      act('acts', 'defs', '/common/ic/i_timer.png', '默认期限', '按类型', 'toDefs')
      act('acts', 'phs', '/common/ic/i_lib.png', '快捷短语', cfg.ph.length + ' 条', 'toPhed')
      act('acts', 'oobe', '/common/ic/i_help.png', '使用引导', '再看一遍', 'replay')
      act('acts', 'fav', '/common/ic/i_fav.png', '支持作者', '稍后开放', 'noop', 'bt dis')
      act('acts', 'about', '/common/ic/i_info.png', '关于', '版本 ' + VER, 'toAbout')
    } else if (s === 'defs') {
      hdr('默认期限')
      ;['park', 'pkg', 'lock', 'ph', 'cus'].forEach(k => act('acts', 'd' + k, '/common/ic/i_timer.png', T[k].n, EL[this.ek(k)], 'toExpDef', 'bt', k))
      L.acts.forEach((a, i) => { a.arg = ['park', 'pkg', 'lock', 'ph', 'cus'][i] })
    } else if (s === 'phed') {
      hdr('快捷短语')
      L.phRows = cfg.ph.map((p, i) => ({ id: 'q' + i, t: p, ic: lib(p)[2], st: IDENT }))
      if (KB) act('acts2', 'pkb', '/common/ic/i_kb.png', '自己写', '键盘输入', 'phKb')
      act('acts2', 'plib', '/common/ic/i_add.png', '添加短语', LIB.filter(l => cfg.ph.indexOf(l[0]) < 0).length + ' 条可选', 'toLib')
      act('acts2', 'prst', '/common/ic/i_hist.png', '恢复默认', '', 'phReset', 'bc')
    } else if (s === 'lib') {
      hdr('短语库')
      LIB.filter(l => cfg.ph.indexOf(l[0]) < 0).forEach((l, i) => act('acts', 'l' + i, l[2], l[0], '', 'libAdd'))
      if (!L.acts.length) L.subRows = [{ t: '都已添加' }]
    } else if (s === 'about') {
      hdr('关于')
      L.abRows = [['临时记事 ' + VER, '到期自动清理的小记事'], ['界面', '基于 vela-wear-m3 · © heDuke'], ['图标', 'Material Symbols · Apache-2.0']]
        .concat(KB ? [['输入法', '改编自喵喵输入法 · MIT']] : []).concat([['字体', 'Noto Sans SC · OFL-1.1'], ['许可全文', '见安装包 /common/legal/']])
        .map((r, i) => ({ id: 'a' + i, t: r[0], s: r[1], st: IDENT }))
    } else if (s === 'picker') {
      const c = PK[pkKind]; this.pkLabel = c.label; this.r1 = c.r1; this.r2 = c.r2; this.s1 = c.s1; this.s2 = c.s2; this.sep = c.sep
    } else if (s === 'cpick') {
      hdr('$[pill ? "选一句" : "选一句短语"]')
      cusList.forEach((p, i) => act('acts', 'k' + i, lib(p)[2], p, '', 'cusPick'))
    } else if (s === 'numpad') {
      if (reset) this.draft = ''
      this.npLabel = numKind === 'cus' ? cusPh + ' + 数字' : '取件码'
    } else if (s === 'oobe') {
      if (reset) this.obi = 0
      this.obShow()
    }
    Object.keys(L).forEach(k => { this[k] = L[k] })
    this.isList = ['picker', 'numpad', 'oobe', 'boot'].indexOf(s) < 0
    this.ebOn = s === 'list' || s === 'detail' || s === 'picker' || (PILL && s === 'numpad')
    this.relayout(reset)
  },
  card(n, now) {
    const t = T[n.k] || T.cus, tut = n.k === 'tut'
    const left = n.exp ? rem(n.exp, now) : '不过期'
    return { id: n.id, ic: n.k === 'ph' ? lib(n.v)[1] : (n.ic || t.a), app: t.n, ttl: n.v, pin: n.pin,
      tm: tut ? n.h : left, tm2: tut ? n.h : (n.exp ? '剩 ' + left : '不过期'), soon: !!n.exp && n.exp - now < H1,
      rv: false, ud: false, hc: false, st: IDENT }
  },
  relayout(reset) {
    const h = [], add = (n, k) => { for (let i = 0; i < n; i++) h.push(RH[k]) }
    groups = []
    const grp = (name, k) => { groups.push([name, h.reduce((a, b) => a + b, 0), RH[k]]); add(this[name].length, k) }
    add(1, 'padt'); grp('hdrRows', 'hdr'); add(this.dhRows.length, 'dh'); grp('cards', 'note'); add(this.emptyRows.length, 'empty')
    grp('tpls', 'row'); grp('acts', 'row'); grp('abRows', 'row'); add(this.subRows.length, 'sub'); grp('acts2', 'row'); grp('phRows', 'row'); grp('radios', 'row'); add(1, 'padb')
    this.setLayout(h)
    if (reset) { try { const el = this.$element('lst'); if (el) el.scrollTo({ index: 0 }) } catch (e) {} }
    const mx = Math.max(0, h.reduce((a, b) => a + b, 0) - $[H])
    this.onScrolled(reset ? 0 : Math.min(lastY, mx), mx) // 非重置的重绘保持当前滚动位置（否则 EdgeButton/TLC 会按顶部计算）
  },
  // 多段 TLC（库只变换 items 一段）：每段按自己的首行位置计算 tlcStyle
  onScrolled(y, m) {
    lastY = y
    groups.forEach(g => { const arr = this[g[0]]; for (let i = 0; i < arr.length; i++) { const top = g[1] + i * g[2] - y, st = tlcStyle(top, top + g[2]), it = arr[i]; if (!it.st || it.st.transform !== st.transform || it.st.opacity !== st.opacity) it.st = st } })
    const fixed = this.scr === 'picker' || this.scr === 'numpad'
    let f = fixed || m <= 0 ? 1 : (y - (m - 2 * EBH)) / EBH
    f = f < 0 ? 0 : f > 1 ? 1 : f
    const st = { transform: JSON.stringify({ translateY: Math.round((1 - f) * EBH) + 'px' }), opacity: Math.round(f * 100) / 100 }
    if (st.transform !== this.ebSt.transform) this.ebSt = st
  },
  // ---------- 列表 ----------
  setCard(i, patch) { const it = Object.assign({}, this.cards[i], patch); it.hc = it.ud || (PILL && it.rv); this.cards.splice(i, 1, it) },
  // 左右滑由 touchmove 判定（模拟器上 list 内横向拖动后 touchend 常不到达）
  tDown(i, e) { const p = pt(e); if (p) { tx0 = tx = p[0]; ty0 = ty = p[1] } tsw = 0; this.press(this.cards[i].id) },
  tMove(i, e) { const p = pt(e); if (p) { tx = p[0]; ty = p[1] } const dx = tx - tx0; if (Math.abs(dx) > 8 || Math.abs(ty - ty0) > 8) this.cancelPress(); if (!tsw && Math.abs(dx) > SWX && Math.abs(dx) > 1.5 * Math.abs(ty - ty0)) { tsw = 1; this.swipeRow(i, dx < 0 ? 'left' : 'right') } },
  tUp(i, e) { const p = pt(e); if (p) { tx = p[0]; ty = p[1] } this.release(this.cards[i].id); const dx = tx - tx0; if (!tsw && Math.abs(dx) > SWX && Math.abs(dx) > 1.5 * Math.abs(ty - ty0)) { tsw = 1; this.swipeRow(i, dx < 0 ? 'left' : 'right') } },
  swipeRow(i, d) { swiped = Date.now(); if (d === 'left') { if (!this.cards[i].rv && !this.cards[i].ud) this.reveal(i) } else if (this.cards[i].rv) this.setCard(i, { rv: false }) },
  reveal(i) { this.vib(); this.cards.forEach((c, j) => { if (c.rv && j !== i) this.setCard(j, { rv: false }) }); this.setCard(i, { rv: true }) },
  openNote(i) {
    if (Date.now() - swiped < 400) return
    if (this.cards[i].rv) { this.setCard(i, { rv: false }); return }
    if (this.cards[i].ud) return
    detailId = view[i].id; this.open('detail')
  },
  pinRow(i) { this.vib(); const n = view[i]; n.pin = !n.pin; putNote(n); this.render() },
  // 删除：立即从存储移除（进程被杀也不会“复活”），撤销时写回；4 秒后撤销按钮消失
  delRow(i) {
    this.vib(); this.flushUndo()
    const n = view[i]; notes = notes.filter(x => x.id !== n.id); dropNote(n.id); saveIdx(notes)
    undo = { n, timer: setTimeout(() => { undo = null; if (this.scr === 'list') this.render() }, 4000) }
    this.setCard(i, { rv: false, ud: true })
  },
  undoRow(i) {
    if (!undo) return
    this.vib(); clearTimeout(undo.timer); const n = undo.n; undo = null
    if (notes.length < MAX) { notes.push(n); putNote(n); saveIdx(notes) }
    this.render()
  },
  flushUndo() { if (undo) { clearTimeout(undo.timer); undo = null } },
  askClear() { this.dlgKind = 'clear'; this.dlgTitle = '全部清除？'; this.dlgText = '共 ' + notes.length + ' 条，删除后无法恢复'; this.dlgOut = false; this.dlgOn = true },
  showFull() { this.dlgKind = 'full'; this.dlgTitle = '记事已满'; this.dlgText = '最多 ' + MAX + ' 条，先删掉几条吧'; this.dlgOut = false; this.dlgOn = true },
  dlgCancel() { this.closeDlg() },
  dlgOk() { this.closeDlg(); if (this.dlgKind === 'clear') { this.flushUndo(); notes.forEach(n => dropNote(n.id)); notes = []; saveIdx(notes); this.render() } },
  closeDlg() { this.dlgOut = true; this.later(() => { this.dlgOn = false; this.dlgOut = false }, 200) },
  tapEb() {
    if (mvd()) return
    this.vib()
    if (this.scr === 'list') { if (notes.length >= MAX) this.showFull(); else this.open('create') }
    else if (this.scr === 'detail') this.done()
    else if (this.scr === 'picker') this.savePk()
    else if (this.scr === 'numpad') this.saveCode()
  },
  // 行按钮：拖动超过 10px 视为滚动/滑动，不触发点击
  rDown(id, e) { const p = pt(e); if (p) { rx0 = p[0]; ry0 = p[1] } bgo = 0; this.press(id) },
  rMove(e) { const p = pt(e); if (!p) return; const dx = p[0] - rx0, dy = p[1] - ry0; if (Math.abs(dx) > 10 || Math.abs(dy) > 10) { moved = Date.now(); this.cancelPress() } if (!bgo && dx > 2 * SWX && dx > 2 * Math.abs(dy)) { bgo = 1; this.doBack() } },
  // 右滑返回：行上横向右滑、或左缘触摸条右滑（单页 App 自己的返回手势；与系统返回键共用 doBack/overlayBack）
  // 注：模拟器最左约 20px 被系统手势占用，触摸条因此加宽到 32–34px
  bDown(e) { const p = pt(e); bx0 = p ? p[0] : 0; bgo = 0 },
  bMove(e) { const p = pt(e); if (!bgo && p && p[0] - bx0 > SWX) { bgo = 1; this.doBack() } },
  tapAct(i) { if (mvd()) return; const a = this.acts[i]; if (a && this[a.fn]) this[a.fn](a.arg !== undefined ? a.arg : i) },
  tapAct2(i) { if (mvd()) return; const a = this.acts2[i]; if (a && this[a.fn]) this[a.fn](i) },
  tapTpl(i) { if (mvd()) return; const a = this.tpls[i]; if (a) this[a.fn]() },
  noop() {},
  toSet() { this.open('set') },
  // ---------- 详情 ----------
  extend() { const n = notes.find(x => x.id === detailId); if (!n || !n.exp) return; this.vib(); n.exp += H1; putNote(n); this.render() },
  togglePin() { const n = notes.find(x => x.id === detailId); if (!n) return; this.vib(); n.pin = !n.pin; putNote(n); this.render() },
  toExpNote() { expMode = 'note'; this.open('expiry') },
  done() { // 完成 = 删除；回到列表后该行显示「撤销删除」
    const id = detailId; stack = ['list']; this.scr = 'list'; this.render(true)
    const i = view.findIndex(n => n.id === id); if (i >= 0) this.delRow(i)
  },
  // ---------- 有效期 ----------
  choose(i) {
    if (mvd()) return
    this.vib(); this.sel = i; const k = EK[i]
    if (expMode === 'note') { const n = notes.find(x => x.id === detailId); if (n) { n.ek = k; n.exp = expAt(k, Date.now()); putNote(n) } }
    else { cfg.ek[defKind] = k; saveCfg(cfg) }
    this.later(() => this.popScr(), 250)
  },
  // ---------- 新建 ----------
  toPark() { pkKind = 'park'; this.open('picker') },
  toLock() { pkKind = 'lock'; this.open('picker') },
  toNumpad() { numKind = 'pkg'; this.open('numpad') },
  toCus() { this.vib(); const a = cfg.ph.slice(); LIB.forEach(l => { if (a.indexOf(l[0]) < 0) a.push(l[0]) }); cusList = a; this.open('cpick') },
  cusPick(i) { const p = cusList[i]; if (p === undefined) return; cusPh = p; numKind = 'cus'; this.open('numpad') },
  toKb() { if (!unlocked()) return; this.vib(); router.push({ uri: '/pages/kb', params: { m: 'note' } }) },
  ch1(e) { this.s1 = e.newSelected; this.vib() },
  ch2(e) { this.s2 = e.newSelected; this.vib() },
  savePk() { const c = PK[pkKind]; if (this.add(pkKind, c.fmt(c.r1[this.s1], c.r2[this.s2]))) this.saved() },
  key(k) { this.vib(); if (k === 'bk') this.draft = this.draft.slice(0, -1); else if (this.draft.length < 10) this.draft += k },
  saveCode() {
    if (numKind === 'cus') { if (this.add('cus', cusPh + (this.draft ? ' ' + this.draft : ''), lib(cusPh)[1])) this.saved(); return }
    if (!this.draft) return; if (this.add('pkg', this.draft)) this.saved()
  },
  savePh(i) { const p = cfg.ph[i]; if (p === undefined) return; this.vib(); if (this.add('ph', p)) this.saved() },
  // ---------- 设置 / 短语 ----------
  toDefs() { this.open('defs') },
  toExpDef(k) { defKind = k; expMode = 'def'; this.open('expiry') },
  toPhed() { this.open('phed') },
  toLib() { if (cfg.ph.length >= PHMAX) { this.dlgKind = 'full'; this.dlgTitle = '短语已满'; this.dlgText = '最多 ' + PHMAX + ' 条'; this.dlgOut = false; this.dlgOn = true; return } this.open('lib') },
  libAdd(i) { if (mvd()) return; const a = this.acts[i]; if (!a) return; this.vib(); cfg.ph.push(a.t); saveCfg(cfg); this.popScr() },
  phKb() { if (cfg.ph.length >= PHMAX) { this.toLib(); return } this.vib(); router.push({ uri: '/pages/kb', params: { m: 'ph' } }) },
  phUp(i) { if (mvd()) return; if (i <= 0) return; this.vib(); const a = cfg.ph; const t = a[i]; a[i] = a[i - 1]; a[i - 1] = t; saveCfg(cfg); this.render() },
  phDel(i) { if (mvd()) return; this.vib(); cfg.ph.splice(i, 1); saveCfg(cfg); this.render() },
  phReset() { this.vib(); cfg.ph = PHDEF.slice(); saveCfg(cfg); this.render() },
  toAbout() { this.open('about') },
  replay() { this.open('oobe') },
  // ---------- 引导 ----------
  obShow() {
    const o = OB[this.obi]; this.obPg = [{ k: this.obi, tk: this.obi + 1, t: o[0], b: o[1] }]
    // 静态翻页：选中点画进 dots 本身（class 切换不透明度）。tid 从 1 开始：tid 为 0（假值）的节点在 Vela 上不会被更新，首点会残留白色
    const p = pagerState(this.obi, 4, 0, false, this.pageWindow); this.pageWindow = p.hidden; this.dots = p.dots.map((d, i) => { const w = i === this.obi && p.worm.length, q = w ? p.worm[0].st : d.st; return { id: i + 1, on: w, st: { left: q.left, top: q.top, width: q.width, height: q.height, borderRadius: q.borderRadius } } }); this.worm = []; this.pagerBox = p.style; this.pagerBackground = p.src
  },
  obDown(e) { const p = pt(e); obX0 = obX = p ? p[0] : 0 },
  obMove(e) { const p = pt(e); if (p) obX = p[0] },
  obUp() { const dx = obX - obX0; obX0 = obX = 0; if (Math.abs(dx) < SWX) return; const n = this.obi + (dx < 0 ? 1 : -1); if (n < 0 || n > 3) return; this.vib(); this.obi = n; this.obShow() },
  obEnd() {
    this.vib()
    if (!cfg.tut) { // 只在第一次完成引导时放教程记事；重看引导不会重复添加
      const now = Date.now()
      TUT.forEach((r, i) => { if (notes.length < MAX) { const n = { id: newId(now) + i, k: 'tut', v: r[0], h: r[1], ct: now - i, ek: 'never', exp: 0, pin: false }; notes.push(n); putNote(n) } })
      saveIdx(notes); cfg.tut = 1
    }
    cfg.oobe = 1; saveCfg(cfg)
    stack = []; this.scr = 'list'; stack.push('list'); this.render(true)
  },
// #include @wear/confirm.js
// #include @wear/base.js
  onHide() { this.flushUndo(); this.cleanup() }, // 覆盖库的 onHide（库会调用名为 pageHide 的钩子，本 App 不用该名字）
}
function mvd() { return Date.now() - moved < 400 }
function pt(e) { const t = e && (e.touches && e.touches[0] || e.changedTouches && e.changedTouches[0]); return t ? [t.pageX !== undefined ? t.pageX : t.clientX, t.pageY !== undefined ? t.pageY : t.clientY] : null }
</script>
