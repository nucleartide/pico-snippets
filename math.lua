function round(n)
	return flr(n+0.5)
end

function lerp(a, b, t)
	return (1-t)*a + t*b
end

function damp(a, b, rem)
	return lerp(a, b, 1-rem^.0167)
end
