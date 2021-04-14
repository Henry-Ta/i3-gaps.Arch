call plug#begin('~/.config/nvim/plugged')
	
	Plug 'gruvbox-community/gruvbox'
    Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'

    Plug 'w0rp/ale'

    Plug 'tpope/vim-surround'

    Plug 'tpope/vim-fugitive'
	Plug 'airblade/vim-gitgutter'

    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
	Plug 'junegunn/fzf.vim'

    Plug 'majutsushi/tagbar'

    Plug 'scrooloose/nerdcommenter'

    Plug 'scrooloose/nerdtree'
    Plug 'xuyuanp/nerdtree-git-plugin'
    Plug 'ryanoasis/vim-devicons'
    Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

    Plug 'jiangmiao/auto-pairs'
    Plug 'yggdroot/indentline'

    Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

"-------------------------------------- Theme
if (has("termguicolors"))
	set termguicolors
endif

syntax enable
set background=dark
colorscheme gruvbox 


"--------------------------------------- Vim Airline 
let g:airline_theme='gruvbox' 
let g:airline#extensions#tabline#enabled = 1 


"-----------------------------------------------GitGutter
function! GitStatus()
	let [a,m,r] = GitGutterGetHunkSummary()
	return printf('+%d ~%d -%d', a, m, r)
endfunction
set statusline+=%{GitStatus()}


"------------------------------------- FzF
nnoremap <M-f> :FZF<CR>

let g:fzf_action = {'alt-s': 'split','alt-v': 'vsplit'}
" requires the_silver_searcher
" used to ignore gitignore files
let $FZF_DEFAULT_COMMAND = 'ag -g ""'


"------------------------------------- Tag Bar
nnoremap <M-t> :TagbarToggle<CR>
" let g:tagbar_indent = 3
let g:tagbar_show_data_type = 1
let g:tagbar_show_linenumbers = -1
let g:tagbar_show_tag_linenumbers = 1
let g:tagbar_show_tag_count = 1
let g:tagbar_previewwin_pos = ''
"let g:tagbar_autopreview = 1


"--------------------------------------- Nerd Tree
" Start NERDTree and put the cursor back in the other window.
"autocmd VimEnter * NERDTree | wincmd p

"Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
	\ quit | endif

" nnoremap <leader>n :NERDTreeFocus<CR>
" nnoremap <C-n> :NERDTree<CR>
nnoremap <M-e> :NERDTreeToggle <CR>
" nnoremap <C-f> :NERDTreeFind<CR>

" -> Shift + I: toggle hidden files

" let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = []
let g:NERDTreeWinPos = 'right' 
" let g:NERDTreeStatusline = ''

"-------------------------------------- Nerd Tree Git Plugin
"let g:NERDTreeGitStatusIndicatorMapCustom = {
                "\ 'Modified'  :'✹',
                "\ 'Staged'    :'✚',
                "\ 'Untracked' :'✭',
                "\ 'Renamed'   :'➜',
                "\ 'Unmerged'  :'═',
                "\ 'Deleted'   :'✖',
                "\ 'Dirty'     :'✗',
                "\ 'Ignored'   :'☒',
                "\ 'Clean'     :'✔︎',
                "\ 'Unknown'   :'?',
                "\ }

"let g:NERDTreeGitStatusUseNerdFonts = 1

"------------------------------------- Devicons
set guifont=DroidSansMono\ Nerd\ Font\ 11
let g:airline_powerline_fonts = 0 


"------------------------------------- Syntax Highlight
let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1

let g:NERDTreeHighlightFolders = 1 " enables folder icon highlighting using exact match
""let g:NERDTreeHighlightFoldersFullName = 1 " highlights the folder name
let g:NERDTreeLimitedSyntax = 1

" you can add these colors to your .vimrc to help customizing
let s:brown = "905532"
let s:aqua =  "3AFFDB"
let s:blue = "689FB6"
let s:darkBlue = "44788E"
let s:purple = "834F79"
let s:lightPurple = "834F79"
let s:red = "AE403F"
let s:beige = "F5C06F"
let s:yellow = "F09F17"
let s:orange = "D4843E"
let s:darkOrange = "F16529"
let s:pink = "CB6F6F"
let s:salmon = "EE6E73"
let s:green = "8FAA54"
let s:lightGreen = "31B53E"
let s:white = "FFFFFF"
let s:rspec_red = 'FE405F'
let s:git_orange = 'F54D27'

let g:NERDTreeExtensionHighlightColor = {} " this line is needed to avoid error
let g:NERDTreeExtensionHighlightColor['css'] = s:blue " sets the color of css files to blue
let g:NERDTreeExactMatchHighlightColor = {} " this line is needed to avoid error
let g:NERDTreeExactMatchHighlightColor['.gitignore'] = s:git_orange " sets the color for .gitignore files
let g:NERDTreePatternMatchHighlightColor = {} " this line is needed to avoid error
let g:NERDTreePatternMatchHighlightColor['.*_spec\.rb$'] = s:rspec_red " sets the color for files ending with _spec.rb
let g:WebDevIconsDefaultFolderSymbolColor = s:beige " sets the color for folders that did not match any rule
let g:WebDevIconsDefaultFileSymbolColor = s:blue " sets the color for files that did not match any rule


"--------------------------------------- Auto Pair
filetype plugin on
filetype indent off

set smartindent


"------------------------------------------------------------------ Indent Line
let g:indentLine_setColors = 0
"let g:indentLine_char_list = ['▏','│','|','⎸', '¦', '┆', '┇', '┊', '┋', '┆┇┃┊┋']    
let g:indentLine_char = '▏'
"let g:indentLine_char_list = ['│','┆']

autocmd Filetype json :IndentLinesDisable


"-----------------------------------------------Coc_Nvim
let g:coc_global_extensions = ['coc-highlight', 'coc-emmet', 'coc-python', 'coc-css', 'coc-html', 'coc-phpls', 'coc-json', 'coc-prettier', 'coc-tsserver']


"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++SETTINGS++++++++++++++++++++++++++++++++++++++++++++++++++++++++" 
set number relativenumber
set splitbelow
set splitright
set mouse=a
set cursorline
set nowrap

"----------------------------------------------------- Tab Width
set tabstop=4       " The width of a TAB is set to 4. Still it is a \t. It is just that Vim will interpret it to be having a width of 4.
set shiftwidth=4    " Indents will have a width of 4
set softtabstop=4   " Sets the number of columns for a TAB
set expandtab       " Expand TABs to spaces


"-----------------------------------------------------Switch Windows 
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l
nnoremap <A-=> <C-w>=
