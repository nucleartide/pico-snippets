pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

#include ../vec3_v3.p8

function _init()
	p1 = init_player()
end

function _update60()
	grab_inputs()
	update_vx()
	move_horizontally()
end

function _draw()
	cls(1)

	-- draw entities.
	draw_player(p1)

	-- debug.
	print('p1.vx:' .. p1.vx)
end

-->8
-- draw functions.

function draw_player(p)
	local sx, sy = p.pos:world2screen()
	local top = sy - p.h
	local bottom = sy
	local left = sx - p.w/2
	local right = sx + p.w/2
	rectfill(round(left), round(top), round(right), round(bottom), 7)
end

-->8
-- init functions.

function init_player()
	return {
		-- position.
		pos = vec3_new(64, 74),

		-- horizontal velocity.
		vx = 0,

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

function update_vx()
	local desired_vx = 0
	if i_left then desired_vx -= p1.speed end
	if i_right then desired_vx += p1.speed end
	p1.vx = damp(p1.vx, desired_vx, .01)
end

function move_horizontally()
	p1.pos.x += p1.vx * .0167
end

-->8
-- utils.

function vec3.world2screen(v)
	return v.x, v.y
end
