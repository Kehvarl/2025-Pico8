pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
function _init()
ts={}
m={x=10,y=10,c="😐",co=7}
e={}
for i=1,2do
 add(e,{x=rnd(15),y=rnd(15),
 tx=rnd(15),ty=rnd(15),
 c="🐱",co=rnd(3)+2,stay=0,
 t=0})
end
for i=1,2do
 add(ts,{x=rnd(15),y=rnd(15),
 c="⬇️",co=rnd(3)+2,stay=0,
 v=1})
end
for i=1,2do
 add(ts,{x=rnd(15),y=rnd(15),
 c="⧗",co=rnd(3)+2,stay=0,
 v=2})
end
end
function _update()
update_m()
foreach(e,update_e)
end
function update_e(en)
if en.stay > 0 then
 en.stay -= 1
else
 local dx = en.x - m.x
 local dy = en.y - m.y
 local d2 = dx*dx + dy*dy
 if d2 < 4 then
  local dx = en.x - m.x
  local dy = en.y - m.y
  local mag = max(0.001, sqrt(dx*dx+dy*dy))
  dx /= mag
  dy /= mag
  en.tx = mid(0,15, en.x+dx*6+rnd(4)-2)
  en.ty = mid(0,15, en.y+dy*6+rnd(4)-2) 
 else
 if en.t < 3 then 
 	--
 end 
 end
 if not en.tx or (abs(en.x-en.tx)<0.5 and abs(en.y-en.ty)<0.5) then
 	en.tx=rnd(15)
 	en.ty=rnd(15)
 end 
 local vx,vy = en.tx-en.x, en.ty-en.y
 local mag = max(0.001, sqrt(vx*vx+vy*vy))
 en.x += vx/mag
 en.y += vy/mag 
 en.stay = 5
end
en.x=mid(0,en.x,15)
en.y=mid(0,en.y,15)
end
function update_m()
if btn(0) then m.x -= 1 end
if btn(1) then m.x += 1 end
if btn(2) then m.y -= 1 end
if btn(3) then m.y += 1 end
m.x=mid(0,m.x,15)
m.y=mid(0,m.y,15)
end
function _draw()
cls()
for y=0,20 do
for x=0,15 do
 print("░",x*9,y*6,1)
end
end
print(m.c,m.x*8,m.y*8,m.co)
for en in all(e)do
 print(en.c,en.x*8,en.y*8,en.co)
end
for t in all(ts)do
 print(t.c,t.x*8,t.y*8,t.co)
end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
