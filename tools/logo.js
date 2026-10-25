// 应用图标 192×192：PrimaryContainer 圆底 + Material Symbols sticky_note_2（OnPrimaryContainer）。输出 assets/logo.png
const {chromium}=require('playwright-core'),fs=require('fs'),path=require('path');const {C}=require('vela-wear-m3/tools/tokens.js');
(async()=>{const b=await chromium.launch({executablePath:process.env.CHROME_PATH||'/usr/bin/google-chrome'});const pg=await b.newPage();
let s=fs.readFileSync(path.join(__dirname,'icons/sticky_note_2.svg'),'utf8').replace(/height="24(px)?"/,'height="112"').replace(/width="24(px)?"/,'width="112"').replace(/<path /g,`<path fill="${C.onPrimaryContainer}" `);
await pg.setViewportSize({width:192,height:192});
await pg.setContent(`<html><body style="margin:0;background:transparent"><div style="width:192px;height:192px;border-radius:96px;background:${C.primaryContainer};display:flex;align-items:center;justify-content:center">${s}</div></body></html>`);
await pg.screenshot({path:path.join(__dirname,'../assets/logo.png'),omitBackground:true});await b.close();})();
