
--
-- vec3 util.
--

vec3 = {
  __add = function(a, b)
    a.x += b.x
    a.y += b.y
    a.z += b.z
    return a
  end,

  __sub = function(a, b)
    a.x -= b.x
    a.y -= b.y
    a.z -= b.z
    return a
  end,
}

vec3.__index = vec3

function vec3.new(x, y, z)
  return setmetatable({
    x = x,
    y = y,
    z = z,
  }, vec3)
end

function vec3:magnitude()
  return sqrt(self.x^2 + self.y^2 + self.z^2)
end

function vec3:normalize()
  local m = self:magnitude()
  if m == 0 then return end
  self.x /= m
  self.y /= m
  self.z /= m
  return self
end

function vec3:tostr()
  return self.x .. ',' .. self.y .. ',' .. self.z
end

function vec3.cross(a, b)
  local ax, ay, az = a.x, a.y, a.z
  a.x = ay*b.z - az*b.y
  a.y = az*b.x - ax*b.z
  a.z = ax*b.y - ay*b.x
  return a
end
