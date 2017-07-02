" Az' vimrc, take MKLLVXII.

set shell=/bin/bash " Vim chokes on fish.
set nocompatible    " be iMproved, required
syntax on                   

" Vundle! :D
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim

filetype off                  " required
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

Plugin 'rust-lang/rust.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'wincent/command-t'
Plugin 'junegunn/vim-easy-align'
Plugin 'jnurmine/Zenburn'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'airblade/vim-gitgutter'
Plugin 'vim-syntastic/syntastic'

Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'

call vundle#end()                 " required
filetype plugin indent on         " required

set showmatch                     " Matching brackets.
set showcmd                       " Shadowing partial commands for completion!
set backspace=indent,eol,start    " Allow Backspace to delete everythng.
set expandtab                     " We use spaces here.
set tabstop=2                     " And they're two spaces. Because Scala.
set softtabstop=2                 " Because Scala.
set shiftwidth=2                  " Scala aint changing soon sonny.
set autoindent                    " You can't escape

set foldenable                    " Make shit orderly.
set cursorline                    " I do like to find my cursor
set number                        " And I like to see my numbers.
set relativenumber                " And I want vim motions to be usable.
set t_Co=256                      " Terminal stuff for Zenburn
colors zenburn                    " Be pretty

let g:airline_theme='zenburn'     " Make our powerline suit the theme at hand.
let g:airline_powerline_fonts = 1 " And make it pretty.
set laststatus=2                  " And make it... work.

" Syntastic Settings
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Remaps.
let mapleader=' ' " we emacs now. 

" Git things
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>gl :Glog<CR><CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gg :!tig<CR>

" Easy Align things
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Rust
nnoremap <leader>rf :RustFmt
nnoremap <leader>rb :!cargo build<CR>
nnoremap <leader>rt :!cargo test<CR>

" Python
nnoremap <leader>pr :!python3 %:p<CR>
nnoremap <leader>pt :!pytest %:p<CR>
let g:syntastic_python_checkers = ['pyflakes']

" Markdown things.
nnoremap <leader>mpd :!pandoc %:p -f markdown -t latex -o pandoc_output.pdf -S --latex-engine=xelatex<CR>
nnoremap <leader>mt  :Toc<CR>
let g:vim_markdown_folding_level        = 4 " Fold anything past a level of 3, so the structure is visible.
let g:vim_markdown_toc_autofit          = 1 " Shrink TOC to avoid wasted whitespace.
let g:vim_markdown_math                 = 1 " Turn on Latex math, $...$ and $$...$$
let g:vim_markdown_new_list_item_indent = 2 " Make o insert indentation as 'new list item'

