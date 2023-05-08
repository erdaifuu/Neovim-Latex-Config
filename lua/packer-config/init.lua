vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost init.lua source <afile> | PackerCompile
  augroup end
]])

local use = require('packer').use
return require'packer'.startup(function()
  use 'wbthomason/packer.nvim'
  use "williamboman/nvim-lsp-installer"
  use 'onsails/lspkind.nvim'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'neovim/nvim-lspconfig'
  use { "catppuccin/nvim", as = "catppuccin" }
  use {'neoclide/coc.nvim', branch = 'release'}
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
  -- or                            , branch = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup {
        detection_methods = {"pattern"},
        patterns = {"=UniNotes", "=LatexF"},
      }
    end
  }

  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional
    },
    config = function()
      require("nvim-tree").setup({
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = {
          enable = true,
          update_root = true
        }, 
      })
    end
  }
  
  use {
    'lervag/vimtex'
  }
  

  -- Installation
  use { 'L3MON4D3/LuaSnip' }
use {
  'hrsh7th/nvim-cmp',
  config = function ()
    require'cmp'.setup {
    snippet = {
      expand = function(args)
        require'luasnip'.lsp_expand(args.body)
      end
    },

    sources = {
      { name = 'luasnip' },
      -- more sources
    },
  }
  end
}
use { 'saadparwaiz1/cmp_luasnip' }
    
	use {
    'rcarriga/nvim-notify', 
    config = function()
      require('notify').setup ({
        -- other stuff
        background_colour = "#badff1"
      })
    end
  }
  use "rafamadriz/friendly-snippets"
  use {"folke/zen-mode.nvim"}
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }
  use "lukas-reineke/indent-blankline.nvim"
  use {"windwp/nvim-autopairs"}
  use {"Pocco81/auto-save.nvim" }

  if packer_bootstrap then 
    require("packer").sync()
  end
end)


