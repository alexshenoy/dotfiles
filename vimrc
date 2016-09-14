" Encoding (important that this is set early in .vimrc)
se enc=utf8 " use UTF-8 internally
se fencs=ucs-bom,utf-8,default,latin1 " detect detectable Unicode, but fall back

" Include Plugins
if filereadable(expand("~/.vimrc.bundles"))
    source ~/.vimrc.bundles
endif

" Include Plugins
if filereadable(expand("~/.vimrc.mappings"))
    source ~/.vimrc.mappings
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
:au CursorHold * silent! :wa | :SyntasticCheck
:au InsertLeave * silent! :DeleteTrailingWhitespace | :wa | :SyntasticCheck

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

" Special settings for python
autocmd BufRead,BufNewFile *.py setlocal tabstop=4 expandtab
" And for ruby
autocmd BufRead,BufNewFile *.rb setlocal tabstop=2 expandtab softtabstop=2 shiftwidth=2


" ==== Meta-vim
filetype on
" reload vimrc on save
augroup vimrc
  autocmd BufWritePost .vimrc source $MYVIMRC
augroup END

"Explicitly set filetypes
aug filetypedetect
  au! BufNewFile,BufRead *.markdown,*.md,*.mkd se ft=markdown
  au! BufNewFile,BufRead *.scala se ft=scala
  au! BufNewFile,BufRead *.hbs se ft=mustache
  au! BufNewFile,BufRead *.c se ft=c
aug END

" Check for file changes
au CursorHold * checktime

" === Programming things
" Syntax checks
augroup Programming
  " clear auto commands for this group
  autocmd!
  autocmd BufWritePost *.js !test -f ~/jslint/jsl && ~/jslint/jsl -conf ~/jslint/jsl.default.conf -nologo -nosummary -process <afile>
  autocmd BufWritePost *.rb !ruby -c <afile>
  autocmd BufWritePost *.rake !ruby -c <afile>
  autocmd BufWritePost *.erb !erb -x -T '-' <afile> | ruby -c
  autocmd BufWritePost *.py !python -c "compile(open('<afile>').read(), '<afile>', 'exec')"
  autocmd BufWritePost *.php !php -d display_errors=on -l <afile>
  autocmd BufWritePost *.inc !php -d display_errors=on -l <afile>
  autocmd BufWritePost *httpd*.conf !/etc/rc.d/init.d/httpd configtest
  autocmd BufWritePost *.bash !bash -n <afile>
  autocmd BufWritePost *.sh !bash -n <afile>
  autocmd BufWritePost *.pl !perl -c <afile>
  autocmd BufWritePost *.perl !perl -c <afile>
  autocmd BufWritePost *.xml !xmllint --noout <afile>
  autocmd BufWritePost *.xsl !xmllint --noout <afile>
  " get csstidy from http://csstidy.sourceforge.net/
  " autocmd BufWritePost *.css !test -f ~/csstidy/csslint.php && php ~/csstidy/csslint.php <afile>
  " get jslint from http://javascriptlint.com/
  " autocmd BufWritePost *.pp !puppet --parseonly <afile>
augroup END

autocmd BufNewFile,BufRead *.md se wrap linebreak nolist


" ==== Plugins
" Airline (better Powerline)
let g:airline_left_sep = '▶'
let g:airline_right_sep = '◀'

" Ctrlp
" Show hidden files by default
let g:ctrlp_show_hidden = 1
" Ctrl P Ignore build and git directories
let g:ctrlp_custom_ignore = '\v[\/](\.git|build)$'

set wildignore+=*/tmp/*,*.so,*.swp,*.zip

"" Colors
set background=dark
colorscheme railscasts
let g:solarized_termcolors=256

:set guifont=Hack

" switch between .c->.h->_interface.h files
" inspired by
" http://vim.wikia.com/wiki/Easily_switch_between_source_and_header_file
function! SwitchSourceHeader()
  if ( match(expand("%"), "_interface.h") > -1 )
    let s:filename = substitute(expand("%"),'_interface.\ch\(.*\)','.c\1',"")
    exe ":find " s:filename
  elseif (expand("%:e") == "c")
    find %:t:r.h
  else
    find %:t:r_interface.h
  endif
endfunction

map <C-J> :call SwitchSourceHeader()<CR>
map <C-K> :call SwitchSourceHeader()<CR>

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_puppet_puppetlint_args = "--no-only_variable_string-check"

au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

au BufEnter /private/tmp/crontab.* setl backupcopy=yes

