pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

--
-- note: box requires vec3 to work.
--

vec3 = {}
vec3.__index = vec3

function vec3.new(o)
  return setmetatable({
    x = o and o.x or 0,
    y = o and o.y or 0,
    z = o and o.z or 0,
  }, vec3)
end

function vec3.add(v1, v2)
  return vec3.new {
    x = v1.x + v2.x,
    y = v1.y + v2.y,
    z = v1.z + v2.z,
  }
end

function vec3.scale(state, c)
  return vec3.new {
    x = state.x * c,
    y = state.y * c,
    z = state.z * c,
  }
end

--
-- box definition.
--

box = {}
box.__index = box

function box.new(o)
  return setmetatable({
    top_left = vec3.new {
      x = o.tlx,
      y = o.tly,
    },
    bottom_right = vec3.new {
      x = o.brx,
      y = o.bry,
    },
  }, box)
end

-- add two boxes together.
-- note: you likely want box:collides() instead.
function box.minkowski_sum(a, b)
  local c = box.new()
  c.top_left = a.top_left:add(b.top_left)
  c.bottom_right = a.bottom_right:add(b.bottom_right)
  return new
end

-- negate a box.
-- note: you likely want box:collides() instead.
function box.negate(state)
  local neg = box.new()
  neg.top_left = state.bottom_right:scale(-1)
  neg.bottom_right = state.top_left:scale(-1)
  return neg
end

-- subtract a shape from a shape.
-- used to determine whether two boxes intersect.
-- note: you likely want box:collides() instead.
function box.minkowski_difference(a, b)
  return a:minkowski_sum(b:negate())
end

function box.collides(a, b)
  -- compute the minkowski difference.
  local diff = a:minkowski_difference(b)

  -- check if bound a and bound b are colliding.
  return diff.top_left.x <= 0 and
    diff.top_left.y <= 0 and
    diff.bottom_right.x >= 0 and
    diff.bottom_right.y >= 0, diff
end
