set shell=bash
syntax on
filetype plugin indent on
set nocompatible
" Tabs size
set tabstop=2
set expandtab
set softtabstop=2
set shiftwidth=2
set autoindent
set smartindent

" Wild Options
set wildignore+=*.gz,core.*
set wildmenu
set wildmode=list:longest

" Options
set ic
set hlsearch
set background=dark
" Dangerous if set to unnamdplus, it is disabled yank
" set clipboard=unnamedplus
set completeopt=noinsert,menuone,noselect
set cursorline
set hidden
" set inccommand=split
set mouse=a
set number
set relativenumber
set splitbelow splitright
set title
set ttimeoutlen=0
set wildmenu
set t_Co=256
set diffopt+=vertical


set foldmethod=indent   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
set foldlevel=1         "this is just what i use

let g:LargeFile = 50
" Other options
set autoread

" quick fixes

set backspace=indent,eol,start


" set shellcmdflag=-ic

set path+=**,~,~/debug_workspace/tmp/,~/.vim/**,~/workspace/envoydevenv/**,/opt/ee-3p-install/**

" User commands
command -nargs=+ Gitgrep :Git grep -i --recurse-submodules <args>

" some user variables
"
let s:vimripignore="-g '!cscope.{in,out}*' -g '!tags'"

" Italics
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"

call plug#begin()
    "" Appearance
    
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    "Plug 'ryanoasis/vim-devicons'
    Plug 'bfrg/vim-cpp-modern'
    Plug 'tomasiser/vim-code-dark'
    "" Utilities
    " Plug 'ap/vim-css-color'
    Plug 'preservim/nerdtree'
    "Plug 'preservim/nerdcommenter'
    "" Completion / linters / formatters
    Plug 'neoclide/coc.nvim',  {'branch': 'master', 'do': 'yarn install'}
    " Plug 'plasticboy/vim-markdown'

    "" Git
    Plug 'airblade/vim-gitgutter'
    Plug 'tpope/vim-fugitive'
    " logging"
    Plug 'mtdl9/vim-log-highlighting'
    Plug 'rhysd/vim-clang-format'
    Plug 'wincent/ferret'
    Plug 'vim-scripts/LargeFile'
    Plug 'jremmen/vim-ripgrep'

    Plug 'mg979/vim-visual-multi'

    """ plugin for intra-line diff
    "Plug 'vim-scripts/diffchar.vim'
call plug#end()

""""""""" airblade/vim-gitgutter configuration


let g:gitgutter_max_signs = -1  " default value (Vim < 8.1.0614, Neovim < 0.4.0)

highlight GitGutterAdd    guifg=#009900 ctermfg=2
highlight GitGutterChange guifg=#bbbb00 ctermfg=3
highlight GitGutterDelete guifg=#ff2222 ctermfg=1

" vim-gitgutter used to do this by default:
highlight! link SignColumn LineNr

" or you could do this:
" highlight SignColumn guibg=White ctermbg=Black




"""""""" airblade/vim-gitgutter end



"  rhysd/vim-clang-format configuration
 let g:clang_format#style_options = {
             \ "AccessModifierOffset" : -4,
             \ "AllowShortIfStatementsOnASingleLine" : "true",
             \ "AlwaysBreakTemplateDeclarations" : "true",
             \ "Standard" : "C++11",
\}
let g:clang_format#filetype_style_options= {
              \"cpp": 
              \{
              \    "BasedOnStyle": "Google",
              \    "IndentWidth": 4,
              \    "ColumnLimit": 80,
              \},
               \'c': 
                \{
               \}
\}

nmap <Leader>C :ClangFormatAutoToggle<CR>
" disable auto format on save
let g:clang_format#auto_format=0
" end of configuration

"  vim-cpp-modern configuration

" Disable function highlighting (affects both C and C++ files)
let g:cpp_function_highlight = 1

" Enable highlighting of C++11 attributes
let g:cpp_attributes_highlight = 1

" Highlight struct/class member variables (affects both C and C++ files)
let g:cpp_member_highlight = 1

" Put all standard C and C++ keywords under Vim's highlight group 'Statement'
" (affects both C and C++ files)
let g:cpp_simple_highlight = 1

" user related syntax highlighting
" (affects both C and C++ files)
let g:cpp_user_highlight= 1



"""""""""" airline configuration

let g:airline_theme='base16_solarized_dark'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

"""""""""" end

" File browser
let NERDTreeShowHidden=1

vnoremap <C-c> "*y
nnoremap <C-c> "*p
nnoremap gd <C-]>
inoremap <silent><expr> <TAB> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<TAB>"
nnoremap U <C-r>
"nnoremap <S-CR> :echo "hello"
" nnoremap <C-O> <C-i>


" Create default mappings
let g:NERDCreateDefaultMappings = 1

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1

" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Enable NERDCommenterToggle to check all selected lines is commented or not
let g:NERDToggleCheckAllLines = 1


" User Functions

function! VimRipGrep( ... )
  call system("rg -i -M 200 --vimgrep  --no-ignore ".s:vimripignore." ".join(a:000) . " --color never --vimgrep  > ~/workspace/tmp/vim_ripgrep_results.log")
  view ~/workspace/tmp/vim_ripgrep_results.log
endfunction

function! VimRipGrepReplace( ... )
  let file_search_cmd="rg -s -M 200  --no-ignore ".s:vimripignore." ". a:1." --files-with-matches --color never --vimgrep"
  let files_list = systemlist(file_search_cmd)
  for current_file in files_list
    echo current_file
    let command="split ".current_file." | %s/".a:1."/".a:2."/gI | x"
    execute command
  endfor
  call VimRigGrep(a:2)
endfunction

function! FindFileFunc_v0(file_pattern)
  if filereadable(a:file_pattern)
    return a:file_pattern
  endif
  let file = system('fd --no-ignore-vcs -g ' .. a:file_pattern ..'| head -1')
  return file
endfunction

function! FindFileFunc(file_pattern )
  let file = FindFileFunc_v0(a:file_pattern)
  execute 'edit' file
  "echo 'files '..files
endfunction

function! FindLineFunc( ... )
  let l:list_path = split(join(a:000),':',1)
  let file = FindFileFunc_v0(l:list_path[0])
  execute ":edit ".file . " | :".l:list_path[1]
endfunction

function! CommentLine()
  let num_characters=1
  if or(&filetype == 'c',&filetype == 'cpp')
  let num_characters=2
    let comment_str='//' 
  elseif(&filetype == 'python')
    let num_characters=1
    let comment_str='#'
  elseif(&filetype == 'vim')
    let num_characters=1
    let comment_str='"'
  else
    let num_characters=1
    let comment_str='#'
  endif
  execute "normal! 0_"
  let start_chars = getline('.')[col('.')-1:col('.')+num_characters-2]
  if start_chars==comment_str
    let command='normal! '.num_characters.'x'
  else
    let command='normal! I'.comment_str
  endif
  execute command

endfunction


command -nargs=1 FindLine :call FindLineFunc(<f-args>) 
command -nargs=+ Rgrep :call VimRipGrep(<f-args>)
command -nargs=+ Rgrepreplace :call VimRipGrepReplace(<f-args>)
command -nargs=1 FindFile :call FindFileFunc(<f-args>) 
" True color if available
let term_program=$TERM_PROGRAM

   "Check for conflicts with Apple Terminal app
"if term_program !=? 'Apple_Terminal'
    "set termguicolors
"else
    "if $TERM !=? 'xterm-256color'
        "set termguicolors
    "endif
"endif




"""""""""""""""""" NetRW configuration """"""""""""""""""""""
"" File browser
"let g:netrw_banner=0
"let g:netrw_liststyle=0
"let g:netrw_browse_split=4
"let g:netrw_altv=1
"let g:netrw_winsize=25
"let g:netrw_keepdir=0
"let g:netrw_localcopydircmd='cp -r'
"
"" Create file without opening buffer
"function! CreateInPreview()
"  let l:filename = input('please enter filename: ')
"  execute 'silent !touch ' . b:netrw_curdir.'/'.l:filename
"  redraw!
"endfunction
"
"" Netrw: create file using touch instead of opening a buffer
"function! Netrw_mappings()
"  noremap <buffer>% :call CreateInPreview()<cr>
"endfunction
"
"augroup auto_commands
"    autocmd filetype netrw call Netrw_mappings()
"augroup END
"
"""""""""""""""""" NetRW configuration end """"""""""""""""""""""





nnoremap ghs <Plug>(GitGutterStageHunk)
nnoremap ghu <Plug>(GitGutterUndoHunk)
nnoremap ghh :GitGutterLineHighlightsToggle<CR>
nnoremap ghd :Gdiffsplit <CR>
nnoremap gha :GitGutterAll<CR>
nnoremap ff :FindFile 
vnoremap ff y<Esc>::FindFile <C-R>0<CR> 
nnoremap fl :FindLine 
vnoremap fl y<Esc>:FindLine <C-R>0<CR> 
nnoremap gs :Gitgrep 
nnoremap gb :Git blame<CR> 
nnoremap gbc :Gpedit <cfile>:%<CR>
nnoremap rgf :Rg 
nnoremap rgr :Rgrepreplace
nnoremap fr :%s///gc<Left><Left><Left><Left>
vnoremap fr y<Esc>:%s/<C-R>0//gc<Left><Left><Left>
vnoremap gs y<Esc>:Gitgrep <C-R>0<CR>
vnoremap rgf y<Esc>:Rg <C-R>0<CR>
vnoremap rgr y<Esc>:Rgrepreplace <C-R>0 
nnoremap cf v:ClangFormat<CR> " single line formatting"
vnoremap cf 0o0:ClangFormat<CR>
nnoremap cp :let @+=expand("%:p")<CR>
nnoremap <C-d> :vsplit<CR>
nnoremap <C-e> :split<CR>
nnoremap <C-a> ggvG$<CR>
nnoremap cc :call CommentLine()<CR>
vnoremap cc :call CommentLine()<CR>
nnoremap tn :tabnext<CR>
nnoremap tp :tabprevious<CR>
nnoremap tnn :tabnew<CR>
inoremap kj <Esc>


nnoremap ' <Plug>(GitGutterNextHunk)
nnoremap " <Plug>(GitGutterPrevHunk)




""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CSCOPE settings for vim           
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" This file contains some boilerplate settings for vim's cscope interface,
" plus some keyboard mappings that I've found useful.
"
" USAGE: 
" -- vim 6:     Stick this file in your ~/.vim/plugin directory (or in a
"               'plugin' directory in some other directory that is in your
"               'runtimepath'.
"
" -- vim 5:     Stick this file somewhere and 'source cscope.vim' it from
"               your ~/.vimrc file (or cut and paste it into your .vimrc).
"
" NOTE: 
" These key maps use multiple keystrokes (2 or 3 keys).  If you find that vim
" keeps timing you out before you can complete them, try changing your timeout
" settings, as explained below.
"
" Happy cscoping,
"
" Jason Duell       jduell@alumni.princeton.edu     2002/3/7
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" This tests to see if vim was configured with the '--enable-cscope' option
" when it was compiled.  If it wasn't, time to recompile vim... 
if has("cscope")

    """"""""""""" Standard cscope/vim boilerplate

    " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
    set cscopetag

    " check cscope for definition of a symbol before checking ctags: set to 1
    " if you want the reverse search order.
    set csto=0

    " add any cscope database in current directory
    if filereadable("cscope.out")
        cs add cscope.out  
    " else add the database pointed to by environment variable 
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif

    " show msg when any other cscope db added
    set cscopeverbose  


    """"""""""""" My cscope/vim key mappings
    "
    " The following maps all invoke one of the following cscope search types:
    "
    "   's'   symbol: find all references to the token under cursor
    "   'g'   global: find global definition(s) of the token under cursor
    "   'c'   calls:  find all calls to the function name under cursor
    "   't'   text:   find all instances of the text under cursor
    "   'e'   egrep:  egrep search for the word under cursor
    "   'f'   file:   open the filename under cursor
    "   'i'   includes: find files that include the filename under cursor
    "   'd'   called: find functions that function under cursor calls
    "
    " Below are three sets of the maps: one set that just jumps to your
    " search result, one that splits the existing vim window horizontally and
    " diplays your search result in the new window, and one that does the same
    " thing, but does a vertical split instead (vim 6 only).
    "
    " I've used CTRL-\ and CTRL-@ as the starting keys for these maps, as it's
    " unlikely that you need their default mappings (CTRL-\'s default use is
    " as part of CTRL-\ CTRL-N typemap, which basically just does the same
    " thing as hitting 'escape': CTRL-@ doesn't seem to have any default use).
    " If you don't like using 'CTRL-@' or CTRL-\, , you can change some or all
    " of these maps to use other keys.  One likely candidate is 'CTRL-_'
    " (which also maps to CTRL-/, which is easier to type).  By default it is
    " used to switch between Hebrew and English keyboard mode.
    "
    " All of the maps involving the <cfile> macro use '^<cfile>$': this is so
    " that searches over '#include <time.h>" return only references to
    " 'time.h', and not 'sys/time.h', etc. (by default cscope will return all
    " files that contain 'time.h' as part of their name).


    " To do the first type of search, hit 'CTRL-\', followed by one of the
    " cscope search types above (s,g,c,t,e,f,i,d).  The result of your cscope
    " search will be displayed in the current window.  You can use CTRL-T to
    " go back to where you were before the search.  
    "

    nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>	
    nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>	


    " Using 'CTRL-spacebar' (intepreted as CTRL-@ by vim) then a search type
    " makes the vim window split horizontally, with search result displayed in
    " the new window.
    "
    " (Note: earlier versions of vim may not have the :scs command, but it
    " can be simulated roughly via:
    "    nmap <C-@>s <C-W><C-S> :cs find s <C-R>=expand("<cword>")<CR><CR>	

    nmap <C-@>s :scs find s <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@>g :scs find g <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@>c :scs find c <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@>t :scs find t <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@>e :scs find e <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@>f :scs find f <C-R>=expand("<cfile>")<CR><CR>	
    nmap <C-@>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>	
    nmap <C-@>d :scs find d <C-R>=expand("<cword>")<CR><CR>	


    " Hitting CTRL-space *twice* before the search type does a vertical 
    " split instead of a horizontal one (vim 6 and up only)
    "
    " (Note: you may wish to put a 'set splitright' in your .vimrc
    " if you prefer the new window on the right instead of the left

    nmap <C-@><C-@>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>	
    nmap <C-@><C-@>i :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>	
    nmap <C-@><C-@>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>


    """"""""""""" key map timeouts
    "
    " By default Vim will only wait 1 second for each keystroke in a mapping.
    " You may find that too short with the above typemaps.  If so, you should
    " either turn off mapping timeouts via 'notimeout'.
    "
    "set notimeout 
    "
    " Or, you can keep timeouts, by uncommenting the timeoutlen line below,
    " with your own personal favorite value (in milliseconds):
    "
    "set timeoutlen=4000
    "
    " Either way, since mapping timeout settings by default also set the
    " timeouts for multicharacter 'keys codes' (like <F1>), you should also
    " set ttimeout and ttimeoutlen: otherwise, you will experience strange
    " delays as vim waits for a keystroke after you hit ESC (it will be
    " waiting to see if the ESC is actually part of a key code like <F1>).
    "
    "set ttimeout 
    "
    " personally, I find a tenth of a second to work well for key code
    " timeouts. If you experience problems and have a slow terminal or network
    " connection, set it higher.  If you don't set ttimeoutlen, the value for
    " timeoutlent (default: 1000 = 1 second, which is sluggish) is used.
    "
    "set ttimeoutlen=100


" tomasiser/vim-code-dark configuration

set t_Co=256
set t_ut=
colorscheme codedark

" If you don't like many colors and prefer the conservative style of the standard Visual Studio
let g:codedark_conservative=1
" If you like the new dark modern colors (Needs feedback!)
let g:codedark_modern=1
" Activates italicized comments (make sure your terminal supports italics)
let g:codedark_italics=1
" Make the background transparent
let g:codedark_transparent=1
" If you have vim-airline, you can also enable the provided theme
let g:airline_theme = 'codedark'

set enc=utf-8
set guifont=Powerline_Consolas:h11
set renderoptions=type:directx,gamma:1.5,contrast:0.5,geom:1,renmode:5,taamode:1,level:0.5

endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""" some user configuraitons"""""""""""""""""""""""""""""""""""""""""" 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
highlight Comment ctermfg=gray





""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""" EXPERIMENTS""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"DiffAdd        xxx term=bold ctermfg=188 ctermbg=58 guifg=#D4D4D4 guibg=#4B5632
"DiffDelete     xxx term=bold ctermfg=188 ctermbg=52 guifg=#D4D4D4 guibg=#6F1313
"DiffChange     xxx term=bold ctermfg=188 ctermbg=24 guifg=#D4D4D4 guibg=#005f87
"DiffText       xxx term=reverse ctermfg=234 ctermbg=117 guifg=#1E1E1E guibg=#87d7ff
"
"highlight DiffAdd        term=bold    ctermfg=188 ctermbg=58 guifg=#D4D4D4 guibg=#4B5632
"highlight DiffDelete     term=bold    ctermfg=188 ctermbg=52 guifg=#D4D4D4 guibg=#6F1313
"highlight DiffChange     term=bold    ctermfg=188 ctermbg=24 guifg=#D4D4D4 guibg=#005f87
"highlight DiffText       term=reverse ctermfg=234 ctermbg=117 guifg=#1E1E1E guibg=#87d7ff

