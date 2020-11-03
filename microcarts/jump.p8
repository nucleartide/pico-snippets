pico-8 cartridge // http://www.pico-8.com
version 27
__lua__

#include ../vec3_v3.p8

--[[

x horizontal collisions
o vertical collisions

]]

-- assert(false, 'implement vertical collision before moving on')

function _init()
	p1 = init_player()
end

function _update60()
	-- input bookkeeping.
	grab_inputs()

	-- movement.
	update_vx()
	update_vy()
	p1.pos.x += p1.vx * .0167
	p1.pos.y += p1.vy * .0167

	-- resolve collisions.
	handle_horiz_collisions()
	handle_vert_collisions()
end

function _draw()
	cls(1)

	-- draw map.
	-- map( celx, cely, sx, sy, celw, celh, [layer] )
	map(0, 0, 0, 0, 16, 16)

	-- draw entities.
	draw_player(p1)

	-- debug.
	print('p1.vx:' .. p1.vx)
	print('left:' ..
		tostr(is_colliding_horiz(p1.pos, p1.w, p1.h, 'left'))
	)
	-- note that this will be true when touching a right wall, but false when touching a left wall,
	-- because collisions are done in screen space.
	-- as such, you should use another var to track when
	-- a collision was detected, for the "touching wall" case.
	print('right:' ..
		tostr(is_colliding_horiz(p1.pos, p1.w, p1.h, 'right'))
	)

	print('top:' ..
		tostr(is_colliding_vert(p1.pos, p1.w, p1.h, 'top'))
	)

	local left, right, top, bottom = get_world_space_bounds()
	print('left:' .. left)
	print('right:' .. right)
	print('top:' .. top)

	left, right, top, bottom = get_screen_space_bounds()
	print('screentop:' .. top)
end

-->8
-- draw functions.

function draw_player(p)
	local left, right, top, bottom = get_screen_space_bounds()
	rectfill(left, top, right, bottom, 7)
end

-->8
-- init functions.

function init_player()
	return {
		-- position.
		pos = vec3_new(64, 74),

		-- horizontal velocity.
		vx = 0,
		vy = 0,

		-- width.
		w = 6,

		-- height.
		h = 10,

		-- horiz speed.
		speed = 60, -- pixels per second.
	}
end

-->8
-- update functions.

function handle_vert_collisions()
	-- handle top collision.
	local is_colliding_top, tile_y = is_colliding_vert(
		p1.pos, p1.w, p1.h, 'top'
	)
	if is_colliding_top then
		-- add half the height to the bottom of the tile.
		p1.pos.y = tile_y*8+8 +p1.h

		-- resolve player vel.
		p1.vy = 0
	end

	-- handle bottom collision.
	local is_colliding_bottom, tile_y = is_colliding_vert(
		p1.pos, p1.w, p1.h, 'bottom'
	)
	if is_colliding_bottom then
		-- resolve position.
		p1.pos.y = tile_y*8

		-- resolve vel.
		p1.vy = 0
	end
end

function handle_horiz_collisions()
	-- handle left collision.
	local is_colliding_left, tile_x = is_colliding_horiz(
		p1.pos, p1.w, p1.h, 'left'
	)
	if is_colliding_left then
		-- add half the width to the right of the tile.
		p1.pos.x = tile_x*8 +8 +flr(p1.w/2)

		-- resolve player vel.
		p1.vx = 0
	end

	-- handle right collision.
	local is_colliding_right, tile_x = is_colliding_horiz(
		p1.pos, p1.w, p1.h, 'right'
	)
	if is_colliding_right then
		-- add half the width to the left of the tile.
		p1.pos.x = tile_x*8 - ceil(p1.w/2)

		-- resolve player vel.
		p1.vx = 0
	end
end

function is_colliding_vert(pos, w, h, side)
	-- get the bounds of the char.
	local left, right, top, bottom, cx, cy = get_world_space_bounds()
	local y
	if side=='top' then
		y = top
	elseif side=='bottom' then
		y = bottom
	else
		assert(false)
	end

	-- determine the value of is_colliding by sweeping.
	local incr = w/3
	local is_colliding = false
	local tile_y
	for i=-1,1 do
		-- get x test value.
		local x = cx + i*incr

		-- get sprite number in map space.
		local sprite_num = mget(x/8, y/8)

		-- get flags.
		local is_wall = fget(sprite_num, 0)

		-- if tile is a wall, there is a collision.
		if is_wall then
			is_colliding = true
			tile_y = flr(y/8)
		end
	end

	return is_colliding, tile_y
end

-- given the pos, w, and h of an entity,
-- determine if the entity is colliding with walls.
-- side can be 'left' or 'right'.
function is_colliding_horiz(pos, w, h, side)
	-- get the bounds of the char.
	local left, right, top, bottom, cx, cy = get_world_space_bounds()
	local x
	if side=='left' then
		x = left
	elseif side=='right' then
		x = right
	else
		assert(false)
	end

	-- determine the value of is_colliding by sweeping.
	local incr = h/3
	local is_colliding = false
	local tile_x
	for i=-1,1 do
		-- get y test value.
		local y = cy + i*incr

		-- get sprite number in map space.
		local sprite_num = mget((x)/8, y/8)

		-- get flags.
		local is_wall = fget(sprite_num, 0)

		-- if tile is a wall, there is a collision.
		if is_wall then
			is_colliding = true
			tile_x = flr(x/8)
			break
		end
	end

	return is_colliding, tile_x
end

function update_vx()
	local desired_vx = 0
	if i_left then desired_vx -= p1.speed end
	if i_right then desired_vx += p1.speed end
	p1.vx = damp(p1.vx, desired_vx, .01)
end

function update_vy()
	local desired_vy = 0
	if i_up then desired_vy -= p1.speed end
	if i_down then desired_vy += p1.speed end
	p1.vy = damp(p1.vy, desired_vy, .01)
end

-->8
-- utils.

function vec3.world2screen(v)
	return v.x, v.y
end

function get_world_space_bounds()
	local left, right, top, bottom, cx, cy

	left = p1.pos.x - p1.w/2
	right = p1.pos.x + p1.w/2
	top = p1.pos.y - p1.h
	bottom = p1.pos.y
	cx = p1.pos.x
	cy = p1.pos.y - p1.h/2

	return left, right, top, bottom, cx, cy
end

function get_screen_space_bounds()
	local left, right, top, bottom, cx, cy = get_world_space_bounds()

	-- override left and right to guarantee correct width in
	-- screen space.
	left = cx - flr(p1.w/2)
	right = cx + flr(p1.w/2)
	if p1.w%2==0 then right-=1 end

	-- override top to guarantee correct height in screen space.
	-- top += 1
	bottom -= 1

	-- in the case where w=5,
	-- subtract flr(p1.w/2) from cx to get left.
	-- add flr(p1.w/2) to cx to get right.

	-- in the case where w=6,
	-- subtract flr(p1.w/2) from cx to get left.
	-- add p1.w/2-1 to cx to get right.

	return left, right, top, bottom
end

-- get the bounds of a rectangular character,
-- while considering odd or even dimensions.
--
-- needed for fixing off-by-1 errors in collisions,
-- because collisions are done in screen space when using the map.
function get_bounds(pos, w, h)
	local left, right, top, bottom, cx, cy

	if w%2==0 then
		left = pos.x - w/2
		right = pos.x + w/2 - 1
		res_left = w/2
		res_right = -w/2 +1
	else
		left = pos.x - flr(w/2)
		right = pos.x + flr(w/2)
	end

	top = pos.y - h + 1
	bottom = pos.y
	cx, cy = pos.x, top + flr(h/2)

	return left, right, top, bottom, cx, cy
end
__gfx__
00000000222222220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000222222220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000222222220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000222222220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000222222220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000222222220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000222222220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000222222220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0001000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0001000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0001000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0001000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0001000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
