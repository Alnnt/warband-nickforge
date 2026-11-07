local ok, err = pcall(dofile, "rename.lua")
if not ok then
	local line = "[Rename] 加载失败: " .. tostring(err)
	pcall(print, line)
	if log_rgl then pcall(log_rgl, line) end
end
