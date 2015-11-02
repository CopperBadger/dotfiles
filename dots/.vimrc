set number
set autochdir
set shiftwidth=2
set softtabstop=2
set expandtab
set fillchars+=vert:\ 

" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

let $PYTHONPATH='/usr/lib/python3.4/site-packages'

" let Vundle manage Vundle
Plugin 'gmarik/Vundle.vim'
Plugin 'mattn/emmet-vim'
Plugin 'scrooloose/syntastic'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-surround'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'kien/ctrlp.vim'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'majutsushi/tagbar'

call vundle#end()

python from powerline.vim import setup as powerline_setup
python powerline_setup()
python del powerline_setup
set laststatus=2

filetype off
syntax on

let g:syntastic_always_populate_loc_list = 1
" -----------------------
" Syntastic configuration
" -----------------------
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0


" ----------------------
" NERDTree configuration
" ----------------------
let NERDTreeShowHidden=1


" -------------------
" CtrlP configuration
" -------------------
let g:ctrlp_show_hidden=1


" -----------------------
" UltiSnips configuration
" -----------------------
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-o>"
let g:UltiSnipsJumpBackwardTrigger="<c-i>"

"
"
"
let g:user_emmet_leader_key='<C-c>'


" ------------------
" Custom keybindings
" ------------------
map <C-t> :tabnew<CR>
map <C-w> :q<CR>
map <C-x> :tabn<CR>
map <C-z> :tabp<CR>
map <C-m> :NERDTree<CR>
map <C-h> :wincmd h<CR>
map <C-l> :wincmd l<CR>
map <M-h> :wincmd h<CR>
map <M-l> :wincmd l<CR>
map <M-j> :wincmd j<CR>
map <M-k> :wincmd k<CR>
map <C-a> :Tagbar<CR>

nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
inoremap <C-j> <Esc>:m .+1<CR>==gi
inoremap <C-k> <Esc>:m .-2<CR>==gi
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv
