# PNG8 (palette + alpha) quantisation of app icons, like vela-wear-m3 tools/quant.py
import sys,glob,os
from PIL import Image
tot0=tot1=0
for f in glob.glob(sys.argv[1]+'/*/*.png'):
    a=os.path.getsize(f);im=Image.open(f).convert('RGBA')
    q=im.quantize(colors=32,method=Image.Quantize.FASTOCTREE)
    q.save(f,optimize=True);b=os.path.getsize(f);tot0+=a;tot1+=b
print('icons',tot0,'->',tot1)
