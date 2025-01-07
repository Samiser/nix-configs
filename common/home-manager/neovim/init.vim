"        _
" __   _(_)_ __ ___  _ __ ___  
" \ \ / / | '_ ` _ \| '__/ __| 
"  \ V /| | | | | | | | | (__  
" (_)_/ |_|_| |_| |_|_|  \___| 
"

" basic sensible defaults
    set nocompatible
    filetype off
    syntax on
    set encoding=utf-8
    set backspace=2
    set number relativenumber

    set omnifunc=syntaxcomplete#Complete

    " show commands as ur typing them 
    set showcmd
    " jump to matching bracket briefly on insert
    set showmatch
    " dont redraw during macros, runs them faster
    set lazyredraw

" tabs
    " always use 4 spaces as tab
    set expandtab
    set tabstop=4
    set softtabstop=4
    set shiftwidth=4

" searching
    " highlight incrementally
    set incsearch
    " highlight results
    set hlsearch
    " no capitals searches case insensitive, caps are
    set smartcase ignorecase
    " space clear highlighted text
    nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

" persistent undo

" window navigation
    nmap <C-H> <C-W>h
    nmap <C-J> <C-W>j
    nmap <C-K> <C-W>k
    nmap <C-L> <C-W>l

" buffer navigation
    nmap <silent> <C-N> :bn<CR>
    nmap <silent> <C-P> :bp<CR>

" file browsing
    " no banner
    let g:netrw_banner = 0
    let g:netrw_keepdir = 0
    let g:netrw_winsize = 25
    map <silent> <C-E> :Lexplore<CR>

" bufferline
" set termguicolors
lua << EOF
require("bufferline").setup({})
require("rust-tools").setup({
  server = {
    capabilities = require('cmp_nvim_lsp').default_capabilities()
  }
})
EOF

" folding
    set foldenable
    set foldlevelstart=10
    set foldmethod=indent

" autocompletion 
    set wildmenu
    set completeopt=preview,menuone
    set wildmode=longest,list,full

" hex editing
    " bind command for calling hex mode function
    command -bar Hexmode call ToggleHex()
    
    " hex editing toggle function
    function ToggleHex()
        if !exists("b:editingHex") || !b:editingHex
            " set status
            let b:editingHex=1
            " switch to hex editor
            %!xxd
        else
            " set status
            let b:editingHex=0
            " switch to hex editor
            %!xxd -r
        endif
    endfunction
    
    " bind ctrl+B to toggle hex mode in 
    nnoremap <C-B> :Hexmode<CR>
    inoremap <C-B> <Esc>:Hexmode<CR>
    vnoremap <C-B> :<C-U>Hexmode<CR>
