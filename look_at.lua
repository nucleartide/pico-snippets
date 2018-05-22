
--
-- look_at util.
--
-- todo: construct transformation matrix?
--

function look_at(from, to)
  local forward = (to - from):normalize()
  local right   = vec3.cross(vec3.new(0,1,0), forward)
  local up      = vec3.cross(forward, right)

  return {
    x = right,
    y = up,
    z = forward,
  }
end
