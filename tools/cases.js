// 预览用例（tools/preview.js）：单页 main 用方法调用切屏；kb 为圆屏/Pro 的键盘页。db = 模拟的 storage。
const big = () => 99999
const done = s => s.obEnd()
const T = (s, str) => { for (const ch of str) s.type(ch) }
module.exports = [
  ...[0, 1, 2, 3].map(k => ({ page: 'main', name: 'oobe' + (k + 1), setup: s => { s.obi = k; s.obShow() } })),
  { page: 'main', name: 'seeded', setup: done },
  { page: 'main', name: 'seeded-swipe', setup: s => { done(s); s.reveal(0) } },
  { page: 'main', name: 'create', setup: s => { done(s); s.open('create') } },
  { page: 'main', name: 'create-end', setup: s => { done(s); s.open('create') }, scroll: big },
  { page: 'main', name: 'cus-pick', only: ['band10', 'band9'], setup: s => { done(s); s.open('create'); s.toCus() } },
  { page: 'main', name: 'cus-num', only: ['band10', 'band9'], setup: s => { done(s); s.open('create'); s.toCus(); s.cusPick(4); s.draft = '3' } },
  { page: 'main', name: 'settings', setup: s => { done(s); s.open('set') } },
  { page: 'main', name: 'defs', setup: s => { done(s); s.open('set'); s.toDefs() } },
  { page: 'main', name: 'phed', setup: s => { done(s); s.open('set'); s.toPhed() } },
  { page: 'main', name: 'phed-end', setup: s => { done(s); s.open('set'); s.toPhed() }, scroll: big },
  { page: 'main', name: 'lib', setup: s => { done(s); s.open('set'); s.toPhed(); s.toLib() } },
  { page: 'kb', name: 'kb-empty', m: 'note', only: ['round', 'pro'] },
  { page: 'kb', name: 'kb-pinyin', m: 'note', only: ['round', 'pro'], setup: s => T(s, 'mingtian') },
  { page: 'kb', name: 'kb-text', m: 'note', only: ['round', 'pro'], setup: s => { T(s, 'mingtian'); s.pickC(0); T(s, 'kaihui') } },
  { page: 'kb', name: 'kb-en', m: 'note', only: ['round', 'pro'], setup: s => { s.lang(); s.shift(); T(s, 'Hi') } },
  { page: 'kb', name: 'kb-sym', m: 'note', only: ['round', 'pro'], setup: s => { T(s, 'b'); s.pickC(0); s.sym() } },
  { page: 'kb', name: 'kb-phrase', m: 'ph', only: ['round', 'pro'], setup: s => { T(s, 'heshui') } }
]
