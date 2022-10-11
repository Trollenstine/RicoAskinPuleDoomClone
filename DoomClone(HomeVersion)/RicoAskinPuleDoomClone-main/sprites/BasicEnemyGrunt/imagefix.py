from PIL import Image
import os
import math
image_list = []
print(os.listdir('H:\Godot\RicoAskinPuleDoomClone\sprites\BasicEnemyGrunt'))
for f in os.listdir("H:\Godot\RicoAskinPuleDoomClone\sprites\BasicEnemyGrunt"):
    try:
        im = Image.open(f)
        image_list.append(im)
    except:
        print(f,"not image")

max_w = 0
max_h = 0

for i in image_list:
    if i.size[0] > max_w:
        max_w = i.size[0]
    if i.size[1] > max_h:
        max_h = i.size[1]

try:
    os.mkdir("output")
except:
    print("already exists")

for i in image_list:
    offset = (math.floor(max_w/2 - i.size[0]/2),max_h - i.size[1])
    new_image = Image.new("RGBA",(max_w,max_h),(0,0,0,0))
    new_image.paste(i,offset)
    new_image.save("./output/"+i.filename)