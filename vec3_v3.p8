vec3 = {}
vec3.__index = vec3

function vec3_new(x, y, z)
	return setmetatable({
		x = x or 0,
		y = y or 0,
		z = z or 0,
	}, vec3)
end
