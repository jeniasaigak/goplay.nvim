local templates = require('goplay.templates')
local utils = require('goplay.utils')

local modes = {
  current = "current",
  split = "split",
  vsplit = "vsplit",
}

local M = {
  -- Data which can be configured
  template = templates.default, -- template which will be used as the default content for the playground
  mode = modes.vsplit, -- current/split/[vsplit] specifies where the playground will be opened
  playgroundDirName = "goplayground", -- a name of the directory under GOPATH/src where the playground will be saved
  tempPlaygroundDirName = "goplayground_temp", -- a name of the directory under GOPATH/src where the temporary playground will be saved. This option is used when you need to execute a file

  -- Data which might be used for configuring
  templates = templates,
  modes = modes,
}

-- GoPlayground public API

function M.setup(opts)
  opts = opts or {}

  M.template = opts.template or M.template
  M.mode = opts.mode or M.mode
  M.playgroundDirName = opts.playgroundDirName or M.playgroundDirName
  M.tempPlaygroundDirName = opts.tempPlaygroundDirName or M.tempPlaygroundDirName
  M.goPath = opts.goPath or utils._os_capture("go env GOPATH", false)
  M.init()

  vim.api.nvim_create_user_command("GPExecFile", M.goExecFileAsPlayground, {})
  vim.api.nvim_create_user_command("GPExec", M.goExecPlayground, {})
  vim.api.nvim_create_user_command("GPOpen", M.goPlaygroundOpen, {})
  vim.api.nvim_create_user_command("GPClose", M.goPlaygroundClose, {})
  vim.api.nvim_create_user_command("GPToggle", M.goPlaygroundToggle, {})
  vim.api.nvim_create_user_command("GPClear", M.deletePlayground, {})
end

function M.init()
  M._goPlaygroundPath = M.goPath .. "/src/" .. M.playgroundDirName
  M._filePath = M._goPlaygroundPath .. "/main.go"
  M._tempGoPlaygroundPath = M.goPath .. "/src/" .. M.tempPlaygroundDirName
  M._tempFilePath = M._tempGoPlaygroundPath .. "/main.go"
end

function M.goExecFileAsPlayground()
  local content = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  if not utils._isDirExist(M._tempGoPlaygroundPath) then M._createPlaygroundFolder(M._tempGoPlaygroundPath) end
  M._fillPlaygroundFile(M._tempFilePath, content)

  utils._execGoFile(M._tempFilePath)
  os.execute("rm -rf " .. M._tempGoPlaygroundPath)
end

function M.goExecPlayground()
  if utils._isFileExist(M._filePath) then
    utils._execGoFile(M._filePath)
  else
    print("Playground is not created yet. Please use :GPOpen or :GPToggle to create a playground")
  end
end

function M.goPlaygroundOpen()
  if not M._isPlaygroundDirExist() then
    M._createPlaygroundFolder(M._goPlaygroundPath)
    M._fillPlaygroundFile(M._filePath, M.template)
  end

  if M.mode == M.modes.vsplit then
    vim.cmd.vsplit()
  elseif M.mode == M.modes.split then
    vim.cmd.split()
  end

  vim.cmd.edit(M._filePath)
  M._activeBuf = vim.api.nvim_win_get_buf(0)
end

function M.goPlaygroundClose()
  vim.cmd["bdelete!"](M._activeBuf)
  M._activeBuf = nil
end

function M.goPlaygroundToggle()
  local bufExist = pcall(vim.api.nvim_buf_get_name, M._activeBuf)
  if M._activeBuf and bufExist then
    M.goPlaygroundClose()
  else
    M.goPlaygroundOpen()
  end
end

function M.deletePlayground()
  os.execute("rm -rf " .. M._goPlaygroundPath)
end

-- GoPlayground private API

function M._isPlaygroundDirExist()
  return utils._isDirExist(M._goPlaygroundPath)
end

function M._createPlaygroundFolder(folderPath)
  os.execute("mkdir -p " .. folderPath)
  os.execute("cd " .. folderPath .. " && go mod init &> /dev/null")
end

function M._fillPlaygroundFile(filePath, content)
  local file, err = io.open(filePath, "w")
  if file == nil then return nil, err end
  for _, line in ipairs(content) do
    file:write(line .. "\n")
  end
  file:close()
  return filePath
end

return M
