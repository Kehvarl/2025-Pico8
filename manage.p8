pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
-- cat-herding engineers, expanded readable version

function _init()
  -- manager
  manager = {x=64, y=64, speed=1.5}

  -- engineers
  engineers = {}
  for i=1,8 do
    add(engineers, {
      x = rnd(128),
      y = rnd(128),
      vx = 0,
      vy = 0,
      h = 0,           -- treat inventory: bit 0=energy, bit1=pizza
      state = "wander",
      stay = 0
    })
  end

  -- treats
  treats = {}

  -- meeting square
  meeting = {x=64, y=64, w=20, h=20}

  -- win counter
  win = 0
end

-- drop a treat at manager's position
function drop_treat(type)
  add(treats, {x=manager.x, y=manager.y, t=type, ttl=360})
end

-- check if a position is inside meeting square
function in_meeting(x, y)
  return abs(x - meeting.x) < meeting.w/2 and abs(y - meeting.y) < meeting.h/2
end

-- update manager movement and drop treats
function update_manager()
  if btn(0) then manager.x = manager.x - manager.speed end
  if btn(1) then manager.x = manager.x + manager.speed end
  if btn(2) then manager.y = manager.y - manager.speed end
  if btn(3) then manager.y = manager.y + manager.speed end
  if btnp(4) then drop_treat(0) end -- z: energy
  if btnp(5) then drop_treat(1) end -- x: pizza

  -- clamp to screen
  manager.x = mid(2, manager.x, 126)
  manager.y = mid(2, manager.y, 126)
end

-- update treats
function update_treats()
  for t in all(treats) do
    t.ttl = t.ttl - 1
    if t.ttl <= 0 then del(treats, t) end
  end
end

-- engineer behavior
function update_engineers()
  for e in all(engineers) do
    if e.state == "at_table" then
      -- countdown when at table
      e.stay = e.stay - 1
      if e.stay <= 0 then
        e.state = "wander"
      end
    else
      -- wandering drift
      e.vx = e.vx + rnd(0.2) - 0.1
      e.vy = e.vy + rnd(0.2) - 0.1

      -- avoid manager
      local dx = e.x - manager.x
      local dy = e.y - manager.y
      local d2 = dx*dx + dy*dy
      if d2 < 200 then
        e.vx = e.vx + dx*0.05
        e.vy = e.vy + dy*0.05
      end

      -- lure toward nearby treats (if missing)
      if e.h ~= 3 then
        for t in all(treats) do
          if band(e.h, shl(1, t.t)) == 0 then
            local tx = t.x - e.x
            local ty = t.y - e.y
            local td2 = tx*tx + ty*ty
            if td2 < 1600 then
              e.vx = e.vx + tx*0.05
              e.vy = e.vy + ty*0.05
            end
            -- pick up treat if close
            if td2 < 16 then
              e.h = bor(e.h, shl(1, t.t))
              del(treats, t)
            end
          end
        end
      end

      -- move engineer
      e.vx = e.vx * 0.9
      e.vy = e.vy * 0.9
      e.x = mid(3, e.x + e.vx, 125)
      e.y = mid(3, e.y + e.vy, 125)

      -- enter meeting if in square
      if in_meeting(e.x, e.y) then
        e.state = "at_table"
        e.stay = 60 + flr(rnd(60)) -- stay 1ヌ█⧗2 seconds
      end
    end
  end
end

-- check if all engineers and manager are in meeting
function check_win()
  for e in all(engineers) do
    if not in_meeting(e.x, e.y) then
      win = 0
      return
    end
  end
  if not in_meeting(manager.x, manager.y) then
    win = 0
    return
  end
  win = win + 1
end

-- main update
function _update60()
  update_manager()
  update_treats()
  update_engineers()
  check_win()
end

-- draw everything
function _draw()
  cls(1)

  -- meeting square
  rect(meeting.x - meeting.w/2, meeting.y - meeting.h/2,
       meeting.x + meeting.w/2, meeting.y + meeting.h/2, 5)

  -- instructions
  print("drive devs into meeting! z=energy x=pizza", 2, 2, 7)

  -- treats
  for t in all(treats) do
    local c = t.t == 0 and 11 or 8
    circfill(t.x, t.y, 2, c)
  end

  -- manager
  circfill(manager.x, manager.y, 3, 12)

  -- engineers
  for e in all(engineers) do
			local col
			if e.h == 0 then col = 2
			elseif e.h == 1 then col = 11
			elseif e.h == 2 then col = 8
			else col = 10
			end
			circfill(e.x, e.y, 3, col)
  end

  -- win overlay
  if win > 60 then
    rectfill(20, 56, 108, 72, 0)
    print("meeting time!", 40, 60, 7)
  end
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
