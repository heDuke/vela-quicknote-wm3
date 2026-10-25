# 四机型拼图：python3 tools/compose.py <shots目录> <输出目录> case1 case2 ...（每个 case 一张：round / pro / band10 / band9 横排）
import sys, os
from PIL import Image, ImageDraw, ImageFont
src, out = sys.argv[1], sys.argv[2]; os.makedirs(out, exist_ok=True)
F = '/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc'
try: font = ImageFont.truetype(F, 22)
except Exception: font = ImageFont.load_default()
for case in sys.argv[3:]:
    ims = [(d, os.path.join(src, f'{d}_{case}.png')) for d in ('round', 'pro', 'band10', 'band9')]
    ims = [(d, Image.open(p).convert('RGB')) for d, p in ims if os.path.exists(p)]
    if not ims: continue
    H = max(i.size[1] for _, i in ims) + 40; W = sum(i.size[0] for _, i in ims) + 30 * (len(ims) + 1)
    c = Image.new('RGB', (W, H), (28, 27, 31)); dr = ImageDraw.Draw(c); x = 30
    for d, im in ims:
        dr.text((x, 6), d, fill=(200, 200, 200), font=font); c.paste(im, (x, 36)); x += im.size[0] + 30
    c.save(os.path.join(out, case + '.png')); print(case, c.size)
