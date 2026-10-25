// v2: app-specific Material Symbols Rounded (Apache-2.0) icons per device -> assets/<dev>/ (PNG, fixed M3 colour roles;
// Vela <image> cannot tint). Sizes: app = CardDefaults.AppImageSize 18dp (16 on bands), sec = icon inside the coloured
// circle (20dp round, 16dp else), 24 = ButtonDefaults.IconSize, 26 = SwipeToReveal IconSize. Quantised to PNG8 afterwards (quant8.py).
const {chromium}=require('playwright-core'),fs=require('fs'),path=require('path');
const {C}=require('vela-wear-m3/tools/tokens.js');const D=require('vela-wear-m3/tools/devices.json');
const L=[ // file, svg, role, dp
 ['a_park','local_parking','tertiaryDim','app'],['a_pkg','package_2','secondaryDim','app'],['a_lock','inventory_2','primaryDim','app'],
 ['a_call','call','primaryDim','app'],['a_cart','shopping_cart','primaryDim','app'],['a_key','key','primaryDim','app'],['a_med','medication','primaryDim','app'],
 ['a_note','edit_note','primaryDim','app'],['a_edit','edit','secondaryDim','app'],['a_tut','lightbulb','tertiaryDim','app'],
 ['a_pin','push_pin_fill','primary','pin'],
 ['c_park','local_parking','onTertiary','sec'],['c_pkg','package_2','onSecondary','sec'],['c_lock','inventory_2','onPrimary','sec'],['c_edit','keyboard','onSecondary','sec'],
 ['c_tut','lightbulb','onTertiary','sec'],['c_note','edit_note','onPrimary','sec'],
 ['i_call','call','primary',24],['i_cart','shopping_cart','primary',24],['i_key','key','primary',24],['i_med','medication','primary',24],['i_note','edit_note','primary',24],
 ['i_more','more_time','primary',24],['i_timer','timer','primary',24],['i_pinf','push_pin_fill','primary',24],['i_pin','push_pin','primary',24],
 ['i_sweep','delete_sweep','primary',24],['i_bksp','backspace','primary',24],['i_check','check','onPrimary',24],
 ['i_set','settings','primary',24],['i_up','arrow_upward','primary',24],['i_close','close','primary',24],['i_add','add','primary',24],
 ['i_lib','format_quote','primary',24],['i_help','lightbulb','primary',24],['i_fav','favorite','onSurfaceVariant',24],['i_info','description','primary',24],
 ['i_kb','keyboard','primary',24],['i_hist','history','primary',24],
 ['s_del','delete','onError','act'],['s_pin','push_pin','onSurface','act'],['u_undo','undo','onSurface',24],
 ['e_note','sticky_note_2','onSurfaceVariant',32],
 ['o_note','sticky_note_2','onPrimaryContainer','big'],['o_add','add','onPrimary','obs'],['o_swipe','swipe_left','onSecondaryContainer','big'],['o_timer','auto_delete','onTertiaryContainer','big'],
 ['o_del','delete','onError','obs'],['o_pin','push_pin','onSurface','obs'],
 ['k_up','arrow_upward','onSecondaryContainer',16],['k_upon','arrow_upward','onPrimary',16],['k_bk','backspace','onSecondaryContainer',16],['k_ok','check','onPrimary',16]];
(async()=>{const b=await chromium.launch({executablePath:process.env.CHROME_PATH||'/usr/bin/google-chrome'});const pg=await b.newPage();
for(const[id,d]of Object.entries(D)){const dir=path.join(__dirname,'../assets',id);fs.rmSync(dir,{recursive:true,force:true});fs.mkdirSync(dir,{recursive:true});
 const pill=d.shape==='pill';
 for(const[f,svg,role,dp0]of L){const dp=dp0==='sec'?(d.shape==='circle'?20:16):dp0==='app'?(pill?16:18):dp0==='pin'?(pill?12:14):dp0==='act'?(pill?24:26):dp0==='big'?(pill?32:40):dp0==='obs'?(pill?18:20):dp0,s=Math.round(dp*d.k);
  let src=fs.readFileSync(path.join(__dirname,'icons',svg+'.svg'),'utf8');if(!/viewBox/.test(src))src=src.replace('<svg ','<svg viewBox="0 0 24 24" ');
  src=src.replace(/height="24(px)?"/,`height="${s}"`).replace(/width="24(px)?"/,`width="${s}"`).replace(/<path /g,`<path fill="${C[role]}" `);
  await pg.setViewportSize({width:s,height:s});await pg.setContent(`<html><body style="margin:0;background:transparent">${src.replace('<svg ','<svg style="display:block" ')}</body></html>`);
  await pg.screenshot({path:path.join(dir,f+'.png'),omitBackground:true,clip:{x:0,y:0,width:s,height:s}});}
 console.log('icons',id);}
await b.close();})();
