// Chrome design previews of the scratch app: real generated UX (vela-wear-m3 gen) + real page ViewModel in a vm sandbox.
// Adapted from vela-wear-m3 tools/preview.js + runtime-page.js (GPL-3.0-or-later). NOT an emulator/real-device capture.
const fs=require('fs'),path=require('path'),http=require('http'),vm=require('vm'),{spawnSync}=require('child_process');
const {chromium}=require('playwright-core');const ROOT=path.resolve(__dirname,'..');
const devices=require('vela-wear-m3/tools/devices.json');const OUT=process.env.OUT||path.join(ROOT,'shots');
const NOW=Date.parse('2026-10-25T10:08:00+08:00');
const cases=require('./cases.js');
function strip(src){return src.replace(/^import .*$/gm,'').replace(/^export \{.*\}\s*$/gm,'').replace(/^export (default )?/gm,'')}
function load(page,db,m){
 const source=fs.readFileSync(path.join(ROOT,'src/pages',page,page+'.ux'),'utf8');
 const libs=['m3.js','qn.js','store.js','gate.js'].concat(page==='kb'?['ime/dicUtil.js','ime/dictionaryLoader.js']:[]);
 const common=libs.map(f=>strip(fs.readFileSync(path.join(ROOT,'src/common',f),'utf8'))).join('\n');
 const script=source.match(/<script>([\s\S]*?)<\/script>/)[1].replace(/^import .*$/gm,'').replace('export default','const definition =');
 let now=NOW,next=0,timers=new Map();
 const schedule=(fn,delay,repeat)=>{const id=++next;timers.set(id,{fn,due:now+delay,repeat});return id};
 class ClockDate extends Date{constructor(...a){a.length?super(...a):super(now)}static now(){return now}}
 const ctx={console,Date:ClockDate,JSON,Math,router:{back(){},push(){}},prompt:{showToast(){}},vibrator:{vibrate(){}},storage:{get(o){o.success(db[o.key])},set(o){db[o.key]=o.value;if(o.success)o.success()},delete(o){delete db[o.key];if(o.success)o.success()}},
  file:{readText(o){o.success({text:fs.readFileSync(path.join(ROOT,'src',o.uri),'utf8')})}},
  setTimeout:(fn,ms)=>schedule(fn,ms||0,0),clearTimeout:id=>timers.delete(id),setInterval:(fn,ms)=>schedule(fn,ms,ms),clearInterval:id=>timers.delete(id)};
 const def=vm.runInNewContext(common+'\n'+script+'\ndefinition',ctx);const state=Object.assign({},def.protected||{},def.private||def.data||{},m?{m}:{});
 Object.keys(def).forEach(k=>{if(typeof def[k]==='function')state[k]=def[k].bind(state)});state.$element=()=>null;
 const advance=ms=>{const target=now+ms;let g=0;while(++g<10000){let e=null,id=null;for(const[k,t]of timers)if(t.due<=target&&(!e||t.due<e.due)){id=k;e=t}
  if(!e)break;now=e.due;if(e.repeat)e.due+=e.repeat;else timers.delete(id);e.fn();}now=target};
 if(state.onInit)state.onInit();return {state,source,advance};
}
async function main(){
 const only=(process.argv[2]||'').split(',').filter(Boolean);
 fs.mkdirSync(OUT,{recursive:true});
 const server=http.createServer((req,res)=>{let t;
  if(req.url.startsWith('/common/'))t=path.join(ROOT,'src',decodeURIComponent(req.url));else if(req.url==='/font.ttf')t=path.join(require('os').homedir(),'.vela/sdk/qa/font/MiSansW_Normal.ttf');
  if(!t||!fs.existsSync(t)){res.statusCode=req.url==='/'?200:404;return res.end(req.url==='/'?'<html></html>':'')}
  res.setHeader('Content-Type',t.endsWith('.png')?'image/png':'font/ttf');fs.createReadStream(t).pipe(res)});
 await new Promise(r=>server.listen(0,'127.0.0.1',r));const port=server.address().port;
 const browser=await chromium.launch({executablePath:process.env.CHROME_PATH||'/usr/bin/google-chrome'});
 try{for(const[id,d]of Object.entries(devices)){
  const r=spawnSync(process.execPath,[require.resolve('vela-wear-m3/bin/vela-wear-m3.js'),'gen','--input','template','--out','src','--device',id,'--animation','basic','--replace'],{cwd:ROOT,encoding:'utf8'});if(r.status)throw new Error(r.stderr);
  fs.cpSync(path.join(ROOT,'assets',id),path.join(ROOT,'src/common/ic'),{recursive:true});
  if(d.shape!=='pill'){fs.mkdirSync(path.join(ROOT,'src/common/ime/dict'),{recursive:true});for(const f of fs.readdirSync(path.join(ROOT,'vendor/ime/dict')))fs.copyFileSync(path.join(ROOT,'vendor/ime/dict',f),path.join(ROOT,'src/common/ime/dict',f));for(const f of fs.readdirSync(path.join(ROOT,'vendor/ime/js')))fs.copyFileSync(path.join(ROOT,'vendor/ime/js',f),path.join(ROOT,'src/common/ime',f.replace(/\.in$/,'')))}
  const page=await browser.newPage({viewport:{width:d.W,height:d.H},deviceScaleFactor:1});
  for(const c of cases){if(only.length&&!only.includes(c.name))continue;
   if(c.only&&!c.only.includes(id))continue;
   const db=JSON.parse(JSON.stringify(c.db||{}));const model=load(c.page,db,c.m);if(c.pre)c.pre(model.state);if(model.state.onShow)model.state.onShow();if(c.setup)c.setup(model.state,d);model.advance(c.elapsed||1);
   let scrollPos=c.scroll?c.scroll(d):0;
   if(model.state.onScroll)model.state.onScroll({scrollY:scrollPos});model.advance(60);
   const state=JSON.parse(JSON.stringify(model.state));if(model.state.onHide)model.state.onHide();
   const template=model.source.match(/<template>([\s\S]*?)<\/template>/)[1].replace(/<!--[\s\S]*?-->/g,'');
   const css=model.source.match(/<style>([\s\S]*?)<\/style>/)[1];const pk={sfs:(css.match(/selected-font-size:\s*(\d+)px/)||[])[1],sc:(css.match(/selected-color:\s*(#\w+)/)||[])[1]};
   await page.goto('http://127.0.0.1:'+port+'/');
   await page.setContent('<html><head><style>@font-face{font-family:Vela;src:url(http://127.0.0.1:'+port+'/font.ttf)}*{box-sizing:border-box;border-style:solid;border-width:0;flex-shrink:1}html,body{margin:0;background:#000;color:#fff;font-family:Vela,sans-serif}div,list,list-item,stack{display:flex;position:relative}list-item{flex-shrink:0}image,img{flex-shrink:0}list{overflow-y:auto;scrollbar-width:none}text{display:block;white-space:pre-wrap;overflow:hidden}image{display:block}stack{display:grid}stack>*{grid-area:1/1}'+css.replace(/lines:\s*(\d+);/g,'-webkit-line-clamp:$1;display:-webkit-box;-webkit-box-orient:vertical;')+'</style></head><body><template id="ux">'+template+'</template><main id="screen"></main></body></html>');
   await page.evaluate(({state,d,scrollPos,pk})=>{
    const evalExpr=(exp,vars)=>Function('s','v','with(s){with(v){return ('+exp+')}}')(state,vars);
    const interp=(v,vars)=>v.replace(/\{\{([\s\S]*?)\}\}/g,(_,e)=>{const x=evalExpr(e,vars);return x==null?'':typeof x==='object'?JSON.stringify(x):String(x)});
    function node(el,vars={}){
     if(el.nodeType===3)return document.createTextNode(interp(el.textContent,vars).replace(/^\s+$/,''));
     if(el.nodeType!==1)return document.createTextNode('');
     if(el.hasAttribute('for')){const items=evalExpr(el.getAttribute('for').replace(/^\{\{|\}\}$/g,''),vars),f=document.createDocumentFragment();
      items.forEach((it,i)=>{const c=el.cloneNode(true);c.removeAttribute('for');f.append(node(c,{...vars,$item:it,$idx:i}))});return f}
     if(el.hasAttribute('if')&&!evalExpr(el.getAttribute('if').replace(/^\{\{|\}\}$/g,''),vars))return document.createTextNode('');
     const tag=el.tagName.toLowerCase();
     if(tag==='picker'){const range=evalExpr(el.getAttribute('range').replace(/^\{\{|\}\}$/g,''),vars),sel=+evalExpr(el.getAttribute('selected').replace(/^\{\{|\}\}$/g,''),vars),n=+el.getAttribute('data-rows')||3;
      const box=document.createElement('div');box.className=el.getAttribute('class');box.style.flexDirection='column';
      for(let i=-(n-1)/2;i<=(n-1)/2;i++){const v=range[sel+i];const r=document.createElement('text');r.textContent=v==null?'':v;r.style.cssText='flex:1;min-height:0;line-height:1;display:flex;align-items:center;justify-content:center;width:100%;white-space:nowrap;overflow:visible'+(i===0?';color:'+pk.sc+';font-size:'+pk.sfs+'px':'');box.append(r)}return box}
     const out=document.createElement(tag==='image'?'img':tag);
     for(const a of el.attributes){if(['if','tid','for'].includes(a.name)||a.name.startsWith('on'))continue;
      if(a.name==='style'&&/^\{\{/.test(a.value)){const o=evalExpr(a.value.replace(/^\{\{|\}\}$/g,''),vars)||{};
       for(const[k,v]of Object.entries(o)){if(k==='transform'){const t=JSON.parse(v);out.style.transform=Object.entries(t).map(([kk,vv])=>kk+'('+vv+')').join(' ')}else out.style[k]=v}}
      else out.setAttribute(a.name,interp(a.value,vars))}
     for(const ch of el.childNodes)out.append(node(ch,vars));return out}
    const main=document.getElementById('screen');main.style.cssText='width:'+d.W+'px;height:'+d.H+'px;overflow:hidden;position:relative;border-radius:'+(d.shape==='circle'?'50%':d.shape==='pill'?d.W/2+'px':'24px');
    main.append(node(document.getElementById('ux').content.firstElementChild));
    for(const el of document.querySelectorAll('*')){const m=el.classList.contains('ovl-in')||el.classList.contains('cf-blob')||el.classList.contains('cf-txt')||el.classList.contains('cf-check-in');
     if(m){for(const an of el.getAnimations()){an.pause();an.currentTime=10000}}else{el.style.animation='none';el.style.transition='none'}}
    const l=document.querySelector('list');if(l&&scrollPos)l.scrollTop=scrollPos;
   },{state,d,scrollPos,pk});
   await page.evaluate(()=>document.fonts.ready);await page.waitForTimeout(50);
   await page.screenshot({path:path.join(OUT,id+'_'+c.name+'.png')});
   const issues=await page.evaluate(()=>{const o=[];for(const t of document.querySelectorAll('text')){if(t.scrollWidth>t.clientWidth+1||t.scrollHeight>t.clientHeight+1)o.push('overflow:'+t.textContent.slice(0,20)+' '+t.scrollWidth+'x'+t.scrollHeight+'>'+t.clientWidth+'x'+t.clientHeight)}return o});
   console.log(id,c.name,issues.length?issues.join(' | '):'ok');
  }
  await page.close();
 }}finally{await browser.close();server.close()}
}
main().catch(e=>{console.error(e);process.exitCode=1});
