local M = {}
local function FontResize(inc)
  vim.g.fontSize = math.max(1, vim.g.fontSize + inc)
  vim.cmd('Guifont! ' .. vim.g.fontName .. ':h' .. vim.g.fontSize)
end
function M.setup()
  vim.api.nvim_create_autocmd('UIEnter', {
    group = 'loading',
    once = true,
    callback = function()
      local fontTable =
      {
        { os = 'unix',  font = [[HackGen Console NF]], size = 14 },
        { os = 'win32', font = [[HackGen Console NF]], size = 12 }
      }
      for _, f in pairs(fontTable) do
        if vim.fn.has(f.os) == 1 then
          vim.g.fontName = f.font
          vim.g.fontSize = f.size
        end
      end
      FontResize(0)
      vim.cmd('GuiWindowOpacity 0.95')
      vim.cmd('GuiScrollBar 1')
    end
  })
  vim.keymap.set('n', '+', function() FontResize(1) end)
  vim.keymap.set('n', '-', function() FontResize(-1) end)
end

return M
