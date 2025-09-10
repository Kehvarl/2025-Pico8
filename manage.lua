function _init()

end

function drop_treat(type)
end

function in_meeting(x, y)
end


function update_manager()
  if btn(0) then manager.x = manager.x - 1 end
  if btn(1) then manager.x = manager.x + 1 end
  if btn(2) then manager.y = manager.y - 1 end
  if btn(3) then manager.y = manager.y + manager.speed end
  if btnp(4) then drop_treat(0) end
  if btnp(5) then drop_treat(1) end

  manager.x = mid(2, manager.x, 126)
  manager.y = mid(2, manager.y, 126)
end

function update_treats()
  for t in all(treats) do
    t.ttl = t.ttl - 1
    if t.ttl <= 0 then del(treats, t) end
  end
end

function update_engineers()
  for e in all(engineers) do
    if e.state == "at_table" then
      e.stay = e.stay - 1
      if e.stay <= 0 then
        e.state = "wander"
      end
    else
      e.vx = e.vx + rnd(0.2) - 0.1
      e.vy = e.vy + rnd(0.2) - 0.1

      local dx = e.x - manager.x
      local dy = e.y - manager.y
      local d2 = dx*dx + dy*dy
      if d2 < 200 then
        e.vx = e.vx + dx*0.05
        e.vy = e.vy + dy*0.05
      end

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
            if td2 < 16 then
              e.h = bor(e.h, shl(1, t.t))
              del(treats, t)
            end
          end
        end
      end

      e.vx = e.vx * 0.9
      e.vy = e.vy * 0.9
      e.x = mid(3, e.x + e.vx, 125)
      e.y = mid(3, e.y + e.vy, 125)

      if in_meeting(e.x, e.y) then
        e.state = "at_table"
        e.stay = 60 + flr(rnd(60))
      end
    end
  end
end

function check_meeting()
  for e in all(engineers) do
    if not in_meeting(e.x, e.y) then
      meeting = 0
      return
    end
  end
  if not in_meeting(manager.x, manager.y) then
    meeting = 0
    return
  end
  meeting = meeting + 1
end

function _update60()
  update_manager()
  update_treats()
  update_engineers()
  check_meeting()
end

function _draw()
  cls(1)

  rect(meeting.x - meeting.w/2, meeting.y - meeting.h/2,
       meeting.x + meeting.w/2, meeting.y + meeting.h/2, 5)

  print("drive devs into meeting! z=energy x=pizza", 2, 2, 7)

  for t in all(treats) do
    local c = t.t == 0 and 11 or 8
    circfill(t.x, t.y, 2, c)
  end

  circfill(manager.x, manager.y, 3, 12)

  for e in all(engineers) do
			local col
			if e.h == 0 then col = 2
			elseif e.h == 1 then col = 11
			elseif e.h == 2 then col = 8
			else col = 10
			end
			circfill(e.x, e.y, 3, col)
  end

  if win > 60 then
    rectfill(20, 56, 108, 72, 0)
    print("meeting time!", 40, 60, 7)
  end
end
