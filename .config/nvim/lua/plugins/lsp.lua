-- Based on https://github.com/rust-lang/rust-analyzer/issues/13529#issuecomment-1660862875
local function get_project_rustanalyzer_settings()
  local function get_rustanalyzer_on_dir(dir, current_depth)
    if current_depth > 2 then
      return {}
    end

    -- Try to read config in current directory
    local handle = io.open(vim.fn.resolve(dir .. "/.rust-analyzer.json"))
    if handle then
      local out = handle:read("*a")
      handle:close()
      local success, config = pcall(vim.json.decode, out)
      if success and type(config) == "table" then
        return config
      end
      return {}
    end

    -- Scan subdirectories
    local subdirs = {}
    local scan = vim.uv.fs_scandir(dir)
    if scan then
      while true do
        local name, type = vim.uv.fs_scandir_next(scan)
        if not name then
          break -- Exit the loop when no more entries
        end
        if type == "directory" then
          table.insert(subdirs, dir .. "/" .. name)
        end
      end
    end

    -- Check subdirectories recursively
    for _, subdir in ipairs(subdirs) do
      local config = get_rustanalyzer_on_dir(subdir, current_depth + 1)
      if config and next(config) then -- Check if config is non-empty
        return config
      end
    end

    return {} -- Return empty table if nothing found
  end

  local ok, result = pcall(function()
    return get_rustanalyzer_on_dir(vim.fn.getcwd(), 0)
  end)

  if not ok then
    vim.notify("Error in get_project_rustanalyzer_settings: " .. tostring(result), vim.log.levels.ERROR)
    return {}
  end

  return result or {}
end

return {
  -- {
  --   "linux-cultist/venv-selector.nvim",
  --   dependencies = {
  --     "neovim/nvim-lspconfig",
  --     "mfussenegger/nvim-dap",
  --     "mfussenegger/nvim-dap-python", --optional
  --     { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
  --   },
  --   lazy = false,
  --   branch = "regexp", -- This is the regexp branch, use this for the new version
  --   config = function()
  --     require("venv-selector").setup()
  --   end,
  --   keys = {
  --     { ",v", "<cmd>VenvSelect<cr>" },
  --   },
  -- },
  {
    "NoahTheDuke/vim-just",
    ft = { "just" },
  },
  {
    "mrcjkb/rustaceanvim",
    opts = {
      server = {
        default_settings = {
          ["rust-analyzer"] = vim.tbl_deep_extend(
            "force",
            {
              -- Defaults, can be overriden by .rust-analuzer.json
            },
            get_project_rustanalyzer_settings(),
            {
              diagnostics = {
                disabled = { "proc-macro-disabled" },
              },
            }
          ),
        },
      },
    },
  },
}
