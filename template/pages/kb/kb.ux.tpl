<!-- 「自定义」键盘页（仅圆屏 / Pro）：参考 Wear OS 版 Gboard 的版式与 M3 配色重做的 QWERTY 键盘，
     拼音引擎与词库复用 喵喵输入法（MIT），见 /common/legal/ime/。params.m = 'note'（新建记事）| 'ph'（新增常用短语） -->
<template>
<div class="kb">
  <!-- 预览：已输入文字（尾部）+ 正在拼的拼音 + 光标 -->
  <div class="pv">
    <text class="pv-t {{hint ? 'pv-h' : ''}} {{err ? 'pv-e' : ''}}">{{shown}}</text>
    <text class="pv-c" if="{{comp}}">{{comp}}</text>
    <div class="pv-cur" if="{{!hint && !err}}"></div>
  </div>
  <!-- 候选条：一页放得下的候选 + 翻页 -->
  <div class="cs">
    <text class="cs-i {{$idx === 0 && page === 0 ? 'cs-1' : ''}}" for="{{cands}}" onclick="pickC($idx)">{{$item}}</text>
    <div class="cs-sp"></div>
    <div class="cs-m" if="{{more}}" onclick="nextP"><text class="cs-mt">›</text></div>
  </div>
  <div class="row r1"><div class="k {{pr === 'a' + $idx ? 'kp' : ''}}" for="{{r1}}" ontouchstart="da($idx)" ontouchend="up" ontouchcancel="up" onclick="k1($idx)"><text class="kt">{{$item}}</text></div></div>
  <div class="row r2"><div class="k {{pr === 'b' + $idx ? 'kp' : ''}}" for="{{r2}}" ontouchstart="db($idx)" ontouchend="up" ontouchcancel="up" onclick="k2($idx)"><text class="kt">{{$item}}</text></div></div>
  <div class="row r3">
    <div class="k kf {{caps ? 'kon' : ''}} {{pr === 'sh' ? 'kp' : ''}}" ontouchstart="dn('sh')" ontouchend="up" ontouchcancel="up" onclick="shift"><image class="ki" if="{{mode !== 'sym'}}" src="{{caps ? '/common/ic/k_upon.png' : '/common/ic/k_up.png'}}"></image><text class="kt kts" if="{{mode === 'sym'}}">1/2</text></div>
    <div class="k {{pr === 'c' + $idx ? 'kp' : ''}}" for="{{r3}}" ontouchstart="dc($idx)" ontouchend="up" ontouchcancel="up" onclick="k3($idx)"><text class="kt">{{$item}}</text></div>
    <div class="k kf {{pr === 'bk' ? 'kp' : ''}}" ontouchstart="dn('bk')" ontouchend="up" ontouchcancel="up" onclick="bksp"><image class="ki" src="/common/ic/k_bk.png"></image></div>
  </div>
  <div class="row r4">
    <div class="k kf k123 {{pr === 'sy' ? 'kp' : ''}}" ontouchstart="dn('sy')" ontouchend="up" ontouchcancel="up" onclick="sym"><text class="kt kts">{{mode === 'sym' ? 'ABC' : '?123'}}</text></div>
    <div class="k kf klg {{pr === 'lg' ? 'kp' : ''}}" ontouchstart="dn('lg')" ontouchend="up" ontouchcancel="up" onclick="lang"><text class="kt kts">{{cn ? '中' : '英'}}</text></div>
    <div class="k ksp {{pr === 'sp' ? 'kp' : ''}}" ontouchstart="dn('sp')" ontouchend="up" ontouchcancel="up" onclick="space"><text class="kt ksp-t">{{cn ? '拼音' : 'English'}}</text></div>
    <div class="k kok {{pr === 'ok' ? 'kokp' : ''}}" ontouchstart="dn('ok')" ontouchend="up" ontouchcancel="up" onclick="ok"><image class="ki" src="/common/ic/k_ok.png"></image></div>
  </div>
</div>
</template>

<style>
/* #set LG = round */
/* #set PVT = dp(LG ? 26 : 22) */
/* #set PVH = dp(LG ? 28 : 30) */
/* #set PVW = dp(LG ? 150 : 156) */
/* #set CST = dp(LG ? 58 : 56) */
/* #set CSH = dp(LG ? 30 : 32) */
/* #set CSW = dp(LG ? 196 : 160) */
/* #set R0 = dp(LG ? 92 : 94) */
/* #set KH = dp(LG ? 26 : 32) */
/* #set RS = dp(LG ? 29 : 36) */
/* #set KG = dp(LG ? 2 : 1) */
/* #set KW = dp(LG ? 19 : 15) */
/* #set FW = dp(LG ? 24 : 23) */
.kb { width: $[W]px; height: $[H]px; background-color: $[C.background]; }
.pv { position: absolute; left: $[Math.round((W - PVW) / 2)]px; top: $[PVT]px; width: $[PVW]px; height: $[PVH]px; flex-direction: row; justify-content: center; align-items: center; border-bottom-width: 1px; border-color: $[C.outlineVariant]; }
.pv-t { font-size: $(18); color: $[C.onBackground]; lines: 1; font-weight: bold; }
.pv-h { color: $[C.onSurfaceVariant]; font-weight: normal; font-size: $(15); }
.pv-e { color: $[C.error]; font-weight: normal; font-size: $(15); }
.pv-c { font-size: $(15); color: $[C.primary]; lines: 1; margin-left: $(2); }
.pv-cur { width: $(2); height: $(18); margin-left: $(1); background-color: $[C.primary]; }
.cs { position: absolute; left: $[Math.round((W - CSW) / 2)]px; top: $[CST]px; width: $[CSW]px; height: $[CSH]px; flex-direction: row; align-items: center; }
.cs-i { height: $[CSH]px; line-height: $[CSH]px; font-size: $(16); color: $[C.onSurface]; padding-left: $(6); padding-right: $(6); lines: 1; }
.cs-1 { color: $[C.primary]; font-weight: bold; }
.cs-sp { flex-grow: 1; }
.cs-m { width: $(26); height: $(26); border-radius: $(13); background-color: $[C.surfaceContainer]; justify-content: center; align-items: center; }
.cs-mt { font-size: $(18); line-height: $(24); color: $[C.onSurface]; font-weight: bold; }
.row { position: absolute; left: 0px; width: $[W]px; height: $[KH]px; flex-direction: row; justify-content: center; }
.r1 { top: $[R0]px; } .r2 { top: $[R0 + RS]px; } .r3 { top: $[R0 + 2 * RS]px; } .r4 { top: $[R0 + 3 * RS]px; }
.k { width: $[KW]px; height: $[KH]px; margin-left: $[Math.floor(KG / 2)]px; margin-right: $[Math.ceil(KG / 2)]px; border-radius: $(8); background-color: $[C.surfaceContainer]; justify-content: center; align-items: center; }
.kp { background-color: $[C.surfaceContainerHigh]; }
.kf { width: $[FW]px; background-color: $[C.secondaryContainer]; }
.kon { background-color: $[C.primaryDim]; }
.k123 { width: $[dp(LG ? 32 : 34)]px; }
.klg { width: $[dp(LG ? 28 : 30)]px; }
.ksp { width: $[dp(LG ? 54 : 58)]px; }
.kok { width: $[dp(LG ? 32 : 34)]px; background-color: $[C.primaryDim]; border-radius: $[KH / 2]px; }
.kokp { background-color: $[C.primary]; }
.kt { font-size: $[dp(LG ? 14 : 13)]px; color: $[C.onSurface]; font-weight: bold; text-align: center; lines: 1; }
.kts { font-size: $(11); color: $[C.onSecondaryContainer]; }
.ksp-t { font-size: $(10); color: $[C.onSurfaceVariant]; font-weight: normal; }
.ki { width: $(16); height: $(16); }
</style>

<script>
import router from '@system.router'
import vibrator from '@system.vibrator'
import { loadNotes, loadCfg, saveCfg, putNote, saveIdx, MAX } from '../../common/store.js'
import { DEF, expAt, newId } from '../../common/qn.js'
import { createDictionaryLoader } from '../../common/ime/dictionaryLoader.js'

const L1 = 'qwertyuiop'.split(''), L2 = 'asdfghjkl'.split(''), L3 = 'zxcvbnm'.split('')
const S1 = '1234567890'.split(''), S2 = '-/:;()@&"'.split(''), S3 = '.,?!\'#%'.split('')
const T1 = '[]{}<>+=*^'.split(''), T2 = '_\\|~$¥€·…'.split(''), T3 = '。，？！、：；'.split('')
const LIMIT = { note: 24, ph: 8 }
const AVAIL = $[dp(LG ? 196 : 160) - dp(30)]          // 候选条可用宽度（px，扣掉翻页键）
const CHW = $[dp(16)], PAD = $[dp(12)]
let ime = null, all = [], sylTop = [], matched = 0, busy = false, errT = null

export default {
  protected: { m: 'note' },
  private: {
    text: '', cval: '', comp: '', shown: '', hint: true, err: false,
    mode: 'abc', cn: true, caps: false, sub: 0,
    pr: '', r1: L1, r2: L2, r3: L3, cands: [], page: 0, more: false, starts: [0]
  },
  onInit() { ime = createDictionaryLoader(); this.paint() },
  onDestroy() { if (ime) ime.destroy(); ime = null; if (errT) clearTimeout(errT) },
  dn(id) { this.pr = id }, da(i) { this.pr = 'a' + i }, db(i) { this.pr = 'b' + i }, dc(i) { this.pr = 'c' + i }, up() { this.pr = '' },
  lim() { return LIMIT[this.m] || 24 },
  vib() { try { vibrator.vibrate({ mode: 'short' }) } catch (e) {} },
  keys() {
    const up = s => this.caps ? s.toUpperCase() : s
    if (this.mode === 'sym') { const a = this.sub ? [T1, T2, T3] : [S1, S2, this.cn ? T3 : S3]; this.r1 = a[0]; this.r2 = a[1]; this.r3 = a[2] }
    else { this.r1 = L1.map(up); this.r2 = L2.map(up); this.r3 = L3.map(up) }
  },
  paint() {
    const t = this.text
    this.hint = !t && !this.cval && !this.err
    if (!this.err) this.shown = this.hint ? (this.m === 'ph' ? '新短语' : '要记的事') : (t.length > 8 ? '…' + t.slice(-7) : t)
  },
  // ---------- 候选 ----------
  query() {
    if (!this.cval || !this.cn) { all = []; this.comp = this.cval; this.layoutC(0); return }
    const word = this.cval
    let sync = false
    ime.search(word, 'cn', (data, display) => {
      sync = true
      if (word !== this.cval) return
      this.comp = display || word
      matched = data.matched ? data.matched.length : 0
      const multi = data.multi || { words: [], composed: '', sylTopChars: [] }
      sylTop = (multi.sylTopChars || []).filter(s => s.char && s.offset > 0)
      let words = (multi.words || []).slice()
      if (multi.composed && multi.composed.length >= 2 && words.indexOf(multi.composed) === -1) words.push(multi.composed)
      sylTop.forEach(s => { if (words.indexOf(s.char) === -1) words.push(s.char) })
      ;(data.chars || []).forEach(c => { if (words.indexOf(c) === -1) words.push(c) })
      all = words.slice(0, 60)
      this.layoutC(0)
    })
    if (!sync) { this.comp = word; this.cands = []; this.more = false }
  },
  layoutC(p) {
    // 分页：从 starts[p] 起，按字数估算宽度能放下几个
    if (p === 0) this.starts = [0]
    const s = this.starts[p] || 0
    let w = 0, e = s
    while (e < all.length) { const cw = all[e].length * CHW + PAD; if (e > s && w + cw > AVAIL) break; w += cw; e++ }
    this.page = p; this.cands = all.slice(s, e); this.more = e < all.length || p > 0
    if (this.starts.length <= p + 1) this.starts.push(e)
  },
  nextP() { this.vib(); const n = this.starts[this.page + 1]; this.layoutC(n !== undefined && n < all.length ? this.page + 1 : 0) },
  pickC(i) {
    const c = this.cands[i]; if (!c) return
    this.vib()
    let rest = ''
    if (c.length === 1) {
      const st = sylTop.find(s => s.char === c && s.offset <= this.cval.length)
      if (st) rest = this.cval.slice(st.offset)
      else if (matched > 0 && this.cval.length > matched) rest = this.cval.slice(matched)
    }
    this.put(c); this.cval = rest; this.query(); this.paint()
  },
  // ---------- 输入 ----------
  put(s) { const room = this.lim() - this.text.length; if (room <= 0) { this.flash('最多 ' + this.lim() + ' 个字'); return } this.text += s.slice(0, room) },
  type(ch) {
    this.vib(); this.pr = ''
    if (this.mode === 'abc' && this.cn) { if (this.cval.length < 24) this.cval += ch.toLowerCase(); this.query() }
    else { this.put(ch); if (this.caps && this.mode === 'abc') { this.caps = false; this.keys() } }
    this.paint()
  },
  k1(i) { this.type(this.r1[i]) }, k2(i) { this.type(this.r2[i]) }, k3(i) { this.type(this.r3[i]) },
  shift() { this.vib(); if (this.mode === 'sym') this.sub = this.sub ? 0 : 1; else this.caps = !this.caps; this.keys() },
  sym() { this.vib(); this.commitRaw(); this.mode = this.mode === 'sym' ? 'abc' : 'sym'; this.sub = 0; this.caps = false; this.keys(); this.paint() },
  lang() { this.vib(); this.commitRaw(); this.cn = !this.cn; this.caps = false; if (this.mode === 'sym') this.mode = 'abc'; this.keys(); this.paint() },
  commitRaw() { if (this.cval) { this.put(this.cval); this.cval = ''; this.query() } },
  space() {
    this.vib()
    if (this.cval) { if (this.cands.length) this.pickC(0); else { this.commitRaw(); this.paint() } return }
    if (this.text) this.put(' ')
    this.paint()
  },
  bksp() {
    this.vib()
    if (this.cval) { this.cval = this.cval.slice(0, -1); this.query() } else this.text = this.text.slice(0, -1)
    this.paint()
  },
  flash(msg) {
    this.err = true; this.shown = msg; this.hint = false
    if (errT) clearTimeout(errT)
    errT = setTimeout(() => { errT = null; this.err = false; this.paint() }, 1500)
  },
  // ---------- 保存 ----------
  ok() {
    if (this.cval) { this.vib(); this.commitRaw(); this.paint(); return }
    const v = this.text.trim()
    if (!v || busy) { this.flash(this.m === 'ph' ? '先输入短语' : '先输入内容'); return }
    this.vib(); busy = true
    if (this.m === 'ph') {
      loadCfg(cfg => {
        if (!cfg.ph) cfg.ph = ['回电话', '买东西', '带钥匙', '吃药']
        if (cfg.ph.length >= 8) { busy = false; this.flash('短语已满 8 条'); return }
        if (cfg.ph.indexOf(v) < 0) cfg.ph.push(v)
        saveCfg(cfg, () => { busy = false; router.back() })
      })
      return
    }
    loadCfg(cfg => loadNotes(list => {
      if (list.length >= MAX) { busy = false; this.flash('已满 ' + MAX + ' 条'); return }
      const now = Date.now(), e = (cfg.ek && cfg.ek.cus) || DEF.cus
      const n = { id: newId(now), k: 'cus', v, ic: '', ct: now, ek: e, exp: expAt(e, now), pin: false }
      putNote(n, () => saveIdx(list.concat([n]), () => { busy = false; router.back() }))
    }))
  }
}
</script>
