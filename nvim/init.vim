if &compatible
    set nocompatible
endif
set runtimepath+=~/.config/nvim/dein/repos/github.com/Shougo/dein.vim

if dein#load_state(expand("$XDG_CONFIG_HOME/nvim/dein"))
    call dein#begin(expand("$XDG_CONFIG_HOME/nvim/dein"))
    call dein#load_toml(expand("$XDG_CONFIG_HOME/nvim/dein/plugins.toml"), {'lazy': 0})
    call dein#load_toml(expand("$XDG_CONFIG_HOME/nvim/dein/plugins_lazy.toml"), {'lazy': 1})
    call dein#end()
    call dein#save_state()
endif

if has('conceal')
    set conceallevel=2 concealcursor=i
endif

set history=1000
set fileencodings=ucs-bom,utf-8,iso-2022-jp,sjis,cp932,euc-jp,cp20932
set encoding=utf-8
filetype plugin indent on
set hidden
set incsearch
set showmatch

set cindent
set tabstop=4
set shiftwidth=4
set cinoptions+=l1,i0,(0,W4,J1
set expandtab

set laststatus=2
set statusline=%F%m%r%h%w\ %<(%{&ff},%{&fileencoding})%=%y\ (%3c)[%5l/%5L]
set cursorline
set scrolloff=5
set list
set listchars=tab:\ \ ,eol:\ ,trail:_,extends:>,precedes:<
set number
syntax on

set foldenable
set foldmethod=manual
autocmd BufWinLeave ?* silent mkview
autocmd BufWinEnter ?* silent loadview

set completeopt=menuone,noinsert,noselect
set shortmess+=c

let g:netrw_liststyle = 3

set guifont=Ricty\ Discord\ 13

function! s:ResizeFont(d)
    echo a:d
    let &guifont = substitute(&guifont, '^\(.\{-}\)\([0-9]\+\)\(\.\?[0-9]*\)$',
                \ '\=submatch(1) . printf("%d",str2nr(submatch(2))+a:d) . submatch(3)', '')
endfunction
command! -narg=1 ResizeFont :call s:ResizeFont(<args>)

lua << EOF
    local on_attach = function (client, bufnr)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', {noremap = true, silent = true})
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true, silent = true})
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', {noremap = true, silent = true})
        require('completion').on_attach(client)
    end
    require 'lspconfig'.vimls.setup{on_attach=require'completion'.on_attach}
    require'lspconfig'.pylsp.setup{on_attach=require'completion'.on_attach}
EOF

nnoremap	j	gj
nnoremap	k	gk
nnoremap	<silent>	<C-CR>	:<C-u>call append(expand('.'),'')<CR>j

nnoremap	<expr>		zp	'`[' . strpart(getregtype(), 0, 1) . '`]' 
nnoremap	<silent>	cp	ce<C-r>0<ESC>:let@/=@1<CR>:noh<CR>
nnoremap	<silent>	cP	ciw<C-r>0<ESC>:let@/=@1<CR>:noh<CR>

vnoremap	<silent>	*	"vy/\V<C-r>=substitute(escape(@v,'\/'),"\n",'\\n','g')<CR><CR>
nnoremap	<ESC><ESC>	:noh<CR>

cnoremap	<C-a>	<C-b>
cnoremap	<C-b>	<Left>
cnoremap	<C-f>	<Right>
cnoremap	<C-d>	<Del>
cnoremap	<C-k>	<C-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos()-2] <CR>

nnoremap	<C-k>		:bdelete<CR>
nnoremap	<silent>(C-n)	:bnext<CR>
nnoremap	<silent>(C-p)	:bprevious<CR>

nnoremap	<Leader>f		:e .<CR>

nnoremap	<Leader>q		:copen<CR>
nnoremap	<Leader>Q		:cclose<CR>

nnoremap	<Leader>W		:set wrap!<CR>
nnoremap	+	:ResizeFont(1)<CR>
nnoremap	-	:ResizeFont(-1)<CR>

augroup indentSetting
    autocmd!
    autocmd	BufRead,BufNewFile	*.cpp	setlocal tabstop=4 shiftwidth=4 expandtab
    autocmd	BufRead,BufNewFile	*.hpp	setlocal tabstop=4 shiftwidth=4 expandtab
    autocmd	BufRead,BufNewFile	*.c	setlocal tabstop=4 shiftwidth=4 expandtab
    autocmd	BufRead,BufNewFile	*.h	setlocal tabstop=4 shiftwidth=4 expandtab
    autocmd	BufRead,BufNewFile	*.py	setlocal tabstop=4 shiftwidth=4 expandtab
    autocmd	BufRead,BufNewFile	*.md	setlocal tabstop=2 shiftwidth=2 expandtab
    autocmd	BufRead,BufNewFile	*.yml	setlocal tabstop=2 shiftwidth=2 expandtab
    autocmd	BufRead,BufNewFile	*.hs	setlocal tabstop=4 shiftwidth=4 expandtab
    autocmd	BufRead,BufNewFile	*.go	setlocal tabstop=4 shiftwidth=4 noexpandtab
augroup END

augroup binaryEdit
    autocmd!
    autocmd	BufReadPost	*	if &binary | silent %!xxd -g 1
    autocmd	BufReadPost	*	set ft=xxd | endif
    autocmd	BufWritePre	*	if &binary | %!xxd -r | endif
    autocmd	BufWritePost	*	if &binary | silent %!xxd -g 1
    autocmd	BufWritePost	*	set nomod | endif
augroup END

