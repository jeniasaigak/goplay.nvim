local Utils = {}

function Utils._os_capture(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()

  if raw then return s end
  return Utils._format_result(s)
end

function Utils._format_result(s)
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
end

function Utils._isDirExist(path)
  return Utils._os_capture("/bin/bash -c '[ -d \"" .. path .. "\" ] && echo \"True\"'", false) == "True"
end

function Utils._isFileExist(path)
  return Utils._os_capture("/bin/bash -c '[ -f \"" .. path .. "\" ] && echo \"True\"'", false) == "True"
end

function Utils._execGoFile(filepath)
  return Utils._os_capture("go run " .. filepath, true)
end

return Utils
