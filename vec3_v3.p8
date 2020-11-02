function round(n)
	return flr(n+0.5)
end

function lerp(a, b, t)
	return (1-t)*a + t*b
end

function damp(a, b, rem)
	return lerp(a, b, 1-rem^.0167)
end

function rotate(x,y,angle)
	local nx=x*cos(angle)+y*sin(angle)
	local ny=-x*sin(angle)+y*cos(angle)
	return nx,ny
end

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

function vec3.tostr(v)
	return v.x .. ',' .. v.y .. ',' .. v.z
end

function vec3.debug(v)
	print(v:tostr())
end

function vec3.damp(a, b, rem)
	a.x, a.y, a.z = damp(a.x, b.x, rem), damp(a.y, b.y, rem), damp(a.z, b.z, rem)
	return a
end

function vec3.dupe(v)
	return vec3_new(v.x, v.y, v.z)
end

function vec3.round(v)
	v.x = flr(v.x+.5)
	v.y = flr(v.y+.5)
	v.z = flr(v.z+.5)
	return v
end

function vec3.normalize(v)
	local d = v:mag()
	if d==0 then return v end
	v.x /= d
	v.y /= d
	v.z /= d
	return v
end

function vec3.mag(a)
	return a:dist_between(vec3_new())
end

function vec3.dist_between(a, b)
	-- scale inputs down by 6 bits
	local dx=(a.x-b.x)/64
	local dy=(a.y-b.y)/64
	local dz=(a.z-b.z)/64

	-- get distance squared
	local dsq=dx*dx + dy*dy + dz*dz

	-- in case of overflow/wrap
	if(dsq<0) then return 32767.99999 end

	-- scale output back up by 6 bits
	return sqrt(dsq)*64
end

function vec3.rotate(v, angle)
	v.x, v.y = rotate(v.x, v.y, angle)
	return v
end
