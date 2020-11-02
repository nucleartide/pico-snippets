pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

#include ../vec3_v3.p8
#include ../math.lua

function _init()
	p1 = init_player()
end

function _update60()
	grab_inputs()
	update_desired_vel(p1)
	apply_move(p1)
end

function _draw()
	cls(1)
	draw_player(p1)
end

-->8
-- draw functions.
-- follows "diu" method: https://teamavocado.co/just-diu-it/

function draw_player(p)
	local sx, sy = p.pos:world2screen()
	local top = round(sy - p.h)
	local bottom = round(sy)
	local left = round(sx - p.w/2)
	local right = round(sx + p.w/2)
	rectfill(left, top, right, bottom, 7)
end

-->8
-- init functions.

function init_player()
	return {
		pos = vec3_new(),
		d_pos = vec3_new(),
		vel = vec3_new(),
		desired_vel = vec3_new(),
		speed = 100, -- pixels per second.
		w = 8,
		h = 8,
	}
end

-->8
-- update functions.

function update_desired_vel(p)
	p.desired_vel:zero()
	if i_left then
		p.desired_vel.x -= p.speed
	end
	if i_right then
		p.desired_vel.x += p.speed
	end
	if i_up then
		p.desired_vel.y -= p.speed
	end
	if i_down then
		p.desired_vel.y += p.speed
	end
	if p.desired_vel.x~=0 and p.desired_vel.y~=0 then
		p.desired_vel:mul(.707)
	end
end

function apply_move(p)
	p.vel:damp(p.desired_vel, .01)
	p.d_pos
		:assign(p.vel)
		:mul(.0167)
	p.pos:add(p.d_pos)
end

-->8
-- game-specific utils.

function vec3.world2screen(v)
	return v.x+64, v.y+64
end

-->8
-- stuff that could be pulled into lib for future.

function grab_inputs()
	i_left, i_right, i_up, i_down, i_z, i_x = btn(0), btn(1), btn(2), btn(3), btn(4), btn(5)
end
