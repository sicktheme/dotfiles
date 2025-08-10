--settings nvim
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Копирование в системный буфер по Ctrl+C
vim.keymap.set('v', '<C-c>', '"+y', { noremap = true, silent = true })

-- Вставка из системного буфера по Ctrl+V
vim.keymap.set('i', '<C-v>', '<C-r>+', { noremap = true, silent = true })
vim.keymap.set('n', '<C-v>', '"+p', { noremap = true, silent = true })

vim.api.nvim_set_hl(0, "Normal", { bg = "#1e2326" })  -- Основной фон как старая бумага
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#7c6f64" })  -- Границы как тушь

vim.opt.guicursor = "n-v-c-sm:block-Cursor/lCursor,i-ci-ve:ver25-Cursor2/rCursor"
vim.api.nvim_set_hl(0, "Cursor", { fg = "#d65d0e", bg = "NONE" })  -- Цвет киновари

vim.api.nvim_set_hl(0, "LineNr", { fg = "#928374", bg = "#282828" })  -- Выцветший лён
vim.opt.cursorlineopt = "both"  -- Плавное перемещение подсветки
vim.fn.sign_define("DiagnosticSignError", { text = "✺", texthl = "DiagnosticSignError" })

--require("lspconfig.ui.windows").default_options.border = "single"  -- Простые линии

--Lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then 
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

--Plugins
require("lazy").setup({
--	{
--		"ellisonleao/gruvbox.nvim",
--		priority = 1000,
--		config = function()
--          vim.o.background = "dark"
--			vim.cmd.colorscheme("gruvbox")
--		end,
--	},

    {
   "sainnhe/everforest",
    config = function()
        vim.g.everforest_background = "hard"  -- Глубокие тени как в храмовых росписях
        vim.g.everforest_disable_italic_comment = 1  -- Чёткость как в каллиграфии
        vim.cmd([[
            colorscheme everforest
        ]])
    end
    },

    {
    "nvim-tree/nvim-web-devicons",
    config = function()
        require("nvim-web-devicons").set_icon({
        c = { icon = "㈂", color = "#d65d0e" },  -- Киноварь
        h = { icon = "ㇳ", color = "#458588" },   -- Индиго
        py = { icon = "㉿", color = "#b16286" }   -- Пурпур
        })
    end
    },

	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup()
		end,
	},

--	{
--		"williamboman/mason.nvim",
--		build = ":MasonUpdate",
--		config = true
--	},
--
--	{
--		"williamboman/mason-lspconfig.nvim",
--		config = function() 
--			require("mason-lspconfig").setup({
--				ensure_installed = {"clangd"}
--			})
--		end
--	},

    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end,
    },

--    {
--        "nvim-lualine/lualine.nvim",
--        dependencies = { "nvim-tree/nvim-web-devicons" },
--        config = function()
--            require("lualine").setup({
--                options = { theme = "catppuccin" },
--            })
--        end,
--    },
--
    {
    "nvim-lualine/lualine.nvim",
        opts = {
        options = {
            theme = "everforest",
            component_separators = { left = "", right = "" },  -- Символы как стыки деревянных балок
            section_separators = { left = "", right = "" },    -- Массивные разделители
        },
            sections = {
            lualine_c = {
            {
                "filename",
                symbols = { modified = " ㉿ ", readonly = " ㇳ " }  -- Значки как печати
            }
        }
        }
    }
    },

 -- Автодополнение (nvim-cmp)
    {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",   -- Источник для LSP
      "hrsh7th/cmp-buffer",      -- Дополнение из буфера
      "hrsh7th/cmp-path",        -- Дополнение путей
      "L3MON4D3/LuaSnip",        -- Сниппеты
      "saadparwaiz1/cmp_luasnip" -- Интеграция сниппетов
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end
    },


    {
    "neovim/nvim-lspconfig",
    config = function()
        local lspconfig = require("lspconfig")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- Настройки clangd
        lspconfig.clangd.setup({
            capabilities = capabilities,
            cmd = {
                "clangd",
                "--background-index",
                "--clang-tidy",
                "--header-insertion=never",
                "--completion-style=detailed",
                "--cross-file-rename",
            },
            init_options = {
                clangdFileStatus = true,
                usePlaceholders = true,
                completeUnimported = true,
            },
            on_attach = function(client, bufnr)
                -- Включить значки на полях (E, W и т.д.)
                vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" })
                vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
                vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" })
                vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

                -- Настройки диагностики (ошибки прямо в коде)
                vim.diagnostic.config({
                    virtual_text = {
                        prefix = "●", -- Иконка перед текстом
                        spacing = 4,
                    },
                    signs = true,      -- Значки на полях
                    underline = true,  -- Подчеркивание проблемных мест
                    update_in_insert = false, -- Не обновлять при вводе
                    severity_sort = true,
                    float = {          -- Всплывающее окно при наведении
                        border = "rounded",
                        source = "always",
                    },
                })
            end,
        })

        -- Горячие клавиши
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover info" })
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
        vim.keymap.set("n", "<leader>fd", vim.lsp.buf.format, { desc = "Format code" })
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
     end,
     },

    {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end
    }

})
