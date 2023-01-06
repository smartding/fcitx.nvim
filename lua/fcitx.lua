local uv = vim.loop
local api = vim.api
local fn = vim.fn

local M = {}

-- fcitx_remote_cmd can be fcitx-remote for fcitx4 or fcitx5-remote for fcitx5
local fcitx_remote_cmd = ""
-- fcitx status, as returned by fcitx5-remote/fctix-remote
local Status = { CLOSE = 0, INACTIVE = 1, ACTIVE = 2 }

local function leave_insert()
  -- fcitx5-remote takes 0.003-0.005s to run, no need to go async
  local fcitx_status = tonumber(vim.fn.system(fcitx_remote_cmd))

  if fcitx_status == Status.ACTIVE then
    -- fcitx_activate_in_insert means whether to activate fcitx next time in INSERT mode
    vim.b.fcitx_activate_in_insert = true
    -- always switch to en in NORMAL mode
    fn.system(fcitx_remote_cmd .. " -c")
  else
    vim.b.fcitx_activate_in_insert = false
  end
end

local function enter_insert()
  if vim.b.fcitx_activate_in_insert == true then
    -- switch to cn
    fn.system(fcitx_remote_cmd .. " -o")
  end
end

M.setup = function()
  -- no need to switch input method in a SSH session
  if uv.os_getenv("SSH_TTY") ~= nil then
    return
  end

  -- no need to switch input method if not in GUI
  if uv.os_getenv("DISPLAY") == nil and uv.os_getenv("WAYLAND_DISPLAY") == nil then
    return
  end

  -- no need to switch input method if in wsl
  if string.find(uv.os_uname().release, "microsoft") then
    return
  end

  -- defaults to fcitx5-remote
  if fn.executable("fcitx5-remote") == 1 then
    fcitx_remote_cmd = "fcitx5-remote"
  elseif fn.executable("fcitx-remote") == 1 then
    fcitx_remote_cmd = "fcitx-remote"
  else
    vim.notify("fcitx-remote/fcitx5-remote not in PATH, Aborting setup")
    return
  end

  -- setup autocmds
  local fcitx_augroup = api.nvim_create_augroup("fcitx_augroup", { clear = true })
  api.nvim_create_autocmd("InsertEnter", { callback = enter_insert, group = fcitx_augroup })
  api.nvim_create_autocmd("InsertLeave", { callback = leave_insert, group = fcitx_augroup })
end

return M
