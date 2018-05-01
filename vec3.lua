
--
-- vec3.
--

vec3 = {}
vec3.__index = vec3

function vec3.new(x, y, z)
  return setmetatable({
    x = x,
    y = y,
    z = z,
  }, vec3)
end

function vec3:magnitude()
  return sqrt(self.x^2 + self.y^2)
end

function vec3:normalize()
  local m = self:magnitude()
  self.x /= m
  self.y /= m
  self.z /= m
end

function vec3:debug()
  return self.x .. ',' .. self.y .. ',' .. self.z
end
