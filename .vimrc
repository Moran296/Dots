set noswapfile 

set nocompatible              " be iMproved, required
filetype off                  " required
set hidden
set linebreak
set tags=tags;
set autochdir
" Enter automatically into the files directory
autocmd BufEnter * silent! lcd %:p:h

set  rtp+=home/moran/.local/lib/python3.6/site-packages/powerline/bindings/vim/
set laststatus=2
set t_Co=256



set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required



Plugin 'VundleVim/Vundle.vim'
Plugin 'ervandew/supertab'
Plugin 'taglist.vim'
Plugin 'wincent/scalpel'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'christoomey/vim-tmux-navigator'
nnoremap <C-f> :Lines<CR>
Plugin 'junegunn/vim-peekaboo'
Plugin 'Conque-GDB'
Plugin 'morhetz/gruvbox'
let g:ConqueTerm_StartMessages = 0
let g:ConqueTerm_Color = 0
let g:ConqueTerm_CloseOnEnd = 1
let g:ConqueTerm_Interrupt = '<C-c>'
let g:ConqueTerm_ReadUnfocused = 1
" Track the engine.
Plugin 'SirVer/ultisnips'

" Snippets are separated from the engine. Add this if you want them:
Plugin 'honza/vim-snippets'

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<C-l>"
let g:UltiSnipsJumpBackwardTrigger="<C-h>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"



" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
"Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

let mapleader = ","

syntax on
set guifont=Monaco:h30
set relativenumber
set number
set number relativenumber 
map <F12> :w <CR> :!clear <CR>

function! NumberToggle()
if(&nu == 1)
set nu!
set rnu
else
set nornu
set nu
endif
endfunction

nnoremap <C-n> :call NumberToggle()<CR>

augroup remember_folds
autocmd!
autocmd BufWinLeave * mkview
autocmd BufWinEnter * silent! loadview
augroup END
nmap <S-Enter> O<Esc>
nmap <CR> o<Esc>
set autoindent
set cindent
set cinoptions=g-1

nmap <C-UP> :m-2<CR>  
nmap <C-DOWN> :m+1<CR>

xnoremap p pgvy


vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
nnoremap <F3> :TlistToggle<CR><C-w>h
nnoremap <F2> :NERDTreeToggle<CR>

filetype plugin indent on
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent

colorscheme gruvbox
set bg=dark
cnoreabbrev W w
let g:SuperTabCrMapping = 1

hi Normal guibg=NONE ctermbg=NONE



" Dont indent namespaces ---------------------------
function! IndentNamespace()
let l:cline_num = line('.')
let l:pline_num = prevnonblank(l:cline_num - 1)
let l:pline = getline(l:pline_num)
let l:retv = cindent('.')
while l:pline =~# '\(^\s*{\s*\|^\s*//\|^\s*/\*\|\*/\s*$\)'
let l:pline_num = prevnonblank(l:pline_num - 1)
let l:pline = getline(l:pline_num)
endwhile
if l:pline =~# '^\s*namespace.*'
let l:retv = 0
endif
return l:retv
endfunction
setlocal indentexpr=IndentNamespace()

"Gdb configs ----------------------------------
autocmd BufEnter * if &ft == 'conque_term' | :startinsert | endif
let g:ConqueTerm_CWInsert = 1
let g:ConqueTerm_SendVisKey = '<F9>'
set mouse=n
map <A-LeftRelease> ,b
 
"---PEDAL FUNCTIONALITY-------


let g:copy_timer = 0

func! Timerf(timer)
    echo "finished timing"
    let g:copy_timer = 0
endfunc


function! PedalNormal()
let g = bufwinnr('GDB')
if g == -1

    if(g:copy_timer == 1)
        execute "normal! \"pp"
        " let g:copy_timer = 0
    else
        execute "normal! :w"
    endif

else
normal ,n
endif
endfunction

nnoremap <F7> :call PedalNormal()<CR>
nmap <expr> ,<F7> bufwinnr('GDB') == -1 ? '"pp' : ',b'
nnoremap <expr> ;5~ bufwinnr('GDB') == -1 ? ":let g:copy_timer = 0 " : ',c'
nnoremap <expr> ;2~ bufwinnr('GDB') == -1 ? "\<C-u>" : ',s'

function! PedalSelect()
let g = bufwinnr('GDB')
if g == -1

    if(g:copy_timer == 1)
        execute "normal! gv\"pp"

    else
        execute "normal! gvo\"py" 
        let g:copy_timer = 1
        let timer = timer_start(10000, 'Timerf', {'repeat':1})  " --- copy and start timer ---
    endif

" execute "normal! gvoI/*gvoA*/" ---- macro to put in comment --

else
vmap ,u <F9>
execute "normal jp kgv,uk"
endif
endfunction

vnoremap <F7> :<C-u>call PedalSelect()<CR>
" vmap ;5~ "py
" vnoremap <S-F7> "px




" controls snippets - completion, expanding
" imap <F7> <tab>
imap <expr> <F7> g:copy_timer == 1 ? 'p' : '<tab>'

smap <F7> <C-l>
    


"-------------------------------

nnoremap <S-l> $
nnoremap <S-h> ^


       
















