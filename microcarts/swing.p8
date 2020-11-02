pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

#include ../vec3_v3.p8
#include ../math.lua

debug = true

function _init()
	p1 = init_player()
	e1 = init_enemy()
	static_enemies = {
		e1,
	}
	score = 0
end

function _update60()
	grab_inputs()

	-- update player state.
	-- note: order is important here.
	update_desired_vel(p1)
	update_player_state()

	-- movement.
	apply_move(p1)

	-- check for enemy sword collision.
	for e in all(static_enemies) do
		local did_collide = collide_sword_enemy(e)
		if did_collide then
			del(static_enemies, e)
			score += 1
		end
	end

	-- check for player-enemy collision.
	for e in all(static_enemies) do
		local did_collide = collide_player_enemy(e)
		if did_collide then
			_update60 = function() end
			_draw = function()
				cls()
				print('game over')
			end
		end
	end

	-- update bookkeeping vars.
	if p1.state=='swinging' then
		p1.swinging_t += 1
	end
end

function _draw()
	cls(1)
	for e in all(static_enemies) do
		draw_enemy(e1)
	end
	draw_player(p1)
	if debug then
		-- print(p1.vel.x .. ',' .. p1.vel.y .. ',' .. p1.vel.z)
		-- print(p1.state)
		-- print(p1.desired_vel.x .. ',' .. p1.desired_vel.y)
		-- print('did sword hit' .. tostr(collide_sword_enemy()))
		local c1, c2 = get_swing_corners()

		if c1 and c2 then
			local sx, sy = c1:world2screen()
			pset(sx, sy, 15)

			local sx, sy = c2:world2screen()
			pset(sx, sy, 15)
		end
	end
	print(score, 62, 120, 7)
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

	-- draw the player's body.
	rectfill(left, top, right, bottom, 7)

	-- draw the player's direction,
	-- so that we can draw a sword swing.
	if p1.state=='swinging' then
		local cx, cy = round(sx), round(sy - p.h/2)
		local dir = p.swinging_dir:dupe()
			:mul(10)
		local perp_dir = p.swinging_start_dir:dupe()
			:mul(10)
		-- line(cx, cy, cx+dir.x, cy+dir.y, 8)
		-- line(cx, cy, cx+perp_dir.x, cy+perp_dir.y, 9)

		-- compute t.
		local t = p.swinging_t / p.swinging_len

		-- compute the in-between line.
		local tween_line = perp_dir:dupe()
			:lerp(dir, t)
			:normalize()
			:mul(15)
			:round()

		-- draw the line.
		line(cx, cy, cx+tween_line.x, cy+tween_line.y, 8)

		-- draw the collision box.
		-- pset(cx, cy, 11)

		-- get the opposing point so we can do a collision check.
		-- dir.x, perp_dir.y
		-- perp_dir.x, dir.y
	end
end

function draw_enemy(e)
	local sx, sy = e.pos:world2screen()
	sx, sy = round(sx), round(sy)
	circfill(sx, sy, e.r, 3)
end

-->8
-- init functions.

function init_player()
	return {
		pos = vec3_new(-30),
		d_pos = vec3_new(),
		vel = vec3_new(),
		desired_vel = vec3_new(), -- should be normalized.
		speed = 100, -- pixels per second.
		w = 8,
		h = 8,
		state = 'not_swinging', -- can be 'not_swinging' or 'swinging'.
		swinging_t = 0, -- num frames spent in 'swinging' state.
		swinging_len = 8, -- frame duration of the 'swinging' state.
		swinging_dir = nil, -- vec3 that saves the current dir at time of swing.
		swinging_start_dir = nil, -- vec3 that saves the starting dir of the sword swing.
	}
end

function init_enemy()
	return {
		pos = vec3_new(),
		r = 3,
	}
end

-->8
-- update functions.

function collide_player_enemy(enemy)
	local tlx, tly = round(p1.pos.x-p1.w/2), round(p1.pos.y-p1.h)
	local brx, bry = round(p1.pos.x+p1.w/2), round(p1.pos.y)
	local e_pos = enemy.pos
	return point_in_box(e_pos, vec3_new(tlx, tly), vec3_new(brx, bry))
end

function get_swing_corners()
	if p1.state~='swinging' then
		return
	end

	local cx = p1.pos.x
	local cy = round(p1.pos.y - p1.h/2)

	local dir = p1.swinging_dir:dupe():mul(15)
	local perp_dir = p1.swinging_start_dir:dupe():mul(15)
	local corner1 = vec3_new(cx+dir.x, cy+perp_dir.y)
	local corner2 = vec3_new(cx+perp_dir.x, cy+dir.y)
	return corner1, corner2
end

function collide_sword_enemy(enemy)
	if p1.state~='swinging' then
		return
	end

	local corner1, corner2 = get_swing_corners()
	return point_in_box(enemy.pos, corner1, corner2)
end

function update_player_state()
	-- update state.
	if p_z or p_x then
		p1.state = 'swinging'
		p1.swinging_dir = p1.desired_vel:dupe()
		p1.swinging_start_dir = p1.desired_vel:dupe():rotate(.25)
	elseif p1.swinging_t==p1.swinging_len then
		p1.state = 'not_swinging'
		p1.swinging_t = 0
	end
end

function update_desired_vel(p)
	local v = vec3_new()
	if i_left then
		v.x -= 1
	end
	if i_right then
		v.x += 1
	end
	if i_up then
		v.y -= 1
	end
	if i_down then
		v.y += 1
	end
	if v.x~=0 and v.y~=0 then
		v:mul(.707)
	end
	if v.x~=0 or v.y~=0 then
		-- only assign if non-zero.
		p.desired_vel:assign(v)
	end
end

function apply_move(p)
	-- normalize inputs.
	local i_horiz = 0
	if i_left then i_horiz -= 1 end
	if i_right then i_horiz += 1 end
	local i_vert = 0
	if i_up then i_vert -= 1 end
	if i_down then i_vert += 1 end

	-- update velocity.
	local dir = p.desired_vel:dupe():mul(p.speed)
	if i_horiz==0 and i_vert==0 then
		p.vel:damp(vec3_new(), .01)
	else
		p.vel:damp(dir, .01)
	end

	-- update position.
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

function point_in_box(v, tl, br)
	local min_x, max_x = min(tl.x, br.x), max(tl.x, br.x)
	local min_y, max_y = min(tl.y, br.y), max(tl.y, br.y)
	return min_x<=v.x and v.x<=max_x and
		min_y<=v.y and v.y<=max_y
end

-->8
-- stuff that could be pulled into lib for future.

function grab_inputs()
	i_left, i_right, i_up, i_down, i_z, i_x = btn(0), btn(1), btn(2), btn(3), btn(4), btn(5)
	p_left, p_right, p_up, p_down, p_z, p_x = btnp(0), btnp(1), btnp(2), btnp(3), btnp(4), btnp(5)
end
