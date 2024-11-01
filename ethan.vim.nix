# this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  home-manager.users.ethan = { pkgs, ... }: {
    programs.vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        vim-plug
      ];
      extraConfig = ''
        call plug#begin('~/.vim/plugged')
        Plug 'tpope/vim-sensible'
        Plug 'neoclide/coc.nvim', {'branch': 'release'}
        Plug 'francoiscabrol/ranger.vim'
        Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
        Plug 'junegunn/fzf.vim'
        Plug 'tpope/vim-surround'
        Plug 'vim-airline/vim-airline'
        Plug 'liuchengxu/vim-which-key'
        Plug 'ruanyl/vim-gh-line'
        Plug 'hashivim/vim-terraform'
        Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
        Plug 'jiangmiao/auto-pairs'
        Plug 'gko/vim-coloresque'
        Plug 'KabbAmine/vCoolor.vim'
        Plug 'janko-m/vim-test'
        Plug 'LnL7/vim-nix'
        Plug 'tpope/vim-fugitive'
        Plug 'rbong/vim-flog'
        Plug 'jparise/vim-graphql'
        Plug 'pearofducks/ansible-vim'
        Plug 'tpope/vim-rhubarb'
        Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
        Plug 'peitalin/vim-jsx-typescript'
        Plug 'honza/vim-snippets'
        Plug 'mlaursen/vim-react-snippets'
        Plug 'diepm/vim-rest-console'
        Plug 'preservim/nerdcommenter'
        Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
        Plug 'wellle/context.vim'
        Plug 'nvie/vim-flake8'
        Plug 'psliwka/vim-smoothie'
        Plug 'mechatroner/rainbow_csv'
        Plug 'jasonccox/vim-wayland-clipboard'

        call plug#end()

        set exrc
        set secure

        filetype on
        filetype plugin on
        filetype indent on

        set lazyredraw

        set encoding=UTF-8
        set mouse=a

        set updatetime=300
        set signcolumn=yes

        set number
        set relativenumber
        set cursorline
        set undofile
        set autoread
        set expandtab
        set smartindent
        set nocompatible
        set splitbelow
        set splitright
        set hlsearch

        autocmd FileType crontab setlocal nobackup nowritebackup
        autocmd FileType javascript setlocal ts=2 sts=2 sw=2
        autocmd FileType json setlocal ts=2 sts=2 sw=2
        autocmd FileType zsh setlocal ts=2 sts=2 sw=2
        autocmd FileType sh setlocal ts=2 sts=2 sw=2
        autocmd FileType c setlocal ts=4 sts=4 sw=4
        autocmd FileType typescript setlocal ts=2 sts=2 sw=2
        autocmd FileType typescript.tsx setlocal ts=2 sts=2 sw=2
        autocmd FileType typescriptreact setlocal ts=2 sts=2 sw=2
        autocmd FileType ruby setlocal ts=2 sts=2 sw=2
        autocmd FileType php setlocal ts=4 sts=4 sw=4
        autocmd FileType ccpp setlocal ts=4 sts=4 sw=4
        autocmd FileType xml setlocal ts=2 sts=2 sw=2
        autocmd FileType css setlocal ts=2 sts=2 sw=2
        autocmd FileType yaml setlocal ts=2 sts=2 sw=2 cursorcolumn
        autocmd FileType json syntax match Comment +\/\/.\+$+

        autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescriptreact

        autocmd BufEnter *.sls set filetype=yaml

        autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red

        inoremap jk <Esc>
        tnoremap <Esc> <C-\><C-n>

        set clipboard+=unnamedplus

        vnoremap <C-c> "+
        nnoremap <C-c> "+

        let mapleader = "\<Space>"
        let maplocalleader = ","

        let g:which_key_map = {}

        let g:ranger_map_keys = 0 " Ranger auto maps this to <leader>f
        let g:ranger_open_new_tab = 1

        let g:which_key_map.r = ['Ranger', 'Ranger File Browser']

        set foldmethod=syntax
        set foldlevel=3

        nnoremap <silent> K :call <SID>show_documentation()<CR>

        function! s:show_documentation()
                if (index(['vim', 'help'], &filetype) >= 0)
                        execute 'h '.expand('<cword>')
                else
                        call CocAction('doHover')
                endif
        endfunction

        " Use tab for trigger completion with characters ahead and navigate
        " NOTE: There's always complete item selected by default, you may want to enable
        " no select by `"suggest.noselect": true` in your configuration file
        " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
        " other plugin before putting this into your config
        inoremap <silent><expr> <TAB>
              \ coc#pum#visible() ? coc#pum#next(1) :
              \ CheckBackspace() ? "\<Tab>" :
              \ coc#refresh()
        inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

        " Make <CR> to accept selected completion item or notify coc.nvim to format
        " <C-g>u breaks current undo, please make your own choice
        inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                                      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

        " Use <c-space> to trigger completion
        inoremap <silent><expr> <c-@> coc#refresh()

        function! CheckBackspace() abort
          let col = col('.') - 1
          return !col || getline('.')[col - 1]  =~# '\s'
        endfunction

        " Use `[g` and `]g` to navigate diagnostics
        " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
        nmap <silent> [g <Plug>(coc-diagnostic-prev)
        nmap <silent> ]g <Plug>(coc-diagnostic-next)

        let g:coc_global_extensions =
          \[
          \  '@yaegassy/coc-intelephense',
          \  '@yaegassy/coc-tailwindcss3',
          \  'coc-deno',
          \  'coc-docker',
          \  'coc-flutter',
          \  'coc-go',
          \  'coc-highlight',
          \  'coc-html',
          \  'coc-jedi',
          \  'coc-json',
          \  'coc-markdownlint',
          \  'coc-prettier',
          \  'coc-rust-analyzer',
          \  'coc-snippets',
          \  'coc-solargraph',
          \  'coc-tsserver',
          \  'coc-xml',
          \  'coc-yaml'
          \]


        let g:which_key_map.r = ['Ranger', 'Ranger File Browser']

        let g:which_key_map.f = { 'name' : 'Files',
                       \ 'f' : ['Files', 'Find Files FZF'],
                       \ 'b' : ['Buffers', 'Find Buffers FZF'],
                       \ 'g' : ['GFiles', 'Find GIT Files FZF'],
                       \ 'G' : ['GFiles?', 'Find GIT Files FZF with Changes'],
                       \ }

        let g:fzf_action = { 'enter': 'tab split' }

        nnoremap <left> gT
        nnoremap <up> gT
        nnoremap <right> gt
        nnoremap <down> gt

        "----- Buffers
        let g:which_key_map.b = { 'name' : 'Buffer',
                       \ 'd' : ['bd', 'Close buffer'],
                       \ 'n' : ['bnext', 'Next buffer'],
                       \ 'p' : ['bprev', 'Previous buffer'],
                       \ 'J' : ['%!jq .', 'Format Json']
                       \ }

        "----- Fugitive ( Git )
        let g:which_key_map.g = { 'name' : 'Fugitive',
                       \ 'g' : ['Git', 'Call a git command'],
                       \ 'b' : ['Git blame', 'Blame'],
                       \ 'd' : ['Gdiffsplit', 'GIT Diff'],
                       \ 'l' : ['Git log', 'Git log'],
                       \ 'm' : ['Git mergetool', 'Git mergetool'],
                       \ 'D' : ['Git difftool', 'Git difftool'],
                       \ 'c' : ['Git commit', 'Git commit'],
                       \ 'B' : ['GBrowse', 'Open in browser'],
                       \ 'C' : ['Commits', 'FZF Commits'],
                       \ 'a' : ['BCommits', 'FZF Current Buffer Commits'],
                       \ }

        let g:which_key_map.w = { 'name' : 'Windows',
                       \ 'd' : ['close', 'Close Window'],
                       \ 'n' : ['bnext', 'Next Buffer'],
                       \ 'p' : ['bprevious', 'Previous Buffer'],
                       \ 's' : ['split', 'Horizontal Split'],
                       \ 'v' : ['vsplit', 'Vertical Split'],
                       \ 'h' : ['<C-W>h', 'Move Left'],
                       \ 'l' : ['<C-W>l', 'Move Right'],
                       \ 'j' : ['<C-W>j', 'Move Down'],
                       \ 'k' : ['<C-W>k', 'Move Up'],
                       \ 't' : ['call MaximizeToggle()', 'Close Others'],
                       \ '=': ['wincmd =', 'Resize Equally'],
                       \ }

        "----- Testing
        let g:which_key_map.t = { 'name' : 'Testing',
                       \ 'n' : ['TestNearest', 'Nearest'],
                       \ 'f' : ['TestFile', 'File'],
                       \ 's' : ['TestSuite', 'Suite'],
                       \ 'l' : ['TestLast', 'Last'],
                       \ 'v' : ['TestVisit', 'Visit Last'],
                       \ }

        let g:which_key_map.m = { 'name' : 'Markdown',
                       \ 'p' : ['MarkdownPreviewToggle', 'Toggle MD Preview'],
                       \ }

        let g:which_key_map.z = { 'name': 'FZF Fun',
                       \ 'b' : [ 'Buffers', "Open Buffers" ],
                       \ 'l' : [ 'BLines', "Current Buffer Lines" ],
                       \ 'L' : [ 'Lines', "All Buffer Lines" ],
                       \ }

        nnoremap <silent> zh :History:<CR>
        nnoremap <silent> zH :History/<CR>

        call which_key#register('<Space>', "g:which_key_map")

        nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
        vnoremap <silent> <localleader> :<c-u>WhichKeyVisual ','<CR>

        " GoTo code navigation
        nmap <silent>gd <Plug>(coc-definition)
        nmap <silent>gy <Plug>(coc-type-definition)
        nmap <silent>gi <Plug>(coc-implementation)
        nmap <silent>gr <Plug>(coc-references)

        " Formatting selected code
        nmap <silent>cfs <Plug>(coc-format-selected)

        " Symbol renaming
        nmap <silent>rn <Plug>(coc-rename)

        " Setup formatexpr specified filetype(s)
        autocmd FileType go,typescript,json setl formatexpr=CocAction('formatSelected')

        " Update signature help on jump placeholder
        autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

        " Remap keys for applying code actions at the cursor position
        nmap <leader>ca  <Plug>(coc-codeaction-cursor)
        " Remap keys for apply code actions affect whole buffer
        nmap <leader>cas  <Plug>(coc-codeaction-source)
        " Apply the most preferred quickfix action to fix diagnostic on the current line
        nmap <leader>cac  <Plug>(coc-fix-current)

        " Run the Code Lens action on the current line
        nmap <leader>cl <Plug>(coc-codelens-action)

        xnoremap <silent> <C-@> :w !wl-copy<CR><CR>
        nnoremap <C-@> :call system("wl-copy", @")<CR>

        let g:airline#extensions#tabline#enabled = 1
        let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

        let test#strategy = "shtuff"
        let g:shtuff_receiver = 'devrunner'
        let test#python#runner = 'djangotest'

        set background=dark
        highlight clear

        if exists("syntax_on")
          syntax reset
        endif

        set t_Co=256
        let g:colors_name = "monokai"

        hi Cursor ctermfg=235 ctermbg=231 cterm=NONE guifg=#272822 guibg=#f8f8f0 gui=NONE
        hi Visual ctermfg=NONE ctermbg=59 cterm=NONE guifg=NONE guibg=#49483e gui=NONE
        hi CursorLine ctermfg=NONE ctermbg=237 cterm=NONE guifg=NONE guibg=#3c3d37 gui=NONE
        hi CursorColumn ctermfg=NONE ctermbg=237 cterm=NONE guifg=NONE guibg=#3c3d37 gui=NONE
        hi ColorColumn ctermfg=NONE ctermbg=237 cterm=NONE guifg=NONE guibg=#3c3d37 gui=NONE
        hi LineNr ctermfg=102 ctermbg=237 cterm=NONE guifg=#90908a guibg=#3c3d37 gui=NONE
        hi VertSplit ctermfg=241 ctermbg=241 cterm=NONE guifg=#64645e guibg=#64645e gui=NONE
        hi MatchParen ctermfg=197 ctermbg=NONE cterm=underline guifg=#f92672 guibg=NONE gui=underline
        hi StatusLine ctermfg=231 ctermbg=241 cterm=bold guifg=#f8f8f2 guibg=#64645e gui=bold
        hi StatusLineNC ctermfg=231 ctermbg=241 cterm=NONE guifg=#f8f8f2 guibg=#64645e gui=NONE
        hi Pmenu ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
        hi PmenuSel ctermfg=NONE ctermbg=59 cterm=NONE guifg=NONE guibg=#49483e gui=NONE
        hi IncSearch term=reverse cterm=reverse ctermfg=193 ctermbg=16 gui=reverse guifg=#c4be89 guibg=#000000
        hi Search term=reverse cterm=NONE ctermfg=231 ctermbg=24 gui=NONE guifg=#f8f8f2 guibg=#204a87
        hi Directory ctermfg=141 ctermbg=NONE cterm=NONE guifg=#ae81ff guibg=NONE gui=NONE
        hi Folded ctermfg=242 ctermbg=235 cterm=NONE guifg=#75715e guibg=#272822 gui=NONE
        hi Conceal ctermfg=231 ctermbg=235 cterm=NONE guifg=#f8f8f0 guibg=NONE gui=NONE
        hi SignColumn ctermfg=NONE ctermbg=237 cterm=NONE guifg=NONE guibg=#3c3d37 gui=NONE
        hi Normal ctermfg=231 ctermbg=235 cterm=NONE guifg=#f8f8f2 guibg=#272822 gui=NONE
        hi Boolean ctermfg=141 ctermbg=NONE cterm=NONE guifg=#ae81ff guibg=NONE gui=NONE
        hi Character ctermfg=141 ctermbg=NONE cterm=NONE guifg=#ae81ff guibg=NONE gui=NONE
        hi Comment ctermfg=242 ctermbg=NONE cterm=NONE guifg=#75715e guibg=NONE gui=NONE
        hi Conditional ctermfg=197 ctermbg=NONE cterm=NONE guifg=#f92672 guibg=NONE gui=NONE
        hi Constant ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
        hi Define ctermfg=197 ctermbg=NONE cterm=NONE guifg=#f92672 guibg=NONE gui=NONE
        hi DiffAdd ctermfg=231 ctermbg=64 cterm=bold guifg=#f8f8f2 guibg=#46830c gui=bold
        hi DiffDelete ctermfg=88 ctermbg=NONE cterm=NONE guifg=#8b0807 guibg=NONE gui=NONE
        hi DiffChange ctermfg=NONE ctermbg=NONE cterm=NONE guifg=#f8f8f2 guibg=#243955 gui=NONE
        hi DiffText ctermfg=231 ctermbg=24 cterm=bold guifg=#f8f8f2 guibg=#204a87 gui=bold
        hi diffAdded ctermfg=148 ctermbg=NONE cterm=NONE guifg=#a6e22e guibg=NONE gui=NONE
        hi diffFile ctermfg=81 ctermbg=NONE cterm=NONE guifg=#66d9ef guibg=NONE gui=NONE
        hi diffIndexLine ctermfg=242 ctermbg=NONE cterm=NONE guifg=#75715e guibg=NONE gui=NONE
        hi diffLine ctermfg=81 ctermbg=NONE cterm=NONE guifg=#66d9ef guibg=NONE gui=NONE
        hi diffRemoved ctermfg=197 ctermbg=NONE cterm=NONE guifg=#f92672 guibg=NONE gui=NONE
        hi diffSubname ctermfg=242 ctermbg=NONE cterm=NONE guifg=#75715e guibg=NONE gui=NONE
        hi ErrorMsg ctermfg=231 ctermbg=197 cterm=NONE guifg=#f8f8f0 guibg=#f92672 gui=NONE
        hi WarningMsg ctermfg=231 ctermbg=197 cterm=NONE guifg=#f8f8f0 guibg=#f92672 gui=NONE
        hi Float ctermfg=141 ctermbg=NONE cterm=NONE guifg=#ae81ff guibg=NONE gui=NONE
        hi Function ctermfg=148 ctermbg=NONE cterm=NONE guifg=#a6e22e guibg=NONE gui=NONE
        hi Identifier ctermfg=81 ctermbg=NONE cterm=NONE guifg=#66d9ef guibg=NONE gui=italic
        hi Keyword ctermfg=197 ctermbg=NONE cterm=NONE guifg=#f92672 guibg=NONE gui=NONE
        hi Label ctermfg=186 ctermbg=NONE cterm=NONE guifg=#e6db74 guibg=NONE gui=NONE
        hi NonText ctermfg=242 ctermbg=NONE cterm=NONE guifg=#75715e guibg=NONE gui=NONE
        hi Number ctermfg=141 ctermbg=NONE cterm=NONE guifg=#ae81ff guibg=NONE gui=NONE
        hi Operator ctermfg=197 ctermbg=NONE cterm=NONE guifg=#f92672 guibg=NONE gui=NONE
        hi PreProc ctermfg=197 ctermbg=NONE cterm=NONE guifg=#f92672 guibg=NONE gui=NONE
        hi Special ctermfg=231 ctermbg=NONE cterm=NONE guifg=#f8f8f2 guibg=NONE gui=NONE
        hi SpecialComment ctermfg=242 ctermbg=NONE cterm=NONE guifg=#75715e guibg=NONE gui=NONE
        hi SpecialKey ctermfg=242 ctermbg=NONE cterm=NONE guifg=#75715e guibg=NONE gui=NONE
        hi SpecialChar ctermfg=141 ctermbg=NONE cterm=NONE guifg=#ae81ff guibg=NONE gui=NONE
        hi Statement ctermfg=197 ctermbg=NONE cterm=NONE guifg=#f92672 guibg=NONE gui=NONE
        hi StorageClass ctermfg=81 ctermbg=NONE cterm=NONE guifg=#66d9ef guibg=NONE gui=italic
        hi String ctermfg=186 ctermbg=NONE cterm=NONE guifg=#e6db74 guibg=NONE gui=NONE
        hi Tag ctermfg=197 ctermbg=NONE cterm=NONE guifg=#f92672 guibg=NONE gui=NONE
        hi Title ctermfg=231 ctermbg=NONE cterm=bold guifg=#f8f8f2 guibg=NONE gui=bold
        hi Todo ctermfg=95 ctermbg=NONE cterm=inverse,bold guifg=#75715e guibg=NONE gui=inverse,bold
        hi Type ctermfg=197 ctermbg=NONE cterm=NONE guifg=#f92672 guibg=NONE gui=NONE
        hi Underlined ctermfg=NONE ctermbg=NONE cterm=underline guifg=NONE guibg=NONE gui=underline
        hi helpCommand ctermfg=148 ctermbg=NONE cterm=NONE guifg=#a6e22e guibg=NONE gui=NONE
        hi rubyClass ctermfg=197 ctermbg=NONE cterm=NONE guifg=#f92672 guibg=NONE gui=NONE
        hi rubyFunction ctermfg=148 ctermbg=NONE cterm=NONE guifg=#a6e22e guibg=NONE gui=NONE
        hi rubyInterpolationDelimiter ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
        hi rubySymbol ctermfg=141 ctermbg=NONE cterm=NONE guifg=#ae81ff guibg=NONE gui=NONE
        hi rubyConstant ctermfg=81 ctermbg=NONE cterm=NONE guifg=#66d9ef guibg=NONE gui=italic
        hi rubyStringDelimiter ctermfg=186 ctermbg=NONE cterm=NONE guifg=#e6db74 guibg=NONE gui=NONE
        hi rubyBlockParameter ctermfg=208 ctermbg=NONE cterm=NONE guifg=#fd971f guibg=NONE gui=italic
        hi rubyInstanceVariable ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
        hi rubyInclude ctermfg=197 ctermbg=NONE cterm=NONE guifg=#f92672 guibg=NONE gui=NONE
        hi rubyGlobalVariable ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
        hi rubyRegexp ctermfg=186 ctermbg=NONE cterm=NONE guifg=#e6db74 guibg=NONE gui=NONE
        hi rubyRegexpDelimiter ctermfg=186 ctermbg=NONE cterm=NONE guifg=#e6db74 guibg=NONE gui=NONE
        hi rubyEscape ctermfg=141 ctermbg=NONE cterm=NONE guifg=#ae81ff guibg=NONE gui=NONE
        hi rubyControl ctermfg=197 ctermbg=NONE cterm=NONE guifg=#f92672 guibg=NONE gui=NONE
        hi rubyClassVariable ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
        hi rubyOperator ctermfg=197 ctermbg=NONE cterm=NONE guifg=#f92672 guibg=NONE gui=NONE
        hi rubyException ctermfg=197 ctermbg=NONE cterm=NONE guifg=#f92672 guibg=NONE gui=NONE
        hi rubyPseudoVariable ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
        hi rubyRailsUserClass ctermfg=81 ctermbg=NONE cterm=NONE guifg=#66d9ef guibg=NONE gui=italic
        hi rubyRailsARAssociationMethod ctermfg=81 ctermbg=NONE cterm=NONE guifg=#66d9ef guibg=NONE gui=NONE
        hi rubyRailsARMethod ctermfg=81 ctermbg=NONE cterm=NONE guifg=#66d9ef guibg=NONE gui=NONE
        hi rubyRailsRenderMethod ctermfg=81 ctermbg=NONE cterm=NONE guifg=#66d9ef guibg=NONE gui=NONE
        hi rubyRailsMethod ctermfg=81 ctermbg=NONE cterm=NONE guifg=#66d9ef guibg=NONE gui=NONE
        hi erubyDelimiter ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
        hi erubyComment ctermfg=95 ctermbg=NONE cterm=NONE guifg=#75715e guibg=NONE gui=NONE
        hi erubyRailsMethod ctermfg=81 ctermbg=NONE cterm=NONE guifg=#66d9ef guibg=NONE gui=NONE
        hi htmlTag ctermfg=148 ctermbg=NONE cterm=NONE guifg=#a6e22e guibg=NONE gui=NONE
        hi htmlEndTag ctermfg=148 ctermbg=NONE cterm=NONE guifg=#a6e22e guibg=NONE gui=NONE
        hi htmlTagName ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
        hi htmlArg ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
        hi htmlSpecialChar ctermfg=141 ctermbg=NONE cterm=NONE guifg=#ae81ff guibg=NONE gui=NONE
        hi javaScriptFunction ctermfg=81 ctermbg=NONE cterm=NONE guifg=#66d9ef guibg=NONE gui=italic
        hi javaScriptRailsFunction ctermfg=81 ctermbg=NONE cterm=NONE guifg=#66d9ef guibg=NONE gui=NONE
        hi javaScriptBraces ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
        hi yamlKey ctermfg=197 ctermbg=NONE cterm=NONE guifg=#f92672 guibg=NONE gui=NONE
        hi yamlAnchor ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
        hi yamlAlias ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
        hi yamlDocumentHeader ctermfg=186 ctermbg=NONE cterm=NONE guifg=#e6db74 guibg=NONE gui=NONE
        hi cssURL ctermfg=208 ctermbg=NONE cterm=NONE guifg=#fd971f guibg=NONE gui=italic
        hi cssFunctionName ctermfg=81 ctermbg=NONE cterm=NONE guifg=#66d9ef guibg=NONE gui=NONE
        hi cssColor ctermfg=141 ctermbg=NONE cterm=NONE guifg=#ae81ff guibg=NONE gui=NONE
        hi cssPseudoClassId ctermfg=148 ctermbg=NONE cterm=NONE guifg=#a6e22e guibg=NONE gui=NONE
        hi cssClassName ctermfg=148 ctermbg=NONE cterm=NONE guifg=#a6e22e guibg=NONE gui=NONE
        hi cssValueLength ctermfg=141 ctermbg=NONE cterm=NONE guifg=#ae81ff guibg=NONE gui=NONE
        hi cssCommonAttr ctermfg=81 ctermbg=NONE cterm=NONE guifg=#66d9ef guibg=NONE gui=NONE
        hi cssBraces ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
        hi elixirAtom ctermfg=140 ctermbg=NONE cterm=NONE guifg=#ae81ff guibg=NONE gui=NONE
        hi elixirModuleDeclaration ctermfg=216 ctermbg=NONE cterm=NONE guifg=#f4bf75 guibg=NONE gui=NONE
        hi elixirAlias ctermfg=208 ctermbg=NONE cterm=NONE guifg=#fd971f guibg=NONE gui=NONE
        hi elixirStringDelimiter ctermfg=186 ctermbg=NONE cterm=NONE guifg=#e6db74 guibg=NONE gui=NONE
        hi shQuote ctermfg=186 ctermbg=NONE cterm=NONE guifg=#e6db74 guibg=NONE gui=NONE
        hi shDerefSimple ctermfg=81 ctermbg=NONE cterm=NONE guifg=#66d9ef guibg=NONE gui=italic
        hi markdownHeadingDelimiter ctermfg=197 ctermbg=NONE cterm=NONE guifg=#f92672 guibg=NONE gui=NONE
        hi markdownCode ctermfg=242 ctermbg=NONE cterm=NONE guifg=#75715e guibg=NONE gui=NONE
        hi markdownUrl ctermfg=81 ctermbg=NONE cterm=NONE guifg=#66d9ef guibg=NONE gui=underline
        hi markdownLink ctermfg=81 ctermbg=NONE cterm=NONE guifg=#66d9ef guibg=NONE gui=underline
        hi markdownLinkDelimiter ctermfg=81 ctermbg=NONE cterm=NONE guifg=#66d9ef guibg=NONE gui=NONE
        hi markdownLinkTextDelimiter ctermfg=81 ctermbg=NONE cterm=NONE guifg=#66d9ef guibg=NONE gui=NONE
        hi markdownLinkText ctermfg=81 ctermbg=NONE cterm=NONE guifg=#f8f8f2 guibg=NONE gui=NONE
      '';
    };
  };
}
