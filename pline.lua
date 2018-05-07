
--
-- line() with perspective projection.
--
-- call with a camera position `vec3` to create a `line` function.
--

function pline(c)
  local function project(x, y, z)
    -- world space to camera space.
    x, y, z = x-c.x, y-c.y, z-c.z

    -- camera space to screen space.
    x, y = -x/z, -y/z

    -- screen space to raster space.
    x, y = x*64+64, -y*64+64

    return flr(x), flr(y)
  end

  return function(p1, p2, col)
    -- ignore if both points are in front of near plane.
    if p1.z > (c.z-1) and p2.z > (c.z-1) then return end

    -- final line points.
    local x1, y1, x2, y2

    -- if p1 is in front of near plane,
    if p1.z > (c.z-1) then
      -- find the point of intersection and update p1.

      -- update x.
      local m = (p1.x - p2.x) / (p1.z - p2.z)
      local x = m*(c.z-1) + p2.x

      -- update y.
      m = (p1.y - p2.y) / (p1.z - p2.z)
      local y = m*(c.z-1) + p2.y

      -- update z.
      local z = c.z-1

      x1, y1 = project(x, y, z)
    else
      x1, y1 = project(p1.x, p1.y, p1.z)
    end

    -- if p2 is in front of near plane,
    if p2.z > (c.z-1) then
      -- find the point of intersection and update p2.

      -- update x.
      local m = (p2.x - p1.x) / (p2.z - p1.z)
      local x = m*(c.z-1) + p1.x

      -- update y.
      m = (p2.y - p1.y) / (p2.z - p1.z)
      local y = m*(c.z-1) + p1.y

      -- update z.
      local z = c.z-1

      x2, y2 = project(x, y, z)
    else
      x2, y2 = project(p2.x, p2.y, p2.z)
    end

    line(x1, y1, x2, y2, col)
  end
end
