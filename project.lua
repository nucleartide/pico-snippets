
--
-- project util.
--
-- remember: p(raster) = p(screen) * m(screen-to-raster)
--
-- think about how you might transform a point from one coordinate system to
-- another.
--

function project(c)
  return function(p)
    -- world space to camera space.
    x, y, z = p.x-c.x, p.y-c.y, p.z-c.z

    -- camera space to screen space.
    x, y = -x/z, -y/z

    -- screen space to raster space.
    x, y = x*64+64, -y*64+64

    return flr(x), flr(y)
  end
end
