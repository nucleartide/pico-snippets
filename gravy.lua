
--
-- gravy util.
--

gravy = {}
gravy.__index = gravy

function gravy.new(pos, gravity, max_dy)
  self.pos     = pos
  self.gravity = gravity or 0.15
  self.max_dy  = max_dy  or 2
  self.dy      = 0
end

function gravy:update()
  self.dy    += self.gravity
  self.dy    =  mid(-self.max_dy, self.dy, self.max_dy)
  self.pos.y += dy
end
