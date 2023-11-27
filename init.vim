" Paquetes de VimPlug (Todo debe estar 'lazy loaded' de ser posible)
call plug#begin(stdpath('data') . '/plugged')
	" Nerdtree (Solo se activa ondemand)
	Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
	" El airline y el tema son omnipresentes y el boot time no
	" disminuye mucho cuando los cargamos de forma diferida.
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'joshdick/onedark.vim'
    " Iconos bien chingones en nvim
    Plug 'ryanoasis/vim-devicons'
	" Motor de linternas / autocompletado
	Plug 'dense-analysis/ale',
    " Indicadores de los cambios de git
    Plug 'airblade/vim-gitgutter'
    " Snippets
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
    " Autocerrar llaves, paréntesis, etc
    Plug 'cohama/lexima.vim'
    " Quitar espacios sobrantes
    Plug 'bronson/vim-trailing-whitespace'
    " Mostrar líneas de sangría
    Plug 'Yggdroot/indentLine'
    " Soporte para un vergo de lenguajes
    Plug 'sheerun/vim-polyglot'
    " Paréntesis de colores
    Plug 'luochen1990/rainbow'
    " Licencias perronas pa evitar escribir basura privativa
    Plug 'antoyo/vim-licenses'
    " Tagbar pa ver la estructura del código que hacemos
    Plug 'preservim/tagbar', { 'on': 'TagbarToggle' }
    " Herramientas para Git en Vim
    Plug 'tpope/vim-fugitive'
    " Control-P pa buscar cosas
    Plug 'ctrlpvim/ctrlp.vim'
    " Autocompletado para neovim
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    " Servidor de Lenguaje + Autocompletado
    Plug 'VentGrey/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
    " (Optional) Multi-entry selection UI.
    Plug 'junegunn/fzf'

    " ==== Plugins de Lenguajes ====
    " Dios C
    Plug 'vim-scripts/c.vim', { 'for': ['c', 'cpp'] }
    Plug 'ludwig/split-manpage.vim', { 'for': ['c', 'cpp'] }
    " Dios Rust
	Plug 'rust-lang/rust.vim', { 'for': 'rust' }
	Plug 'cespare/vim-toml', { 'for': 'toml' }
    " La porquería de CSS
    Plug 'ap/vim-css-color', { 'for': 'css' }
    Plug 'hail2u/vim-css3-syntax', { 'for': 'css' }
    Plug 'gko/vim-coloresque', { 'for': 'css' }
    " La porquería de Python
    Plug 'davidhalter/jedi-vim', { 'for': ['python', 'python2', 'python3'] }
    Plug 'raimon49/requirements.txt.vim', {'for': 'requirements'}
    " La porquería de JS
    Plug 'jelera/vim-javascript-syntax', { 'for': 'javascript' }
    " La Diosqueria de HTML
    Plug 'tpope/vim-haml', { 'for': ['html', 'xml'] }
    Plug 'mattn/emmet-vim', { 'for': ['html', 'xml'] }
    " El hermoso svelte
    Plug 'leafOfTree/vim-svelte-plugin', { 'for': 'svelte' }

call plug#end()

" ========== Configuraciones propias de Neovim ==========
colorscheme onedark " Opción para poner el tema de colores
set hidden " Útil para trabajar con múltiples buffers
filetype plugin indent on " Autodetectar los tipos de archivo
let mapleader="," " La comma es la tecla líder
set autochdir " El directorio de trabajo de vim será el mismo que el de la term
set autoread " Detectar y recargar archivos cambiados fuera de Neovim
set background=dark " Preferir un fondo oscuro
set backspace=indent,eol,start " Lista de opciones para la tecla de backspace
set clipboard=unnamedplus " Usar el portapapeles del sistema
set cmdheight=2 " Más espacio para mostrar mensajes
set cursorline " Mostrar la línea donde está el cursor
set fileformats=unix,dos,mac " Convertir los finales de línea a unix
set guifont=JetBrainsMono\ Nerd\ Font:h5
set incsearch " Activar la búsqueda incremental
set laststatus=2 " Mostrar el último status solo si hay dos ventanas abiertas
set lazyredraw " No redibujar nvim mientras se ejecutan macros
set mouse=a " Habilitar el mouse
set mousemodel=popup " Esconder el mouse al escribir
set nobackup
set nocompatible "VIMproved
set noshowmode " No mostrar INSERT dos veces en la pantalla (airlina ya me dice)
set noswapfile " Que chinguen a su madre los backups y los .swp
set number " Habilitar los números de línea
set numberwidth=1 " Minimizar el ancho de los números de línea
set pumheight=10 " Hace el menú popup más pequeño
set ruler " Siempre mostrar la posición del cursor
set showmatch " Mostrar los pares de elementos () []
set showtabline=2 " Mostrar la lista de pestañas solo si hay más de una abierta
set splitbelow " Partir la pantalla horizontal, siempre hacia abajo
set splitright " Partir la pantalla vertical, siempre a la derecha
set t_Co=256 " Soporte para 256 colores
set wildmenu " Mejor completado de línea de comandos
set wildmode=longest,list,full " Completados con tabulación como shell
syntax on " Habilitar el resaltado de sintaxis
syntax enable

let g:CSApprox_loaded = 1

" Si existe una shell, en la sesión, iniciar esa. Si no usar el path default
set shell=$SHELL

" Si eres idiota como yo y mezcas mayúsculas y minúsculas, estas weas te van
" a salvar la vida.
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

" ==== Estilo de código
set colorcolumn=80 " Limite en la columna 80. So it is so it's always been
set tabstop=4 " Muchos lenguajes usan 4 espacios, es mejor hacer override a mano
set softtabstop=4 " Para que backspace borre las que debe
set expandtab " Las tabulaciones eran espacios, son espacios y serán espacios
set smarttab " Ser inteligente con las tabulaciones
set shiftwidth=4 " Ancho de la sangría automática
set autoindent " Sangría automática

" Opciones de GUI
if has ("gui_running")
    set guioptions-=mTrLe  " Eliminar mushas cosas
    set t_Co=256
endif

" ====== Configuración de Lenguajes ======
" C / C++
autocmd FileType *.c setlocal tabstop=8 shiftwidth=8 expandtab
autocmd FileType *.cpp setlocal tabstop=8 shiftwidth=8 expandtab

" Rust
autocmd FileType *.rs setlocal tabstop=4 expandtab shiftwidth=4 smarttab
autocmd BufReadPost *.rs setlocal filetype=rust

" Python
let python_highlight_all = 1
let g:python_highlight_all = 1
let g:python_highlight_indent_errors = 1
let g:python_space_error_highlight = 1
let g:python_self_cls_highlight = 1
let g:pymode_python = 'python3'

autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=4

" HTML
autocmd FileType html setlocal ts=2 sw=2 expandtab
" JavaScript
let g:javascript_enable_domhtmlcss = 1
augroup vimrc-javascript
  autocmd!
  autocmd FileType javascript setl tabstop=4|setl shiftwidth=4|setl expandtab softtabstop=4
augroup END


" ========== Configuraciones de Plugins ==========
" Airline
let g:airline_theme = 'onedark'
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline_skip_empty_sections = 1
let g:airline#extensions#virtualenv#enabled = 1

if exists("*fugitive#statusline")
  set statusline+=%{fugitive#statusline()}
endif

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

if !exists('g:airline_powerline_fonts')
  let g:airline#extensions#tabline#left_sep = ' '
  let g:airline#extensions#tabline#left_alt_sep = '|'
  let g:airline_left_sep          = ''
  let g:airline_left_alt_sep      = '»'
  let g:airline_right_sep         = ''
  let g:airline_right_alt_sep     = '«'
  let g:airline#extensions#branch#prefix     = '⤴' "➔, ➥, ⎇
  let g:airline#extensions#readonly#symbol   = '⊘'
  let g:airline#extensions#linecolumn#prefix = '¶'
  let g:airline#extensions#paste#symbol      = 'ρ'
  let g:airline_symbols.linenr    = '␊'
  let g:airline_symbols.branch    = '⎇'
  let g:airline_symbols.paste     = 'ρ'
  let g:airline_symbols.paste     = 'Þ'
  let g:airline_symbols.paste     = '∥'
  let g:airline_symbols.whitespace = 'Ξ'
endif

" ALE
" Cambiar símbolos
let g:ale_completion_enabled = 1
let g:ale_sign_error = ""
let g:ale_sign_warning = ""

" Deoplete
let g:deoplete#enable_at_startup = 1
call deoplete#custom#option({
\   'smart_case': v:true,
\   })
call deoplete#custom#source('LanguageClient',
\   'min_pattern_length',
\   2)

" DevIcons
let g:webdevicons_enable = 1
let g:webdevicons_enable_nerdtree = 1
let g:webdevicons_enable_airline_tabline = 1
let g:webdevicons_enable_airline_statusline = 1

" Indentline
let g:indentLine_enabled = 1
let g:indentLine_concealcursor = 0
let g:indentLine_char = '┆'
let g:indentLine_faster = 1

" Jedi Vim
let g:jedi#popup_on_dot = 0
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_definitions_command = "<leader>d"
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>n"
let g:jedi#rename_command = "<leader>r"
let g:jedi#show_call_signatures = "0"
let g:jedi#completions_command = "<C-Space>"
let g:jedi#smart_auto_mappings = 0


" LanguageClient-neovim
let g:LanguageClient_autoStart = 1
let g:LanguageClient_hasSnippetSupport = 1
let g:LanguageClient_hoverPreview = "Auto"
let g:LanguageClient_useFloatingHover = 1
let g:LanguageClient_usePopupHover = 1
let g:LanguageClient_loadSettings = 1
let g:LanguageClient_serverCommands = {
    \ 'rust': ['~/.local/bin/rust-analyzer'],
    \ 'python': ['~/.local/bin/pyls'],
    \ 'c': ['ccls'],
    \ 'javascript': ['eslint'],
    \ }

" Enable the emacs-like feedback for strongly typing variables
nnoremap <silent> <Space>lh :call LanguageClient_textDocument_hover()<CR>

" Licenses
let g:licenses_copyright_holders_name = 'Purata Funes, Omar Jair <ventgrey@gmail.com>'
let g:licenses_authors_name = 'Purata Funes, Omar Jair <ventgrey@gmail.com>'
let g:licenses_default_commands = ['gplv2', 'bsd3', 'lgpl']

" NERDTree
let g:NERDTreeChDirMode=2
let g:NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$', '\.db$', '__pycache__']
let g:NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\.bak$', '\~$']
let g:NERDTreeShowBookmarks=1
let g:nerdtree_tabs_focus_on_files=1
let g:NERDTreeMapOpenInTabSilent = '<RightMouse>'
let g:NERDTreeWinSize = 40
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite
nnoremap <silent> <F2> :NERDTreeFind<CR>
nnoremap <silent> <F3> :NERDTreeToggle<CR>

" onedark.vim
let g:onedark_terminal_italics=1
let g:onedark_termcolors=256

" Rainbow
let g:rainbow_active = 1

" rust.vim
" Formatear código de Rust al guardar
let g:rustfmt_autosave = 1
let g:rustfmt_fail_silently = 1


" Tagbar
nmap <silent> <F4> :TagbarToggle<CR>
let g:tagbar_autofocus = 1

" Ultisnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"
let g:UltiSnipsEditSplit="vertical"
