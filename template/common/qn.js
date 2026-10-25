// 记事类型、有效期预设与时间格式（main 页与键盘页共用）。
// 测试构建（QN_FAST=1 bash tools/build.sh）把「1 小时」缩成 1 分钟，用来在模拟器上验证到期清理
export const H1 = $[process.env.QN_FAST ? 60000 : 3600000]
export const EK = ['h1', 'h3', 'today', 'tmr', 'd3', 'never']
export const EL = { h1: '1 小时', h3: '3 小时', today: '今天内', tmr: '明天', d3: '3 天', never: '不过期' }
// 各类型默认有效期（设置里可改）
export const DEF = { park: 'today', pkg: 'd3', lock: 'today', ph: 'h3', cus: 'today' }
export function expAt(k, now) {
  const d = new Date(now)
  if (k === 'h1') return now + H1
  if (k === 'h3') return now + 3 * H1
  if (k === 'today') { d.setHours(23, 59, 59, 0); return d.getTime() }
  if (k === 'tmr') { d.setDate(d.getDate() + 1); d.setHours(23, 59, 59, 0); return d.getTime() }
  if (k === 'd3') return now + 72 * H1
  return 0
}
export function p2(n) { return n < 10 ? '0' + n : '' + n }
export function hm(t) { const d = new Date(t); return p2(d.getHours()) + ':' + p2(d.getMinutes()) }
// 绝对时刻：今天 "14:05"，明天 "明天 23:59"，更远 "10/29 14:05"
export function at(t, now) {
  const a = new Date(t), b = new Date(now)
  const day = x => Math.floor((x.getTime() - x.getTimezoneOffset() * 60000) / 86400000)
  const dd = day(a) - day(b)
  return dd === 0 ? hm(t) : dd === 1 ? '明天 ' + hm(t) : (a.getMonth() + 1) + '/' + a.getDate() + ' ' + hm(t)
}
// 剩余时间："28 分钟" / "5 小时" / "2 天"
export function rem(exp, now) {
  const d = exp - now
  if (d <= 0) return '已到期'
  if (d < H1) return Math.max(1, Math.ceil(d / 60000)) + ' 分钟'
  if (d < 24 * H1) return Math.floor(d / H1) + ' 小时'
  return Math.floor(d / (24 * H1)) + ' 天'
}
export function newId(now) { return now.toString(36) + Math.floor(Math.random() * 1296).toString(36) }
