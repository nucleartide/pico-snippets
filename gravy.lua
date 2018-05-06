
--
-- gravy util.
--

gravy = {}
gravy.__index = gravy

function gravy.new(pos, gravity, max_dy)
  return setmetatable({
    pos     = pos
    gravity = gravity or 0.15
    max_dy  = max_dy  or 2
    dy      = 0
  }, gravy)
end

function gravy:update()
  self.dy    += self.gravity
  self.dy    =  mid(-self.max_dy, self.dy, self.max_dy)
  self.pos.y += dy
end
