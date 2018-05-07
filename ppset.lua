
--
-- pset() with perspective projection.
--
-- call with a camera position `vec3` to create a `pset` function.
--

function ppset(c)
  return function(p, col)
    -- ignore points in front of near plane.
    if p.z > (c.z-1) then return end

    -- world space to camera space.
    x, y, z = p.x-c.x, p.y-c.y, p.z-c.z

    -- camera space to screen space.
    x, y = -x/z, -y/z

    -- screen space to raster space.
    x, y = x*64+64, -y*64+64

    -- draw.
    pset(flr(x), flr(y), col)
  end
end
