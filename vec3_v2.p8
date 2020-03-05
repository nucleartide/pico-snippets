pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

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
