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
" vim 'infrastructure'
Plugin 'kana/vim-textobj-user'
Plugin 'bps/vim-textobj-python'
Plugin 'benmills/vimux'
Plugin 'junegunn/goyo.vim'                " Lightroom-like functionality.

" language specific things.
Plugin 'sheerun/vim-polyglot'
Plugin 'rust-lang/rust.vim'               " Racer/RLS integration.
Plugin 'rhysd/rust-doc.vim'               " Rust Doc support.
Plugin 'plasticboy/vim-markdown'          " good markdown support.
Plugin 'slashmili/alchemist.vim'

" Git Things.
Plugin 'tpope/vim-fugitive'               " Git integration by tpope. May get tossed.
Plugin 'airblade/vim-gitgutter'           " Shows changed/added/removed lines in gutter.

" Code Navigation
Plugin 'junegunn/fzf'                     " Fuzzy File Finder, replacement for command-t
Plugin 'junegunn/fzf.vim'                 " Adds FZF vim bindings for Extra Shit
Plugin 'w0rp/ale'
Plugin 'tpope/vim-unimpaired'             " A lot of very useful paired motions.
Plugin 'tpope/vim-surround'               " Makes changing delimiters far less of a pain.
Plugin 'tpope/vim-dispatch'               " non-focus stealing builds/tests hooray!
Plugin 'tpope/vim-commentary'             " Makes commenting not a pain.
Plugin 'tpope/vim-endwise'                " automatically adds 'end' and similar to certain languages.
Plugin 'tpope/vim-repeat'                 " Adds repeat motion for plugins, at least some.
Plugin 'godlygeek/tabular'                " Required for markdown.
Plugin 'jiangmiao/auto-pairs'             " Automatically match pairs.
Plugin 'justinmk/vim-sneak'
Plugin 'YankRing.vim'                     " Kill ring implementation in vim, check :h yankring-tutorial

" Themes and colorschemes.
Plugin 'flazz/vim-colorschemes'           " Giant-ass collection because why not.

" Status/Air/Powerline
Plugin 'vim-airline/vim-airline-themes'   " Make the status bar match the theme.
Plugin 'vim-airline/vim-airline'          " Swag up my statusbar.

call vundle#end()                       " required
filetype plugin indent on                 " required

set autoread                   " automatically read file-changes from disk.
set showmatch                  " Matching brackets.
set showcmd                    " Shadowing partial commands for completion!
set backspace=indent,eol,start " Allow Backspace to delete everythng.
set expandtab                  " We use spaces here.
set tabstop=2                  " And they're two spaces. Because Scala.
set softtabstop=2              " Because Scala.
set shiftwidth=2               " Scala aint changing soon sonny.
set autoindent                 " You can't escape
set incsearch                  " search while typing, not just after hitting CR
set hlsearch                   " Highlight search terms
set lazyredraw                 " Make vim redraw the screen less
set wildmenu                   " Visual tab complete menu.
set foldenable                 " Make shit orderly.
set number                     " And I like to see my numbers.
set t_Co=256                   " Terminal stuff for Zenburn

colors gruvbox
set background=dark


" Triger `autoread` when files changes on disk
" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
" https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
" Notification after file change
" https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

" Remaps.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let mapleader=' '
nnoremap <leader>evm :e ~/dotfiles/.vimrc<CR>
inoremap ZXZ <c-o>zz
nnoremap <C-S> :w<CR>
inoremap ± <c-o>~
nnoremap ; :
nnoremap : ;
nnoremap <leader>tb :Tabularize /
nnoremap <leader>ln :lnext<CR>
nnoremap <leader>lp :lprevious<CR>

nnoremap <leader>gy :Goyo 120<CR>

" Create ranger window in half-split for looking for things.
nnoremap <leader>sr :!tmux split-window -v \; resize-pane -D 15 \; send-keys "ranger" Enter<CR><CR>

" clear search highlights
nnoremap <leader>ch :noh<CR>

" Kills WhiteSpace, at the end of the line.
nnoremap <leader>kws :%s/\s\+$//e<CR>

" Remaps Q to 'run last macro used'
nnoremap Q @@

" Remaps backspace and CR to be about paragraph wise handling instead of doing
" nothing.
nnoremap <BS> {
onoremap <BS> {
vnoremap <BS> {

nnoremap <expr> <CR> empty(&buftype) ? '}' : '<CR>'
onoremap <expr> <CR> empty(&buftype) ? '}' : '<CR>'
vnoremap <CR> }

" Switching theme
nnoremap <leader>cd :set background=dark<CR>
nnoremap <leader>cl :set background=light<CR>

" Fast and inconvenient vs slow and convenient
nnoremap <leader>ht :set cursorline! relativenumber!<CR>

" Statusbar
let g:airline_theme='badwolf'     " Make our powerline suit the theme at hand.
let g:airline_powerline_fonts = 1 " And make it pretty.
set laststatus=2                  " And make it... appear.

" Vimux things
let g:VimuxHeight = "30"
nnoremap <leader>vr :VimuxPromptCommand<CR>
nnoremap <leader>vl :VimuxRunLastCommand<CR>

" Vim dispatch
nnoremap <leader>ro <ESC>:w<CR>:Dispatch<CR><CR>
nnoremap <leader>rh <ESC>:w<CR>:Dispatch!<CR><CR>

" YankRing remappings for less conflicts.
let g:yankring_replace_n_pkey = ''
let g:yankring_replace_n_nkey = ''
nnoremap <leader>ys :YRShow<CR>

" FZF config and remaps
let $FZF_DEFAULT_COMMAND = 'ag -g ""'
let g:fzf_command_prefix = 'Fzf'
let g:fzf_layout         = { 'down': '~20%' }
let g:fzf_tags_command   = 'ctags -R'
let g:fzf_history_dir    = '~/.fzf/history'

nnoremap <leader>tf  :FzfFiles<CR>
nnoremap <leader>tgf :FzfGitFiles<CR>
nnoremap <leader>tt  :FzfTags<CR>
nnoremap <leader>tgg :!ctags -R<CR><CR>
nnoremap <leader>;   :w<CR>:FzfBuffers<CR>
nnoremap <leader>th  :FzfHistory<CR>
" Search Word
nnoremap <leader>w   :FzfAg<CR>
" Search word under cursor
nnoremap <leader>tw  :FzfAg <C-R><C-W><CR>
nnoremap <leader>gs  :FzfGFiles?<CR>
nnoremap <leader>ts  :FzfSnippets<CR>
nnoremap <leader>hh  :FzfHelptags<CR>

" ALE settings.
let g:ale_sign_column_always = 1
let g:airline#extensions#ale#enabled = 1
let g:ale_open_list = 1

 " I'd use stakc-build but that only works on-save
let g:ale_linters = {
      \ 'haskell': ['hdevtools', 'stack-build'],
      \    'rust': ['cargo', 'rustfmt'],
      \}

" Git things
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gg :execute(":!cd " . expand('%:p:h') . "; tig status")<CR><CR>
nnoremap <leader>hn :GitGutterNextHunk<CR>
nnoremap <leader>hp :GitGutterPreviousHunk<CR>

" Rust
au FileType rust nnoremap <leader>rf :RustFmt<CR>
au FileType rust nnoremap <leader>rt :Dispatch cargo test<CR>
au FileType rust nnoremap <leader>rd :RustDoc
au FileType rust let b:dispatch = 'cargo run'
au BufRead *.rs :setlocal tags=./tags;/,$RUST_SRC_PATH/rusty-tags.vi
au BufWritePost *.rs :silent! exec "!rusty-tags vi --quiet --start-dir=" . expand('%:p:h') . "&" | redraw!

" Python
nnoremap <leader>pt :Dispatch pytest %<CR>
au FileType python let b:dispatch = 'python3 %'

" Ruby Things.
let g:syntastic_ruby_checkers = ['rubocop']
au FileType ruby let b:dispatch = 'ruby %'
au FileType ruby nnoremap <leader>rt :Dispatch rspec<CR>

" Haskell things.
let g:hindent_on_save = 0
au FileType haskell nnoremap <leader>rf :Hindent<CR>
au FileType haskell nnoremap <leader>rt :call VimuxRunCommand('rake test')<CR>
au FileType haskell nnoremap gq :%!stylish-haskell<CR>

""""""
" Markdown things.

au FileType markdown let b:dispatch = 'pandoc %:p -f markdown+smart -t latex -o '. expand('%:p:r') . '.pdf --pdf-engine=xelatex -V urlcolor=blue -V colorlinks'
au FileType markdown set tw=79
nnoremap <leader>mo :execute "!open -a Skim " . expand('%:p:r') . ".pdf"<CR><CR>
nnoremap <leader>mt :Toc<CR>
let g:vim_markdown_folding_disabled     = 1 " Fuck folding in markdown documents.
let g:vim_markdown_toc_autofit          = 1 " Shrink TOC to avoid wasted whitespace.
let g:vim_markdown_math                 = 1 " Turn on Latex math, $...$ and $$...$$
let g:vim_markdown_new_list_item_indent = 2 " Make o insert indentation as 'new list item'

" Toggle spellchecker.
au FileType markdown nnoremap <leader>sct :setlocal spell! spelllang=en_gb<CR>

" HTML bindings
au FileType html let b:dispatch = "open %"

" Scala
au FileType scala let b:dispatch = 'sbt compile'
au FileType scala nnoremap <leader>rt :Dispatch sbt test<CR>
au FileType scala nnoremap <leader>rf :SortScalaImports<CR>
