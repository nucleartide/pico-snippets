function assign(...)
	local ts, result = {...}, {}
	for t in all(ts) do
		for k,v in pairs(t) do
			result[k] = v
		end
	end
	return result
end
