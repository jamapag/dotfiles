local M = {}

local on_exit = function(obj)
  if obj.code == 0 then
    local ok, ddevStatus = pcall(vim.json.decode, obj.stdout)
    if ok then
      if ddevStatus.raw.dbinfo.published_port then
        local name = ddevStatus.raw.name
        local dbType = ddevStatus.raw.dbinfo.database_type
        local dbSchema = 'mysql'
        local dbAuth = ddevStatus.raw.dbinfo.username .. ':' .. ddevStatus.raw.dbinfo.password

        if dbType == 'postgres' then
          dbSchema = 'postgresql'
        end

        vim.g.dbs = {
          { name = 'ddev-' .. name, url = dbSchema .. '://' .. dbAuth .. '@127.0.0.1:' .. ddevStatus.raw.dbinfo.published_port .. '/db' }
        }

        vim.schedule(function()
          vim.cmd('DBUIToggle')
        end)
      else
        print("Can't parse db published_port from ddev describe")
      end
    else
      print("Error parsing ddev describe")
    end
  else
    print("Error running ddev describe")
  end
end

M.toggle_dbui = function()
  vim.system({ 'ddev', 'describe', '-j' }, {text = true}, on_exit)
end

local function create_toggledbui()
  vim.api.nvim_create_user_command('DDEVToggleDBUI', M.toggle_dbui, {})
end

M.setup = function(opts)
  create_toggledbui()
end

return M
