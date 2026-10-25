// 存储：@system.storage 只存字符串。一个索引 key（id 数组）+ 每条记事一个 key + 一个设置 key，
// 改一条只写一条，不重写整表。全部回调式（不依赖 async/await）。
import storage from '@system.storage'
const IDX = 'qn.idx', P = 'qn.n.', CFG = 'qn.cfg'
export const MAX = 20
function get(k, cb) { storage.get({ key: k, success: d => cb(d || ''), fail: () => cb('') }) }
function nop() {}
// 总是传回调：不传时框架会报 "invoke success callback failed"
function set(k, v, cb) { storage.set({ key: k, value: v, success: cb || nop, fail: cb || nop }) }
function parse(s, d) { try { return s ? JSON.parse(s) : d } catch (e) { return d } }
export function loadCfg(cb) { get(CFG, s => cb(parse(s, {}) || {})) }
export function saveCfg(c, cb) { set(CFG, JSON.stringify(c), cb) }
// 读出全部记事（按索引顺序）；顺带修复索引里指向空值的 id
export function loadNotes(cb) {
  get(IDX, s => {
    const ids = parse(s, []) || [], out = []
    let i = 0
    const next = () => {
      if (i >= ids.length) { if (out.length !== ids.length) saveIdx(out); return cb(out) }
      get(P + ids[i++], v => { const n = parse(v, null); if (n && n.id) out.push(n); next() })
    }
    next()
  })
}
export function putNote(n, cb) { set(P + n.id, JSON.stringify(n), cb) }
export function dropNote(id) { storage.delete({ key: P + id, success: nop, fail: nop }) }
export function saveIdx(notes, cb) { set(IDX, JSON.stringify(notes.map(n => n.id)), cb) }
