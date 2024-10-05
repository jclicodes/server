{ pkgs, ...}:

  let myVim = pkgs.vim-full.customize {
    name = "vim";
    vimrcConfig = {
      packages.myplugins = with pkgs.vimPlugins; {
        start = [ vim-nix sensible ];
      };
      customRC = ''
          set nobackup
          set clipboard=unnamedplus
          set cmdheight=1
          set fileencoding=utf-8
          set hlsearch
          set ignorecase
          set pumheight=10
          set smartcase
          set smartindent
          set splitbelow
          set splitright
          set noswapfile
          set undofile
          set nowritebackup
          set expandtab
          set shiftwidth=2
          set tabstop=2
          set number
          set laststatus=3
          set noshowcmd
          set noruler
          set norelativenumber
          set numberwidth=4
          set signcolumn=no
          set nowrap
          set scrolloff=10
          set sidescrolloff=8
      '';
      };
  };
in
  {
    environment.systemPackages = with pkgs; [
      myVim
    ];
  }
