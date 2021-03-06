" Encoding (important that this is set early in .vimrc)
se enc=utf8 " use UTF-8 internally
se fencs=ucs-bom,utf-8,default,latin1 " detect detectable Unicode, but fall back

scriptencoding utf-8

" Include Plugins
if filereadable(expand('~/.vimrc.bundles'))
    source ~/.vimrc.bundles
endif

" Include Mappings
if filereadable(expand('~/.vimrc.mappings'))
    source ~/.vimrc.mappings
endif

" Include functions
if filereadable(expand('~/.vimrc.functions'))
    source ~/.vimrc.functions
endif

" ==== Presentation
" Info
filetype plugin on
syntax on
set colorcolumn=80
set laststatus=2
set autoread
set title

" setup relative numbering
call rnu#setup()

" Do an incremental search
set incsearch
set hlsearch

set t_Co=256
set directory=~/.vim/swap//,/tmp/vim-swap//,/tmp//

set ignorecase
set smartcase

" get rid of bells
set noeb vb t_vb=

" Save on focus loss and delete trailing whitespace
aug Filestuff
    :au CursorHold * silent! :wa
    :au InsertLeave * silent! :DeleteTrailingWhitespace | :wa | :SyntasticCheck
    :au CursorHold * checktime
aug END

" ==== Typing
set tabstop=2
set softtabstop=2
set shiftwidth=4
set expandtab
set nowrap
set backspace=2
set autoindent
set smartindent
set updatetime=1000

" Special settings based on language
autocmd BufRead,BufNewFile * setlocal tabstop=2 expandtab softtabstop=2 shiftwidth=2
autocmd BufRead,BufNewFile *.py setlocal tabstop=4 expandtab
autocmd BufRead,BufNewFile *.groovy setlocal tabstop=4 softtabstop=4 expandtab

" ==== Meta-vim
filetype on
" reload vimrc on save
augroup vimrc
  autocmd BufWritePost .vimrc source $MYVIMRC
augroup END

"Explicitly set filetypes
aug filetypedetect
  au! BufNewFile,BufRead *.markdown,*.md,*.mkd se ft=markdown
  au! BufNewFile,BufRead *.markdown,*.md,*.mkd se nofoldenable
  au! BufNewFile,BufRead *.scala se ft=scala
  au! BufNewFile,BufRead *.hbs se ft=mustache
  au! BufNewFile,BufRead *.c se ft=c
aug END

aug vagrant
    au! BufNewFile,BufRead Vagrantfile se ft=ruby
aug END

autocmd BufNewFile,BufRead *.md se wrap linebreak nolist

" ==== Plugins
" Airline (better Powerline)
let g:airline_left_sep = '▶'
let g:airline_right_sep = '◀'

" Ctrlp
" Show hidden files by default
let g:ctrlp_show_hidden = 1
" Ctrl P Ignore build and git directories
let g:ctrlp_custom_ignore = '\v[\/](\.git|build|node_modules|vendor|)$'

set wildignore+=*/tmp/*,*.so,*.swp,*.zip

"" Colors
set background=dark
let color=$COLOR
  if color == "light"
    colorscheme absolute
    let g:airline_theme = 'papercolor'
  else
    colorscheme railscasts
    let g:airline_theme = 'tomorrow'
  endif
let g:solarized_termcolors=256

:set guifont=Hack

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_puppet_puppetlint_args = '--no-only_variable_string-check'
let g:syntastic_vim_checkers = ['vint']
let g:syntastic_sh_shellcheck_args = '-e SC2154,SC1090,SC1091,SC2129,SC1003,SC2034'
"let g:syntastic_javascript_checkers=['eslint']
let g:instant_markdown_autostart = 0

" rainbow paren colors
let g:rbpt_colorpairs = [
      \ ['brown',       'RoyalBlue3'],
      \ ['Darkblue',    'SeaGreen3'],
      \ ['darkgray',    'DarkOrchid3'],
      \ ['darkgreen',   'firebrick3'],
      \ ['darkcyan',    'RoyalBlue3'],
      \ ['darkred',     'SeaGreen3'],
      \ ['darkmagenta', 'DarkOrchid3'],
      \ ['brown',       'firebrick3'],
      \ ['gray',        'RoyalBlue3'],
      \ ['darkmagenta', 'DarkOrchid3'],
      \ ['Darkblue',    'firebrick3'],
      \ ['darkgreen',   'RoyalBlue3'],
      \ ['darkcyan',    'SeaGreen3'],
      \ ['darkred',     'DarkOrchid3'],
      \ ['red',         'firebrick3'],
      \ ]

aug RainbowParentheses
    au VimEnter * RainbowParenthesesToggle
    au Syntax * RainbowParenthesesLoadRound
    au Syntax * RainbowParenthesesLoadSquare
    au Syntax * RainbowParenthesesLoadBraces
aug END

aug crontab
    au BufEnter /private/tmp/crontab.* setl backupcopy=yes
aug END

