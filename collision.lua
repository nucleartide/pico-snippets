function init_collider(x, y, z, half_w, half_h)
	return {
		pos = vec3_new(x, y, z),
		half_w = half_w,
		half_h = half_h,
	}
end

do
	local a_tl, a_br, b_tl, b_br = vec3_new(), vec3_new(), vec3_new(), vec3_new()
	function collides(a, b)
		-- compute corners for collider a.
		a_tl.x, a_tl.y = a.pos.x-a.half_w, a.pos.y-a.half_h
		a_br.x, a_br.y = a.pos.x+a.half_w, a.pos.y+a.half_h

		-- compute corners for collider b.
		b_tl.x, b_tl.y = b.pos.x-b.half_w, b.pos.y-b.half_h
		b_br.x, b_br.y = b.pos.x+b.half_w, b.pos.y+b.half_h

		-- compute -b.
		b_tl:mul(-1) b_br:mul(-1)
		b_tl, b_br = b_br, b_tl

		-- compute a + (-b), the minkowski difference.
		a_tl:add(b_tl)
		a_br:add(b_br)

		-- collide if origin is contained within minkowski difference.
		local tlx, tly, brx, bry = a_tl.x, a_tl.y, a_br.x, a_br.y
		return tlx<0 and tly<0 and brx>0 and bry>0
	end
end
