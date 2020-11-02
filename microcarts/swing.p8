pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function _init()
	p1 = init_player()
end

function _update60()
end

function _draw()
	cls(1)
	print('sanity check')
end

-->8
-- draw functions.

function draw_player(p)
	-- ...
end

-->8
-- init functions.

function init_player()
	return {
		pos = vec3_new(),
	}
end

-->8
-- update functions.

-->8
-- game-specific utils.
