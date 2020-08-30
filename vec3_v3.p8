vec3 = {}
vec3.__index = vec3

function vec3_new(x, y, z)
	return setmetatable({
		x = x or 0,
		y = y or 0,
		z = z or 0,
	}, vec3)
end

function vec3.zero(v)
	v.x, v.y, v.z = 0, 0, 0
	return v
end

function vec3.mul(v, c)
	v.x *= c
	v.y *= c
	v.z *= c
	return v
end

function vec3.assign(a, b)
	a.x = b.x
	a.y = b.y
	a.z = b.z
	return a
end

function vec3.add(a, b)
	a.x += b.x
	a.y += b.y
	a.z += b.z
	return a
end

function vec3.sub(a, b)
	a.x -= b.x
	a.y -= b.y
	a.z -= b.z
	return a
end
