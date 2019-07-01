" ==========================================================
" File Name:    vimrc
" Author:       StarWing
" Version:      0.5 (2560)
" Last Change:  2019-07-02 00:48:21
" Must After Vim 7.0 {{{1
if v:version < 700
    finish
endif
" }}}1
" ==========================================================
" Settings {{{1

" init settings {{{2

silent! so $VIMRUNTIME/vimrc_example.vim

set encoding=utf-8
scriptencoding utf-8

if has('win32') && $LANG =~? 'zh_CN'
    let &rtp = iconv(&rtp, 'gbk', 'utf8')
endif

if has('eval')
    let s:cpo_save = &cpo
    if !exists('g:gui_running')
        let g:gui_running = has('gui_running')
    endif
endif

set cpo&vim " set cpo-=C cpo-=b

" generic Settings {{{2

set ambiwidth=single
set bsdir=buffer
set complete-=i
set completeopt=longest,menu
set diffopt+=vertical
set display=lastline
set fileencodings=ucs-bom,utf-8,cp932,cp936,gb18030,latin1
set fileformats=unix,dos
set formatoptions=tcqmB2
set history=1000
set modeline " for debian.vim, changed the initial value
set shiftwidth=4
set softtabstop=4
set tags=./tags,tags,./tags;
set tabstop=8
set textwidth=70
set viminfo+=!
set virtualedit=block
set whichwrap+=<,>,h,l
set wildcharm=<C-Z>
set wildmenu

" new in Vim 7.3 {{{2

if v:version > 703
    set formatoptions+=j
endif
if v:version >= 703 && has('persistent_undo')
    set undofile
endif


" titlestring & statusline {{{2

set titlestring=%f%(\ %m%h%r%)\ -\ StarWing's\ Vim:\ %{v:servername}
set laststatus=2
set statusline=
set statusline+=%2*%-3.3n%0*%<  " buffer number
set statusline+=%<\ %f  " file name
set statusline+=\ %1*%h%m%r%w%0* " flag
set statusline+=[

if v:version >= 600
    set statusline+=%{&ft!=''?&ft:'noft'}, " filetype
    set statusline+=%{&fenc!=''?&fenc:&enc}, " fileencoding
endif

set statusline+=%{&fileformat}] " file format
set statusline+=%= " right align
"set statusline+=\ %2*0x%-8B  " current char
set statusline+=\ 0x%-8B  " current char
set statusline+=\ %-12.(%l,%c%V%)[%o]\ %P " offset

if globpath(&rtp, "plugin/vimbuddy.vim") != ''
    set statusline+=\ %{VimBuddy()} " vim buddy
endif

" helplang {{{2
if v:version >= 603
    set helplang=cn
endif

" diffexpr {{{2
if has('eval')
    set diffexpr=MyDiff('diff')

    function! MyDiff(cmd)
        let cmd = [a:cmd, '-a --binary', v:fname_in, v:fname_new]

        if &diffopt =~ 'icase'
            let cmd[1] .= ' -i'
        endif
        if &diffopt =~ 'iwhite'
            let cmd[1] .= ' -b'
        endif
        call writefile(split(system(join(cmd)), "\n"), v:fname_out)
    endfunction
endif

if has("win32") " {{{2
    if $LANG =~? 'zh_CN' && &encoding !=? "cp936"
        set termencoding=cp936

        lang mes zh_CN.UTF-8

        set langmenu=zh_CN.UTF-8
        silent! so $VIMRUNTIME/delmenu.vim
        silent! so $VIMRUNTIME/menu.vim
    endif

    if has("directx")
        "set renderoptions=type:directx,geom:1
    endif

elseif has('unix') " {{{2
    if g:gui_running
        lang mes zh_CN.UTF-8
        set langmenu=zh_CN.UTF-8
        silent! so $VIMRUNTIME/delmenu.vim
        silent! so $VIMRUNTIME/menu.vim
    endif
    if has("termguicolors")
        " fix bug for vim
        let &t_8f="\<ESC>[38;2;%lu;%lu;%lum"
        let &t_8b="\<ESC>[48;2;%lu;%lu;%lum"

        " enable true color
        set termguicolors
    endif
    if exists('$TMUX')
        let &t_SI = "\<Esc>Ptmux;\<Esc>\e[5 q\<Esc>\\"
        let &t_EI = "\<Esc>Ptmux;\<Esc>\e[2 q\<Esc>\\"
    else
        let &t_SI = "\e[5 q"
        let &t_EI = "\e[2 q"
    endif
    se mouse=a
    if &term =~ '^screen'
        " tmux knows the extended mouse mode
        set ttymouse=xterm2
    endif
endif " }}}2
if g:gui_running " {{{2
    set co=120 lines=35

    if exists('+gfn')
        if has('win32')
            "silent! set gfn=Consolas:h16:cANSI
            silent! set gfn=Fira_Code:h16:cANSI:qDRAFT
            silent! set gfw=YaHei_Mono:h16:cGB2312
            "exec 'set gfw='.iconv('新宋体', 'utf8', 'gbk').':h10:cGB2312'
        elseif has('mac')
            if exists('&macligatures')
                set macligatures
                set gfn=FiraCode-Regular:h18
            else
                set gfn=Monaco\ for\ Powerline:h18
            endif
            set co=100 lines=30
        else
            "set gfn=Consolas\ 10 gfw=WenQuanYi\ Bitmap\ Song\ 10
            set gfn=DejaVu\ Sans\ Mono\ 9
        endif
    endif
    if has('win32')
       silent! colorscheme evening
    else
        "silent! colorscheme kaltex
        silent! colorscheme evening
    end

else " in terminal {{{2
    "silent! colorscheme kaltex
    silent! colorscheme evening
endif " }}}2
" swapfiles/undofiles settings {{{2

if has('win32')
    let s:tprefix = $VIM
elseif has('unix')
    let s:tprefix = expand("~/.vim")
end

for dir in ['/swapfiles', '/swapfiles/backupfiles', '/swapfiles/undofiles']
    let s:dir = s:tprefix.dir
    if !isdirectory(s:dir)
        if has('win32') && $LANG =~? 'zh_CN'
            let s:dir = iconv(s:dir, &enc, &tenc)
        endif
        silent! call mkdir(s:dir, 'p')
        unlet s:dir
    endif
endfor

if isdirectory(s:tprefix.'/swapfiles')
    let &directory=s:tprefix."/swapfiles"
endif
if isdirectory(s:tprefix.'/swapfiles/backupfiles')
    let &backupdir=s:tprefix."/swapfiles/backupfiles"
endif
if v:version >= 703 && isdirectory(s:tprefix.'/swapfiles/undofiles')
    let &undodir=s:tprefix."/swapfiles/undofiles,."
endif

" grep settings {{{2

if executable('rg')
    set grepprg=rg\ --vimgrep
elseif executable('ag')
    set grepprg=ag\ --nogroup\ --nocolor
else
    exec 'set grepprg=grep\ -rn\ '
endif

"}}}2
" ----------------------------------------------------------
" Helpers {{{1

" Environment Variables Setting {{{2
if has('eval')

    " mapleader value {{{3

    let mapleader = ","

    function! s:globfirst(pattern) " {{{3
        return simplify(split(glob(a:pattern), '\n', 1)[0])
    endfunction

    function! s:let(var, val) " {{{3
        exec 'let '.a:var.'=iconv("'.escape(a:val,'\"').'", &enc, &tenc)'
    endfunction

    " $VIMDIR {{{3
    for dir in split(globpath(&rtp, "plugin/*.vim"), "\<NL>")
        call s:let('$VIMDIR', fnamemodify(dir, ":p:h:h"))
        break
    endfor

    " $PATH in win32 {{{3
    if has("win32")
        call s:let('$PATH', s:globfirst($VIM."/vimfiles/tools").";".$PATH)
        let s:tools = [['git',    'git/bin'          ],
                    \  ['git',    'minGW/git/bin'    ],
                    \  ['cmake',  'cmake/bin'        ],
                    \  ['mingw',  'minGW/bin'        ],
                    \  ['minsys', 'minSYS/bin'       ],
                    \  ['mingw',  'minSYS/mingw/bin' ],
                    \  ['nim',    'nim/bin'          ],
                    \  ['lua53',  'lua53'            ],
                    \  ['lua52',  'lua52'            ],
                    \  ['lua51',  'lua51'            ],
                    \  ['luaJIT', 'luaJIT'           ],
                    \  ['lua',    'Lua'              ],
                    \  ['perl',   'perl/perl/bin'    ],
                    \  ['python', 'Python'           ],
                    \  ['python', 'Python27'         ],
                    \  ['python', 'Python36'         ],
                    \  ['rust',   'Rust/bin'         ]]
        for [name, path] in s:tools
            if !isdirectory($VIM.'/../'.path) | continue | endif

            let s:{name}_path = s:globfirst($VIM.'/../'.path)

            if s:{name}_path != "" && $PATH !~ '\c'.substitute(path, '/', '[\\/]', 'g')
                call s:let('$PATH', $PATH.';'.s:{name}_path)
            else
                unlet s:{name}_path
            endif
        endfor
        unlet s:tools
        if exists('s:mingw_path') " {{{4
            let s:new_mingw_path = substitute(s:mingw_path, '\s\|,', '\\&', 'g')
            let &path .= ','.s:new_mingw_path.'\..\include,'.
                        \ s:new_mingw_path.'\..\include,'.
                        \ s:new_mingw_path.'\..\lib\gcc'
            unlet s:new_mingw_path
        endif

        if exists('s:python_path') " {{{4
            if !exists('$PYTHONPATH')
                call s:let('$PYTHONPATH', s:python_path.'\Lib;'.
                            \ s:python_path.'\Lib\site-packages')
            endif
            if $PATH !~ 'Scripts'
                call s:let('$PATH', s:python_path.'\Scripts;'.
                            \ $PATH)
            endif
        endif

        if exists('s:lua_path') " {{{4
            if isdirectory(s:lua_path.'\5.1')
                let s:lua_path = s:lua_path.'\5.1'
            endif
            call s:let('$LUA_DEV', s:lua_path)
            call s:let('$LUA_DEV', ';;'.s:lua_path.'\?.luac')
            call s:let('$PATH', s:lua_path.'\clibs;'.$PATH)

            if exists('s:mingw_path')
                call s:let('$C_INCLUDE_PATH', $C_INCLUDE_PATH.';'.s:lua_path.'\include')
                call s:let('$CPLUS_INCLUDE_PATH', $CPLUS_INCLUDE_PATH.';'.s:lua_path.'\include')
                call s:let('$LIBRARY_PATH', s:lua_path.'\lib')
            endif
        endif
        " }}}4
    endif

    " $DOC and $WORK {{{3
    if has('win32')
        let s:cur_root = fnamemodify($VIM, ':p')[0]
        let s:spec_path = [['$WORK', $VIM.'\..\..\..\Work'],
                    \ ['$DOC', nr2char(s:cur_root).':\Document'],
                    \ ['$WORK', nr2char(s:cur_root).':\Work']]
        for i in range(char2nr('D'), char2nr('Z'))
            let s:spec_path += [['$DOC', nr2char(i).':\Document'],
                        \ ['$WORK', nr2char(i).':\Work']]
        endfor
        unlet s:cur_root
    else
        let s:spec_path = [['$DOC', expand('~/Document')],
                    \ ['$WORK', '/work'],
                    \ ['$WORK', expand('~/Work')]]
    endif

    for [var, path] in s:spec_path
        if isdirectory(glob(path)) && !exists(var)
            call s:let(var, s:globfirst(path))
        endif
    endfor
    unlet s:spec_path

    if has('win32') && exists('$WORK') && isdirectory(glob("$WORK/Home"))
        let $HOME = glob("$WORK/Home")
    endif

    " $PRJDIR {{{3

    for dir in ['~', '~/..', $VIM, $VIM.'/..', $VIM.'/../..', $WORK]
        for name in ['prj', 'Code', 'Project']
            if isdirectory(expand(dir."/".name))
                call s:let('$PRJDIR', s:globfirst(dir."/".name))
                break
            endif
        endfor
    endfor

    if !exists('$PRJDIR') && exists('$WORK')
        let $PRJDIR = $WORK
    endif


    if exists('$PRJDIR') && argc() == 0
        let orig_dir = getcwd()
        map<silent> <leader>od :<C-U>exec "cd" fnameescape(g:orig_dir)<BAR>NERDTreeToggle<CR>
        silent! cd $PRJDIR
    endif " }}}3

endif " }}}2
" Generic autocmds {{{2
if has('autocmd')
    augroup vimrc_autocmds
        function! s:vimrc_write() " {{{3
            let time = strftime("%Y-%m-%d %H:%M:%S")
            let pos = winsaveview()

            $|if search('\c^" Vimrc History', 'bW')
                call append(line('.'), '" Write at '.time)
            endif

            1|if search('\c^"\s*Last Change:', 'W')
                call setline(line('.'),
                            \ matchstr(getline('.'), '\c^"\s*Last Change:\s*').time)
            endif

            1|if search('\c^"\s*Version:', 'W')
                let pat = '^"\s*[Vv]ersion:\v.{-}\ze%(\s*\((\d+)\))=$'
                let pv = matchlist(getline('.'), pat)
                if empty(pv[1])
                    call setline('.', getline('.').' (1)')
                else
                    call setline('.', pv[0].' ('.(str2nr(pv[1], 10)+1).')')
                endif
            endif

            call winrestview(pos)
        endfunction
        " }}}3

        au!
        au BufFilePost * filetype detect|redraw
        au BufWritePre $MYVIMRC,_vimrc silent call s:vimrc_write()
        au BufWritePre Y:/* set noundofile
        au BufReadPost * if getfsize(expand('%')) < 50000 | syn sync fromstart | endif
        "au BufWritePre * let &backup = (getfsize(expand('%')) > 500000)
        au BufNewFile,BufRead *.vba set noml
        au FileType clojure,dot,lua,haskell,m4,perl,python,ruby,scheme,
                    \tcl,vim,javascript,erlang,rust,elixir
                    \   if !exists('b:ft') || b:ft != &ft
                    \|      let b:ft = &ft
                    \|      set sw=4 ts=8 sts=4 nu et sta fdc=2 fo-=t
                    \|  endif
        au FileType lua se sw=3 sts=3 ts=3 et
        au FileType lua let b:syntastic_checkers=['luacheck', 'lua']
        au FileType nim se sw=2 sts=2 ts=2 nu et fdm=marker fdc=2
        au FileType erlang,elixir se sw=2 sts=2 fdm=marker fdc=2 ff=unix
        au FileType javascript se sw=2 sts=2 ts=2 et fdc=2 fdm=syntax
        au FileType cs se ai nu noet sw=4 sts=4 ts=4 fdc=2 fdm=syntax
        au FileType javascript if exists("*JavaScriptFold")
                    \|             call JavaScriptFold()
                    \|         endif
        au FileType scheme if exists(":AutoCloseOff") == 2
                    \|         exec "AutoCloseOff"
                    \|     endif
        au FileType html set fo-=t
        au BufReadPost log.txt syn clear
                    \|         syn region Table start='{' end='}' contains=Table fold
                    \|         se fdc=5 fdm=syntax autoread

        if has("cscope")
            au VimLeave * cs kill -1
        endif

        " Don't screw up folds when inserting text that might affect them, until
        " leaving insert mode. Foldmethod is local to the window. Protect against
        " screwing up folding when switching between windows.
        autocmd InsertEnter *
                    \  if !exists('w:last_fdm')
                    \|     let w:last_fdm=&foldmethod | setlocal foldmethod=manual
                    \| endif
        autocmd InsertLeave,WinLeave *
                    \  if exists('w:last_fdm')
                    \|     let &l:foldmethod=w:last_fdm | unlet w:last_fdm
                    \| endif

    augroup END

    augroup NEOMAKE_ERL
        au!

        func! s:reg_tgame(path)
            for fn in glob(a:path.'/*', 0, 1)
                exec "au BufNewFile,BufRead "
                            \ substitute(fn.'/server/**/*.[he]rl', '\\', '/', 'g')
                            \ "let b:neomake_erlang_erlc_root='".fn."/server'" "|"
                            \ "let b:neomake_erlang_erlc_flags=["
                            \ "'-I', '".fn."/server']"
            endfor
        endfunc
        func! s:reg_im_erl(path)
            for fn in glob(a:path.'/im-erlang/*/', 0, 1)
                exec "au BufNewFile,BufRead "
                            \ substitute(fn.'**/*.[he]rl', '\\', '/', 'g')
                            \ "let b:neomake_erlang_erlc_root='".fn."' |"
                            \ "let b:neomake_erlang_erlc_extra_deps="
                            \ "[" "'".fn."/..', '".fn."/../im_common/deps/']"
            endfor
        endfunc
        if has('win32')
            call s:reg_tgame("C:/Devel/Projects/tgame/versions")
            call s:reg_tgame("Y:/Work")
            call s:reg_im_erl("Y:/Work/Projects")
        elseif has('mac')
            call s:reg_tgame("/Users/sw/Work/Code/tgame/versions")
        else
            call s:reg_tgame("/home/*/tgame/versions")
            call s:reg_im_erl("/home/*/Work/Projects")
            call s:reg_im_erl("/opt/work")
        end
    augroup END
endif
" Generic commands {{{2
if has("eval")

" Q for quit all {{{3
command! -bar Q qa!

" QfDo {{{3

fun! QFDo(bang, command)
     let qflist={}
     if a:bang
         let tlist=map(getloclist(0), 'get(v:val, ''bufnr'')')
     else
         let tlist=map(getqflist(), 'get(v:val, ''bufnr'')')
     endif
     if empty(tlist)
        echomsg "Empty Quickfixlist. Aborting"
        return
     endif
     for nr in tlist
     let item=fnameescape(bufname(nr))
     if !get(qflist, item,0)
         let qflist[item]=1
     endif
     endfor
     :exe 'argl ' .join(keys(qflist))
     :exe 'argdo ' . a:command
endfunc

com! -nargs=1 -bang Qfdo :call QFDo(<bang>0,<q-args>)


" EX, EV, EF, ES, EP {{{3

function! s:open_explorer(fname)
    let exec = has('win32') ? '!start explorer'  :
                \ has('mac') ? '!open -R' : '!nautilus'
    let fname = matchstr(glob(a:fname), '^\v.{-}\ze(\n|$)')

    if fname == ""
        let fname = "."
    endif
    if !isdirectory(fname)
        if has('win32')
            "exec exec '/select,'.iconv(fname, &enc, &tenc)
            exec exec '/select,'.fname
        elseif has('mac')
            exec exec iconv(fnamemodify(fname, ':p'), &enc, &tenc)
            call feedkeys("\<CR>")
        else
            exec exec iconv(fnamemodify(fname, ':h'), &enc, &tenc)
            call feedkeys("\<CR>")
        endif
    else
        "exec exec iconv(fname, &enc, &tenc)
        exec exec fname
    endif

    "call feedkeys("\n", 't')
endfunction

command! -nargs=* -complete=file EX call s:open_explorer(<q-args>)
command! EV EX $VIM
command! EF EX %:p

if exists('$VIMDIR')
    command! ES EX $VIMDIR
endif
if exists('$PRJDIR')
    command! EP EX $PRJDIR
endif

" VV GV {{{3

if has('win32')
    command! -nargs=* -complete=file VV exec "!start" v:progname <q-args>
    command! -nargs=* -complete=file VR exec "!start" v:progname <q-args>|qa!
    command! -nargs=* -complete=file VI !start vim <args>
    command! -nargs=* -complete=file VG !start gvim <args>
endif

" Full GUI {{{3

if g:gui_running
    let s:has_mt = glob("$VIM/_fullscreen") == "" &&
                \  glob("$VIM/vimfiles/_fullscreen") == "" &&
                \  glob("$HOME/.vim/_fullscreen") == ""
    if s:has_mt
        set go+=mT
    else
        set go-=m go-=T
    endif

    function! s:check_mt()
        if s:has_mt
            set go-=m go-=T
        else
            set go+=mT
        endif
        let s:has_mt = !s:has_mt
    endfunction

    command! -bar ToggleGUI call s:check_mt()

    map <F9> :<C-U>ToggleGUI<CR>
endif


" DarkRoom {{{3

if has('win32') && executable('vimtweak.dll')
    let s:tweak_SetAlpha = 255
    let s:tweak_Caption = 1
    let s:tweak_Maximize = 0
    let s:tweak_TopMost = 0
    let s:tweak_initialize = 0

    function! s:tweak(method, argv)
        if !s:tweak_initialize
            " a bug in Vista
            if system('ver') =~ ' 6.'
                silent! libcallnr('vimtweak.dll', 'EnableTopMost', 0)
            endif

            let s:tweak_initialize = 1
        endif

        let s:tweak_{a:method} = a:argv
        return libcallnr('vimtweak.dll', (a:method == 'SetAlpha' ? '' : 'Enable').
                    \ a:method, a:argv)
    endfunction

    command! -bar -nargs=1 -count=0 VimTweak call s:tweak(<q-args>, <count>)
    command! -bang -bar Darkroom SwitchCaption | SwitchMaximize
    for var in ['Caption', 'Maximize', 'TopMost']
        exec 'com! -bar Switch'.var.' exec !s:tweak_'.var.
                    \ '."VimTweak '.var.'"'
    endfor
    command! -bar SwitchAlpha if s:tweak_SetAlpha == 255|230SetAlpha
                \ |else|255SetAlpha|endif
    command! -bar -count=255 SetAlpha <count>VimTweak SetAlpha
    map <F10> :<C-U>SwitchMaximize<CR>
    imap <F10> <ESC><F10>a
    map <F11> :<C-U>SwitchAlpha<CR>
    imap <F11> <ESC><F11>a
    map <F12> :<C-U>Darkroom!<CR>
    imap <F12> <ESC><F12>a
endif

" AddTo, SoScript {{{3
if exists("$VIMDIR")

    command! -nargs=1 -complete=customlist,VimfilesDirComplete
                \ AddTo call rename(expand('%'),
                \ $VIMDIR.'/<args>/'.expand('%:t')) | checkt
    let Script_folder = 'script'
    command! -nargs=1 -complete=customlist,ScriptDirFileComplete
                \ SoScript exec 'so $VIMDIR/'.Script_folder.'/<args>'

    function! VimfilesDirComplete(ArgLead, ...)
        return map(filter(split(globpath($VIMDIR,
                    \ escape(a:ArgLead, '?*[').'*'), "\n"),
                    \ 'isdirectory(v:val)'),
                    \ 'fnamemodify(v:val, ":t")')
    endfunction

    function! ScriptDirFileComplete(ArgLead, ...)
        return map(split(globpath($VIMDIR.'/scripts',
                    \ escape(a:ArgLead, '?*[').'*'), "\n"),
                    \ 'fnamemodify(v:val, ":t")')
    endfunction
endif

" Add Linenumber {{{3

command! -bar -range=% LN
            \|silent <line1>,<line2>s/  /　/ge
            \|silent <line1>,<line2>s/^/\=printf(
            \           "|%0.*d| ", strlen(<line2>), line('.'))/ge
            \|silent! <line1>,<line2>yank *
            \|silent! undo
            \|let @/=""

command! -bar -range=% DLN
            \|silent <line1>,<line2>s/　/  /ge
            \|silent <line1>,<line2>s/^|\=\d\+\%(| \|:\)\=//ge
            \|nohl

" Font Size {{{3

let s:gf_pat = has('win32') || has('mac') ? 'h\zs\d\+' : '\d\+$'
command! -bar -count=10 FSIZE let &gfn = substitute(&gfn, s:gf_pat,
            \ <count>, '') | let &gfw = substitute(&gfw, s:gf_pat,
            \ <count>, '')

" }}}3

endif

" Generic maps {{{2

" cmdline edit key, emacs style {{{3

cnoremap <C-A> <Home>
cnoremap <C-E> <End>
cnoremap <C-F> <Right>
cnoremap <C-B> <Left>
cnoremap <C-N> <Down>
cnoremap <C-P> <Up>
cnoremap <M-F> <S-Right>
cnoremap <M-B> <S-Left>

" insert mode edit key, emacs style {{{3

"inoremap <C-A> <Home>
"inoremap <C-E> <End>
inoremap <C-F> <Right>
inoremap <C-B> <Left>
"inoremap <C-N> <Down>
"inoremap <C-P> <Up>
inoremap <M-F> <S-Right>
inoremap <M-B> <S-Left>

" clipboard operations {{{3
if has('eval')
    for op in ['y', 'Y', 'p', 'P']
        exec 'nmap z'.op.' "+'.op
        exec 'xmap z'.op.' "+'.op.'gv'
    endfor

    " inner buffer
    function! s:inner_buf()
        let line1 = nextnonblank(1)
        if line1 == 0
            " the buffer is blank, select it like with aa
            norm! ggVG
            return
        endif
        exec "norm!" line1."ggV". prevnonblank("$")."G"
    endfunc
    nor ii :<C-U>call <SID>inner_buf()<CR>
    nun ii| sunm ii

    " all buffer
    nor aa :<C-U>norm! ggVG<CR>
    nun aa| sunm aa

    " get Global
    nor gG :norm! ggVG<CR>
    sunm gG
    " Build buffer with zp
    nmap zB gGzp
    " get text zipped
    nmap gz zyaa``

    " set Y operator tp y$
    map Y y$
endif

" visual # and * operators {{{3

xnor<silent> # "sy?\V<C-R>=substitute(escape(@s, '\?'), '\n', '\\n', 'g')<CR><CR>
xnor<silent> * "sy/\V<C-R>=substitute(escape(@s, '\/'), '\n', '\\n', 'g')<CR><CR>

" window navigating/sizing {{{3

nmap <C-+> <C-W>+
nmap <C-,> <C-W><
nmap <C--> <C-W>-
nmap <C-.> <C-W>>
nmap <C-=> <C-W>=
xmap <C-+> <C-W>+
xmap <C-,> <C-W><
xmap <C--> <C-W>-
xmap <C-.> <C-W>>
xmap <C-=> <C-W>=

if has('eval')
    nmap Z8 :call <SID>wresize()<CR>

    function! s:wresize()
        if winwidth(0) < 80
            exec "norm 80\<C-W>|"
        endif

        if winheight(0) < 20
            exec "norm z20\<CR>"
        endif
    endfunction

else
    nmap Z8 80<C-W><BAR>z25<CR>
endif

xmap Z8 <ESC>Z8

" <leader># set buffer tabstop and sw and et

map <leader>1 :<C-U>setl ts=8 sw=4 et nu fdm=syntax fdc=2<CR>
map <leader>2 :<C-U>setl ts=4 sw=4 noet nu fdm=syntax fdc=2<CR>

" <leader>a filter {{{3

map <leader>a :!astyle -oO -snwpYHU --style=kr --mode=c<CR>

" <leader>c cd to current file folder {{{3

map <leader>cd :<C-U>cd %:h<CR>
map <leader>cw :<C-U>cd Y:/trunk/server<CR>
map <leader>c1 :<C-U>call feedkeys(":\<lt>C-U>cd Y:/1.\<lt>Tab>", 't')<CR>

" <leader>d diff get/put {{{3

map <leader>dd :<C-U>noh\|pcl\|ccl\|lcl<CR>
map <leader>dg :diffget
map <leader>dp :diffput
map <leader>du :diffupdate

" <leader>e explorer invoke {{{3

nmap <leader>ef :<C-U>vsp %:h<CR>
nmap <leader>ep :<C-U>vsp $VIMDOR<CR>
nmap <leader>es :<C-U>vsp $PRJDIR<CR>
nmap <leader>ev :<C-U>vsp $VIM<CR>
nmap <leader>ex :vsp .<CR>
xmap <leader>ex "ey:vsp <C-R>e<CR>

" <leader>f filetype settings {{{3
map <leader>f+ :<C-U>setf cpp<CR>
map <leader>fc :<C-U>setf c<CR>
map <leader>fC :<C-U>setf clojure<CR>
map <leader>fd :<C-U>setf dot<CR>
map <leader>fg :<C-U>setf go<CR>
map <leader>fh :<C-U>setf haskell<CR>
map <leader>fj :<C-U>setf java<CR>
map <leader>fl :<C-U>setf lua<CR>
map <leader>fL :<C-U>setf lisp<CR>
map <leader>fm :<C-U>setf markdown<CR>
map <leader>fM :<C-U>setf m4<CR>
map <leader>fP :<C-U>setf perl<CR>
map <leader>fp :<C-U>setf python<CR>
map <leader>fT :<C-U>setf tex<CR>
map <leader>fr :<C-U>setf rust<CR>
map <leader>fR :<C-U>setf rest<CR>
map <leader>fs :<C-U>setf scheme<CR>
map <leader>fT :<C-U>setf tcl<CR>
map <leader>ft :<C-U>setf text<CR>
map <leader>fv :<C-U>setf vim<CR>

" <leader>g get syntax stack {{{3
nmap<silent> <leader>g :echo ""<bar>for id in synstack(line('.'),col('.'))
            \\|echo synIDattr(id, "name")
            \\|endfor<CR>

" <leader>hjkl window navigating and moving {{{3

nmap <leader>h <C-W>h
nmap <leader>j <C-W>j
nmap <leader>k <C-W>k
nmap <leader>l <C-W>l
nmap <leader>H <C-W>H
nmap <leader>J <C-W>J
nmap <leader>K <C-W>K
nmap <leader>L <C-W>L

" <leader>q quickfix error jumps {{{3

map <leader>qj :<C-U>cn!<CR>
map <leader>qk :<C-U>cp!<CR>

" <leader>r run current line {{{3

" vimrc edit
if has("win32")
    map <leader>re :drop $VIM/vimfiles/_vimrc<CR>
    map <leader>rr :so $VIM/vimfiles/_vimrc<CR>
else
    map <leader>re :drop $MYVIMRC<CR>
    map <leader>rr :so $MYVIMRC<CR>
endif

nmap <leader>rc :exec getline('.')[col('.')-1:]<CR>
xmap <leader>rc y:exec @"<CR>
nmap <leader>rv :echo eval(getline('.'))[col('.')-1:]<CR>
xmap <leader>rv y:echo eval(@")<CR>

" <leader>t terminal {{{3

if v:version >= 801
    map <leader>t :<C-U>terminal<CR>
elseif has('mac')
    map <leader>t :<C-U>!open -a iterm<CR>:call feedkeys("\<lt>CR>")<CR>
elseif !has('win32')
    map <leader>t :<C-U>!gnome-terminal &<CR>:call feedkeys("\<lt>CR>")<CR>
elseif executable('sh.exe')
    map <leader>t :<C-U>!start sh.exe --login -i<CR>
else
    map <leader>t :<C-U>!start cmd.exe<CR>
endif

" <leader>v vim invoke {{{3

if has('eval')
    function! s:get_restart_arg()
        if has('win32')
            let cmdline = '!start '.v:progname.' -c "cd '
        else
            let cmdline = '!'.v:progname.' -c "cd '
            call feedkeys("\<CR>")
        end
        if exists(":NERDTreeToggle") == 2
            return cmdline.fnameescape(getcwd()).'|NERDTreeToggle|wincmd l"'
        else
            return cmdline.fnameescape(getcwd()).'"'
        endif
    endfunction
    map <leader>vn :<C-U>exec <SID>get_restart_arg()<CR>
    map <leader>vr :<C-U>exec <SID>get_restart_arg()<BAR>qa!<CR>
    if has('win32')
        map <leader>vi :<C-U>!start gvim<CR>
    else
        map <leader>vi :<C-U>!gvim<CR><CR>
    end
end

" }}}3

" }}}2
" ----------------------------------------------------------
" plugin settings {{{1
if has('eval')

" vim-plug {{{2

filetype off

if has("win32")
    call plug#begin("$VIM/vimfiles/bundle")
else
    call plug#begin("~/.vim/bundle")
endif


if exists(':Plug')

" Plug 'flazz/vim-colorschemes'

Plug 'asins/vimcdoc'       " chinese document
"Plug 'mhinz/vim-signify'   " show difference
Plug 'neomake/neomake'     " live lint/build
Plug 'metakirby5/codi.vim' " on-the-fly coding
"Plug 'luochen1990/rainbow'
Plug 'andymass/vim-matchup'
"Plug 'roman/golden-ratio'

if has('terminal')
    Plug 'Shougo/deol.nvim'
endif

"if v:version >= 801
"    if has('win32')
"        Plug 'neoclide/coc.nvim', {'tag': '*', 'do': './install.bat'}
"    else
"        Plug 'neoclide/coc.nvim', {'tag': '*', 'do': './install.sh'}
"    endif
"else
"    Plug 'w0rp/ale'
"endif

" textobj
Plug 'junegunn/vim-easy-align'
Plug 'kana/vim-textobj-function', { 'for':['c', 'cpp', 'vim', 'java'] }
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-syntax'
Plug 'kana/vim-textobj-user'
Plug 'sgur/vim-textobj-parameter'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'AndrewRadev/splitjoin.vim'

if !has('win32') && executable("fzf")
    if isdirectory('/usr/local/opt/fzf')
        Plug '/usr/local/opt/fzf'
    else
        let fzf_dir = system('which fzf')
        let fzf_dir = simplify(fnamemodify(fzf_dir, ':p:h') . "/..")
        let fzf_dir = "'".fzf_dir."'"
        exec 'Plug' fzf_dir
    endif
    Plug 'junegunn/fzf.vim'
    Plug 'tweekmonster/fzf-filemru'
    "Plug 'pbogut/fzf-mru.vim'
else
    Plug 'ctrlpvim/ctrlp.vim'
endif

Plug 'rhysd/vim-clang-format'
Plug 'Konfekt/FoldText'
Plug 'Raimondi/delimitMate'
Plug 'dyng/ctrlsf.vim'
Plug 'easymotion/vim-easymotion'
Plug 'ervandew/supertab'
Plug 'fidian/hexmode'
Plug 'godlygeek/tabular'
Plug 'itchyny/calendar.vim'
Plug 'mbbill/echofunc'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'terryma/vim-multiple-cursors'
Plug 'triglav/vim-visual-increment'
Plug 'vim-airline/vim-airline'
Plug 'Chiel92/vim-autoformat'

" Language-spec
Plug 'sheerun/vim-polyglot'

if has('python') || has('python3')
    Plug 'Shougo/vinarise.vim'
    Plug 'SirVer/ultisnips'
    Plug 'sjl/gundo.vim'
else
    Plug 'MarcWeber/vim-addon-mw-utils'
    Plug 'tomtom/tlib_vim'
    Plug 'garbas/vim-snipmate'
endif

if has('nvim')
    Plug 'equalsraf/neovim-gui-shim'
    Plug 'dzhou121/gonvim-fuzzy'
endif

if has('lua')
    Plug 'Shougo/neocomplete.vim' " need Lua
    " Plug 'Konfekt/FastFold' " depend by neocomplete
endif

if has("mac")
    Plug 'ybian/smartim'
endif

Plug 'honza/vim-snippets' " snippets


call plug#end()
endif
filetype plugin indent on


" 2html {{{2

let html_dynamic_folds = 1
let html_ignore_conceal = 1
let html_no_pre = 1
let html_use_css = 1

" airline {{{2

let g:airline_powerline_fonts = 1
"let g:airline_symbols_ascii=1

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#buffer_nr_format = '%s: '
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nmap <leader>- <Plug>AirlineSelectPrevTab
nmap <leader>= <Plug>AirlineSelectNextTab

let g:airline#extensions#tabline#buffer_idx_format = {
            \ '0': '0 ',
            \ '1': '1 ',
            \ '2': '2 ',
            \ '3': '3 ',
            \ '4': '4 ',
            \ '5': '5 ',
            \ '6': '6 ',
            \ '7': '7 ',
            \ '8': '8 ',
            \ '9': '9 '
            \}

let g:airline_mode_map = {
            \ '__' : '-',
            \ 'n'  : 'N',
            \ 'i'  : 'I',
            \ 'R'  : 'R',
            \ 'c'  : 'C',
            \ 'v'  : 'V',
            \ 'V'  : 'VL',
            \ '' : 'VB',
            \ 's'  : 'S',
            \ 'S'  : 'SL',
            \ '' : 'SB',
            \ 't'  : 'T',
            \ }

" ale {{{2

"let g:ale_linters_explicit = 1
let g:ale_completion_delay = 500
let g:ale_echo_delay = 20
let g:ale_lint_delay = 500
let g:ale_echo_msg_format = '[%linter%] %code: %%s'
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:airline#extensions#ale#enabled = 1

let g:ale_c_gcc_options = '-Wall -O2 -std=c99'
let g:ale_cpp_gcc_options = '-Wall -O2 -std=c++14'
let g:ale_c_cppcheck_options = ''
let g:ale_cpp_cppcheck_options = ''

" calendar {{{2

for dir in ['~', $VIM, $VIM.'/..', $PRJDIR, $PRJDIR.'/..']
    if isdirectory(dir.'/diary')
        let g:calendar_diary = s:globfirst(dir.'/diary')
        break

    elseif isdirectory(dir.'/Diary')
        let g:calendar_diary = s:globfirst(dir.'/Diary')
        break
    endif
endfor

let g:calendar_focus_today = 1

nmap <leader>da <leader>cal<CR>Go<CR><C-R>=strftime("%Y-%m-%d %H:%M:%S")<CR><CR>
nmap <leader>DA <leader>caL<CR>Go<CR><C-R>=strftime("%Y-%m-%d %H:%M:%S")<CR><CR>
xmap <leader>da "dy<leader>da<BS> - 摘要：<CR><ESC>"dP
xmap <leader>DA "dy<leader>DA<BS> - 摘要：<CR><ESC>"dP

" clang-format {{{2

if executable('clang-format')
let g:clang_format#style_options = {
            \ "AccessModifierOffset": -4,
            \ "AlignConsecutiveAssignments": v:true,
            \ "AlignEscapedNewlines": "Left",
            \ "AlignOperands": v:true,
            \ "AllowShortLoopsOnASingleLine": v:false,
            \ "AlignTrailingComments": v:true,
            \ "Standard" : "C++11" }

onoremap = :ClangFormat<CR>
vnoremap = :ClangFormat<CR>
nmap <Leader>S :ClangFormatAutoToggle<CR>

endif

" ctk {{{2

amenu 1.246 ToolBar.BuiltIn25 :CC<CR>
tmenu ToolBar.BuiltIn25 CTK Compile
amenu 1.247 ToolBar.BuiltIn15 :RUN<CR>
tmenu ToolBar.BuiltIn15 CTK Run
amenu 1.248 ToolBar.-sep5-1- <Nop>


" ctrlp {{{2
if has_key(g:plugs, "ctrlp.vim")

nnoremap <silent> <expr> <Leader><Leader> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":CtrlP\<cr>"
nnoremap <silent> <Leader><Enter>  :<C-U>CtrlPBuffer<CR>
nnoremap <leader>B :<C-U>CtrlPBuffer<CR>
nnoremap <leader>C :<C-U>CtrlPCurFile<CR>
nnoremap <leader>F :<C-U>CtrlP<CR>
nnoremap <leader>M :<C-U>CtrlPMRU<CR>
nnoremap <leader>T :<C-U>CtrlPTag<CR>
nnoremap <leader>W :call <SID>tagsUnderCursor()<CR>
nmap <F1> :<C-U>CtrlPBuffer<CR>
nmap <F2> :<C-U>CtrlPMRU<CR>
nmap <F3> :<C-U>CtrlPTag<CR>
nmap <F4> :<C-U>CtrlP<CR>
imap <F1> <C-\><C-N><F1>
imap <F2> <C-\><C-N><F2>
imap <F3> <C-\><C-N><F3>
imap <F4> <C-\><C-N><F4>


function! <SID>tagsUnderCursor()
    try
        let default_input_save = get(g:, 'ctrlp_default_input', '')
        let g:ctrlp_default_input = expand('<cword>')
        CtrlPBufTagAll
    finally
        if exists('default_input_save')
            let g:ctrlp_default_input = default_input_save
        endif
    endtry
endfunction


set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.png,*.jpg,*.jpeg,*.gif " MacOSX/Linux
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_map = '<c-p>'
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/].(git|hg|svn|rvm)$',
    \ 'file': '\v.(exe|so|dll|zip|tar|tar.gz|pyc|beam)$',
    \ }

" Use fd for ctrlp.
if executable('fd')
    let g:ctrlp_user_command = 'fd -c never "" %s'
    "let g:ctrlp_use_caching = 0

elseif executable('rg')
    let g:ctrlp_user_command = 'rg %s -g "!*.beam" -g "!*.html" -g "!*.prof_output" --files'
    "let g:ctrlp_use_caching = 0

elseif executable('ag')
    let g:ctrlp_user_command = 'ag %s -l --nocolor'
    "let g:ctrlp_use_caching = 0
endif

endif
" delimitMate {{{2

let g:delimitMate_expand_space = 1
let g:delimitMate_expand_cr    = 2
let g:delimitMate_jump_expansion = 0


" EasyAlign {{{2

" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. ,=ip)
nmap <leader>a <Plug>(EasyAlign)

let g:easy_align_delimiters = {
            \ 's': { 'pattern': '::' },
            \ '<': { 'pattern': '<<\|<=\|<-\|<' },
            \ '>': { 'pattern': '>>\|=>\|->\|>' },
            \ '/': {
            \     'pattern':         '//\+\|/\*\|\*/',
            \     'delimiter_align': 'l',
            \     'ignore_groups':   ['!Comment'] },
            \ ']': {
            \     'pattern':       '[[\]]',
            \     'left_margin':   0,
            \     'right_margin':  0,
            \     'stick_to_left': 0
            \   },
            \ ')': {
            \     'pattern':       '[()]',
            \     'left_margin':   0,
            \     'right_margin':  0,
            \     'stick_to_left': 0
            \   },
            \ 'd': {
            \     'pattern':      ' \(\S\+\s*[;=]\)\@=',
            \     'left_margin':  0,
            \     'right_margin': 0
            \   }
            \ }

" EasyMotion {{{2

map <Leader>m <Plug>(easymotion-prefix)

" EasyVim {{{2

if &insertmode
    run! evim.vim
endif

" FoldText {{{2

set foldmethod=syntax

" { Syntax Folding
  let g:vimsyn_folding='af'
  let g:tex_fold_enabled=1
  let g:xml_syntax_folding = 1
  let g:clojure_fold = 1
  let ruby_fold = 1
  let perl_fold = 1
  let perl_fold_blocks = 1
" }

set foldenable
set foldlevel=0
set foldlevelstart=0
" specifies for which commands a fold will be opened
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo

nnoremap <silent> za za:<c-u>setlocal foldlevel?<CR>

nnoremap <silent> zr zr:<c-u>setlocal foldlevel?<CR>
nnoremap <silent> zm zm:<c-u>setlocal foldlevel?<CR>

nnoremap <silent> zR zR:<c-u>setlocal foldlevel?<CR>
nnoremap <silent> zM zM:<c-u>setlocal foldlevel?<CR>

" Change Option Folds
nnoremap zi  :<c-u>call <SID>ToggleFoldcolumn(1)<CR>
nnoremap coz :<c-u>call <SID>ToggleFoldcolumn(0)<CR>
nmap     cof coz

function! s:ToggleFoldcolumn(fold)
  if &foldcolumn
    let w:foldcolumn = &foldcolumn
    silent setlocal foldcolumn=0
    if a:fold | silent setlocal nofoldenable | endif
  else
      if exists('w:foldcolumn') && (w:foldcolumn!=0)
        silent let &l:foldcolumn=w:foldcolumn
      else
        silent setlocal foldcolumn=4
      endif
      if a:fold | silent setlocal foldenable | endif
  endif
  setlocal foldcolumn?
endfunction

" fzf {{{2
if has_key(g:plugs, "fzf.vim")

" nnoremap <silent> <Leader><Leader> :Files<CR>
nnoremap <silent> <C-P> :<C-U>Files<CR>
nnoremap <silent> <expr> <Leader><Leader> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":Files\<cr>"
nnoremap <silent> <Leader><Enter>  :<C-U>Buffers<CR>
nnoremap <silent> <Leader>B        :<C-U>Buffers<CR>
nnoremap <silent> <Leader>C        :<C-U>Colors<CR>
nnoremap <silent> <Leader>F        :<C-U>Files<CR>
nnoremap <silent> <Leader>L        :<C-U>Lines<CR>
nnoremap <silent> <Leader>M        :<C-U>FilesMru<CR>
nnoremap <silent> <Leader>T        :<C-U>Tags<CR>
"nnoremap <silent><expr> <Leader>W  ":<C-U>BTags ".expand('<cword>')."<CR>"
nnoremap <silent><expr> <Leader>W  ":<C-U>Tags ".expand('<cword>')."<CR>"
nnoremap <silent> <Leader>`        :<C-U>Marks<CR>
nmap <F1> :<C-U>Buffers<CR>
nmap <F2> :<C-U>FilesMru<CR>
nmap <F3> :<C-U>Tags<CR>
nmap <F4> :<C-U>Files<CR>
imap <F1> <C-\><C-N><F1>
imap <F2> <C-\><C-N><F2>
imap <F3> <C-\><C-N><F3>
imap <F4> <C-\><C-N><F4>

if executable('rg')
    nnoremap <silent> <Leader>R        :Rg <C-R><C-W><CR>
    nnoremap <silent> <Leader>R        :Rg <C-R><C-A><CR>
    xnoremap <silent> <Leader>R        y:Rg <C-R>"<CR>
elseif executable('ag')
    nnoremap <silent> <Leader>R        :Ag <C-R><C-W><CR>
    nnoremap <silent> <Leader>R        :Ag <C-R><C-A><CR>
    xnoremap <silent> <Leader>R        y:Ag <C-R>"<CR>
endif

" nnoremap <silent> q: :History:<CR>
" nnoremap <silent> q/ :History/<CR>

inoremap <expr> <c-x><c-t> fzf#complete('tmuxwords.rb --all-but-current --scroll 500 --min 5')
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
inoremap <expr> <c-x><c-d> fzf#vim#complete#path('blsd')
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" nmap <leader><tab> <plug>(fzf-maps-n)
" xmap <leader><tab> <plug>(fzf-maps-x)
" omap <leader><tab> <plug>(fzf-maps-o)

if has('nvim') || has('gui_running')
  let $FZF_DEFAULT_OPTS .= ' --inline-info'
endif

" Hide statusline of terminal buffer
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

function! s:plug_help_sink(line)
  let dir = g:plugs[a:line].dir
  for pat in ['doc/*.txt', 'README.md']
    let match = get(split(globpath(dir, pat), "\n"), 0, '')
    if len(match)
      execute 'tabedit' match
      return
    endif
  endfor
  tabnew
  execute 'Explore' dir
endfunction

command! PlugHelp call fzf#run(fzf#wrap({
  \ 'source': sort(keys(g:plugs)),
  \ 'sink':   function('s:plug_help_sink')}))

endif
" indent guide {{{2

let g:indent_guides_guide_size=1


" Lua {{{2

if exists('$QUICK_V3_ROOT')
    let g:lua_path = $QUICK_V3_ROOT."quick/cocos/?.lua;".
                   \ $QUICK_V3_ROOT."quick/cocos/?/init.lua;".
                   \ $QUICK_V3_ROOT."quick/framework/?.lua;".
                   \ $QUICK_V3_ROOT."quick/framework/?/init.lua;".
                   \ $LUA_PATH

    if has('lua')
        silent! lua package.path=vim.eval('g:lua_path')..';'..package.path
    endif
endif

"let lua_complete_keywords = 1
"let lua_complete_globals = 1
"let lua_complete_library = 1
"let lua_complete_dynamic = 1
let lua_complete_omni = 0



" multiple-cursors  {{{2

let g:multi_cursor_exit_from_insert_mode = 0
let g:multi_cursor_exit_from_visual_mode = 0

if has("mac")
    function! Multiple_cursors_before()
        let g:smartim_disable = 1
    endfunction
    function! Multiple_cursors_after()
        unlet g:smartim_disable
    endfunction
end


" neocomplete {{{2

let g:neocomplete#enable_at_startup = 1
let g:neocomplete#data_directory = s:tprefix . "/swapfiles/neocomplete"

" Called once right before you start selecting multiple cursors
function! Multiple_cursors_before()
  if exists(':NeoCompleteLock')==2
    exe 'NeoCompleteLock'
  endif
endfunction

" Called once only when the multiple selection is canceled (default <Esc>)
function! Multiple_cursors_after()
  if exists(':NeoCompleteUnlock')==2
    exe 'NeoCompleteUnlock'
  endif
endfunction

" neomake {{{2

" When reading a buffer (after 1s), and when writing (no delay).
silent!  call neomake#configure#automake('rw', 1000)

if has('win32') || !g:gui_running

let g:neomake_error_sign = {'text': 'E>', 'texthl': 'NeomakeErrorSign'}
let g:neomake_warning_sign = {
            \   'text': 'W>',
            \   'texthl': 'NeomakeWarningSign',
            \ }
let g:neomake_message_sign = {
            \   'text': 'M>',
            \   'texthl': 'NeomakeMessageSign',
            \ }
let g:neomake_info_sign = {'text': 'I>', 'texthl': 'NeomakeInfoSign'}

endif

if !exists('g:neomake_erlang_erlc_target_dir')
    let g:neomake_erlang_erlc_target_dir = tempname()
endif

function! Neomake_Erlang_GlobPaths() abort
    " Find project root directory.
    let root = get(b:, 'neomake_erlang_erlc_root',
             \ get(g:, 'neomake_erlang_erlc_root'))
    if empty(root)
        let rebar_config = neomake#utils#FindGlobFile('rebar.config')
        if !empty(rebar_config)
            let root = fnamemodify(rebar_config, ':h')
        else
            " At least try with CWD
            let root = getcwd()
        endif
    endif
    let root = fnamemodify(root, ':p')
    let build_dir = root . '_build'
    let ebins = []
    if isdirectory(build_dir)
        " Pick the rebar3 profile to use
        let default_profile = expand('%') =~# '_SUITE.erl$' ?  'test' : 'default'
        let profile = get(b:, 'neomake_erlang_erlc_rebar3_profile', default_profile)
        let ebins += neomake#compat#glob_list(build_dir . '/' . profile . '/lib/*/ebin')
        let target_dir = build_dir . '/neomake'
    else
        let target_dir = get(b:, 'neomake_erlang_erlc_target_dir',
                       \ get(g:, 'neomake_erlang_erlc_target_dir'))
    endif
    " If <root>/_build doesn't exist it might be a rebar2/erlang.mk project
    if isdirectory(root . 'deps')
        let ebins += neomake#compat#glob_list(root . 'deps/*/ebin')
    endif
    " Set g:neomake_erlang_erlc_extra_deps in a project-local .vimrc, e.g.:
    "   let g:neomake_erlang_erlc_extra_deps = ['deps.local']
    " Or just b:neomake_erlang_erlc_extra_deps in a specific buffer.
    let extra_deps_dirs = get(b:, 'neomake_erlang_erlc_extra_deps',
                        \ get(g:, 'neomake_erlang_erlc_extra_deps'))
    if !empty(extra_deps_dirs)
        for extra_deps in extra_deps_dirs
            if extra_deps[-1] !=# '/'
                let extra_deps .= '/'
            endif
            let ebins += neomake#compat#glob_list(extra_deps . '*/ebin')
        endfor
    endif
    let args = ['-pa', 'ebin', '-I', 'include', '-I', 'src']
    for ebin in ebins
        let args += [ '-pa', ebin,
                    \ '-I', substitute(ebin, 'ebin$', 'include', '') ]
    endfor
    let args += get(b:, 'neomake_erlang_erlc_flags',
              \ get(g:, 'neomake_erlang_erlc_flags', []))
    if !isdirectory(target_dir)
        call mkdir(target_dir, 'p')
    endif
    let args += ['-o', target_dir]
    return args
endfunction

function! s:neomake_Erlang_InitForJob(jobinfo) abort dict
    let args = Neomake_Erlang_GlobPaths()
    let self.args = args
endfunction

silent!  call neomake#config#set('ft.erlang.InitForJob',
            \ function('s:neomake_Erlang_InitForJob'))


" Neovim {{{2

function! g:NvimGUISetting()
    let g:gui_running = 1
    if exists(':GuiFont')
        GuiFont Monaco for Powerline:h16
        let g:airline_powerline_fonts = 1
        "GuiLinespace 8
    endif
    colorscheme kaltex
endfunction

if has('nvim')
    call NvimGUISetting()
endif

" NERDTree {{{2

nmap <leader>nn :NERDTreeToggle<CR>
xmap <leader>nn :<C-U>NERDTreeToggle<CR>
map <leader>nf :<C-U>NERDTree %:h<CR>
map <leader>np :<C-U>NERDTree $VIMDOR<CR>
map <leader>ns :<C-U>NERDTree $PRJDIR<CR>
map <leader>nv :<C-U>NERDTree $VIM<CR>
nmap <leader>nx :NERDTree .<CR>
xmap <leader>nx "ey:NERDTree <C-R>e<CR>

" omnicppcomplete {{{2

let g:OmniCpp_GlobalScopeSearch = 1  " 0 or 1
let g:OmniCpp_NamespaceSearch = 1   " 0 ,  1 or 2
let g:OmniCpp_DisplayMode = 1
let g:OmniCpp_ShowScopeInAbbr = 0
let g:OmniCpp_ShowPrototypeInAbbr = 1
let g:OmniCpp_ShowAccess = 1
let g:OmniCpp_MayCompleteDot = 1
let g:OmniCpp_MayCompleteArrow = 1
let g:OmniCpp_MayCompleteScope = 1


" perl {{{2

let g:perl_fold = 1

" rainbow {{{2

let g:rainbow_active = 1

" smartim {{{2

let g:smartim_default = "com.apple.keylayout.ABC"

" supertab {{{2

let g:SuperTabDefaultCompletionType = "<C-N>"
let g:SuperTabNoCompleteAfter = [ '^', ',', '\s' ]
"let g:SuperTabCrMapping = 0 " incompatible with autopairs/delimitMate
"let g:SuperTabLongestEnhanced = 1
"let g:SuperTabLongestHighlight = 1

" surround {{{2

let g:surround_{char2nr("c")} = "/* \r */"


" UltiSnips {{{2

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger = '<Tab>'
let g:UltiSnipsListSnippets = '<C-Tab>'
let g:UltiSnipsJumpForwardTrigger = '<Tab>'
let g:UltiSnipsJumpBackwardTrigger = '<S-Tab>'

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

let g:UltiSnipsSnippetDirectories=['UltiSnips']

if has('win32')
    let g:UltiSnipsSnippetsDir = expand("$VIM/vimfiles/UltiSnips")
else
    let g:UltiSnipsSnippetsDir = expand("~/.vim/UltiSnips")
endif


" zip {{{2
let g:loaded_zipPlugin= 1
let g:loaded_zip      = 1

" }}}2

endif

if exists('s:cpo_save')
    let &cpo = s:cpo_save
    unlet s:cpo_save
endif

" }}}1
" vim: set ft=vim ff=unix fdm=marker ts=8 sw=4 et sta nu:
