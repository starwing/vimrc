" ==========================================================
" File Name:    vimrc
" Author:       StarWing
" Version:      0.5 (1722)
" Last Change:  2012-05-11 12:05:12
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
endif
set cpo&vim " set cpo-=C cpo-=b

" generic Settings {{{2

set ambiwidth=double
set bsdir=buffer
set complete-=i
set completeopt=longest,menu
set diffopt+=vertical
set display=lastline
set fileencodings=ucs-bom,utf-8,cp936,gb18030,latin1
set formatoptions+=mB2
set helplang=cn
set history=1000
set modeline " for debian.vim, changed the initial value
set shiftwidth=4
set softtabstop=4
set tags=./tags,tags,./tags;
set tabstop=8
set textwidth=70
set viminfo+=!
set virtualedit=block
set wildcharm=<C-Z>
set wildmenu

" new in Vim 7.3 {{{2

if v:version >= 703 && has('persistent_undo')
    set undofile
endif


" titlestring & statusline {{{2

set titlestring=%f%(\ %m%h%r%)\ -\ StarWing's\ Vim:\ %{v:servername}
set laststatus=2
set statusline=
set statusline+=%2*%-3.3n%0*\  " buffer number
set statusline+=%f\  " file name
set statusline+=%1*%h%m%r%w%0* " flag
set statusline+=[

if v:version >= 600
    set statusline+=%{&ft!=''?&ft:'noft'}, " filetype
    set statusline+=%{&fenc!=''?&fenc:&enc}, " fileencoding
endif

set statusline+=%{&fileformat}] " file format
set statusline+=%= " right align
"set statusline+=%2*0x%-8B\  " current char
set statusline+=0x%-8B\  " current char
set statusline+=%-14.(%l,%c%V%)\ %<%P " offset

if globpath(&rtp, "plugin/vimbuddy.vim") != ''
    set statusline+=\ %{VimBuddy()} " vim buddy
endif

" helplang {{{2
if v:version >= 603
    set helplang=cn
endif

" diffexpr {{{2
if has('eval')
    set diffexpr=rc:my_diff('diff')

    function! rc:my_diff(cmd)
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

if has('gui_running') " {{{2
    set go=er co=120 lines=35
    "set co=120 lines=35

    if has('win32')
        silent! set gfn=Consolas:h10:cANSI
        "silent! set gfw=YaHei_Consolas_Hybrid:h10:cGB2312
        exec 'set gfw='.iconv('新宋体', 'utf8', 'gbk').':h10:cGB2312'
    else
        "set gfn=Consolas\ 10 gfw=WenQuanYi\ Bitmap\ Song\ 10
        set gfn=Monospace\ 9
    endif
    "silent! colorscheme kaltex
    silent! colorscheme evening

else " in terminal {{{2
    "silent! colorscheme kaltex
    silent! colorscheme evening
endif " }}}2
if has("win32") " {{{2
    if $LANG =~? 'zh_CN' && &encoding !=? "cp936"
        set termencoding=cp936

        lang mes zh_CN.UTF-8

        set langmenu=zh_CN.UTF-8
        silent! so $VIMRUNTIME/delmenu.vim
        silent! so $VIMRUNTIME/menu.vim
    endif


elseif has('unix') " {{{2
    if &term == 'linux'
        " lang C
    endif
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
if v:version >= 703 && isdirectory($VIM.'/swapfiles/undofiles')
    let &undodir=s:tprefix."/swapfiles/undofiles,."
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
        let s:tools = [['git',      'git/bin'          ],
                    \  ['minsys',   'minSYS/bin'       ],
                    \  ['mingw',    'minSYS/mingw/bin' ],
                    \  ['lua',      'Lua'              ],
                    \  ['perl',     'perl/perl/bin'    ],
                    \  ['python',   'Python'           ]]
        for [name, path] in s:tools
            if !isdirectory($VIM.'/../'.$TOOLS) | continue | endif

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

    " $PRJDIR {{{3

    for dir in ['~', '~/..', $VIM, $VIM.'/..', $VIM.'/../..', $WORK]
        for name in ['prj', 'Project', 'Code']
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
        au BufWritePre $MYVIMRC silent call s:vimrc_write()
        au BufReadPost * if getfsize(expand('%')) < 50000 | syn sync fromstart | endif
        "au BufWritePre * let &backup = (getfsize(expand('%')) > 500000)
        au BufNewFile,BufRead *.vba set noml
        au FileType dot,lua,haskell,m4,perl,python,ruby,scheme,vim
                    \ setg sw=4 ts=8 sts=4 et sta nu fdc=2 fo-=t
        au FileType scheme if exists(":AutoCloseOff") == 2
                    \|         exec "AutoCloseOff"
                    \|     endif
        au FileType html set fo-=t
        au BufReadPost log.txt syn clear
                    \|         syn region Table start='{' end='}' contains=Table fold
                    \|         se fdc=5 fdm=syntax

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
    let exec = has('win32') ? '!start explorer' : '!nautilus'
    let fname = matchstr(glob(a:fname), '^\v.{-}\ze(\n|$)')

    if fname == ""
        let fname = "."
    endif
    if !isdirectory(fname)
        if has('win32')
            exec exec '/select,'.iconv(fname, &enc, &tenc)
        else
            exec exec iconv(fnamemodify(fname, ':h'), &enc, &tenc)
        endif
    else
        exec exec iconv(fname, &enc, &tenc)
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
    command! -bar SwitchAlpha if s:tweak_SetAlpha == 255|200SetAlpha
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
" Font Size {{{3

let s:gf_pat = has('win32') ? 'h\zs\d\+' : '\d\+$'
command! -bar -count=10 FSIZE let &gfn = substitute(&gfn, s:gf_pat,
            \ <count>, '') | let &gfw = substitute(&gfw, s:gf_pat,
            \ <count>, '')

" }}}3

endif

" Generic maps {{{2

" explorer invoke {{{3

map <leader>ef :<C-U>vsp %:h<CR>
map <leader>ep :<C-U>vsp $VIMDOR<CR>
map <leader>es :<C-U>vsp $PRJDIR<CR>
map <leader>ev :<C-U>vsp $VIM<CR>
nmap <leader>ex :vsp .<CR>
xmap <leader>ex "ey:vsp <C-R>e<CR>

" vim invoke {{{3

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
    map <leader>vv :<C-U>exec <SID>get_restart_arg()<CR>
    map <leader>vr :<C-U>exec <SID>get_restart_arg()<BAR>qa!<CR>
    map <leader>vi :<C-U>!start vim<CR>
    map <leader>vg :<C-U>!start gvim<CR>
end

" cd to current file folder {{{3

map <leader>cd :<C-U>cd %:h<CR>

" cmdline edit key, emacs style {{{3

nnoremap <Space> :
xnoremap <Space> :

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

" filetype settings {{{3
map <leader>f+ :<C-U>setf cpp<CR>
map <leader>fc :<C-U>setf c<CR>
map <leader>fd :<C-U>setf dot<CR>
map <leader>fh :<C-U>setf haskell<CR>
map <leader>fj :<C-U>setf java<CR>
map <leader>fl :<C-U>setf lua<CR>
map <leader>fL :<C-U>setf lisp<CR>
map <leader>fm :<C-U>setf markdown<CR>
map <leader>fM :<C-U>setf m4<CR>
map <leader>fP :<C-U>setf perl<CR>
map <leader>fp :<C-U>setf python<CR>
map <leader>fT :<C-U>setf tex<CR>
map <leader>fr :<C-U>setf rest<CR>
map <leader>fs :<C-U>setf scheme<CR>
map <leader>ft :<C-U>setf text<CR>
map <leader>fv :<C-U>setf vim<CR>

" filter {{{3

map <leader>as :!astyle -oO -snwpYHU --style=kr --mode=c<CR>

" run current line {{{3
nmap <leader>rc :exec getline('.')[col('.')-1:]<CR>
xmap <leader>rc y:exec @"<CR>
nmap <leader>ec :echo eval(getline('.'))[col('.')-1:]<CR>
xmap <leader>ec y:echo eval(@")<CR>

" get syntax stack {{{3
nmap<silent> <leader>gs :echo ""<bar>for id in synstack(line('.'),col('.'))
            \\|echo synIDattr(id, "name")
            \\|endfor<CR>

" vimrc edit {{{3
map <leader>re :drop $MYVIMRC<CR>
map <leader>rr :so $MYVIMRC<CR>

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
    " Build buffer with zip
    nmap zB gGzp
    " get text zipped
    nmap gz zyaa``

    " set Y operator tp y$
    map Y y$
endif

" indent {{{3

xmap > >gv
xmap < <gv
nmap g= gg=G
xmap g= gg=G

" quickfix error jumps {{{3

map <leader>qj :<C-U>cn!<CR>
map <leader>qk :<C-U>cp!<CR>

" quick complete (against supertab) {{{3

inor <m-n> <c-n>
inor <m-p> <c-p>

" vi?sual # and * operators {{{3

xnor<silent> # "sy?\V<C-R>=substitute(escape(@s, '\?'), '\n', '\\n', 'g')<CR><CR>
xnor<silent> * "sy/\V<C-R>=substitute(escape(@s, '\/'), '\n', '\\n', 'g')<CR><CR>

" redo {{{3

map <m-r> <c-r>

" diff get/put {{{3

map <leader>dg :diffget
map <leader>dp :diffput
map <leader>du :diffupdate

" window navigating {{{3

nmap <C-+> <C-W>+
nmap <C-,> <C-W><
nmap <C--> <C-W>-
nmap <C-.> <C-W>>
nmap <C-=> <C-W>=
nmap <C-h> <C-W>h
nmap <C-j> <C-W>j
nmap <C-k> <C-W>k
nmap <C-l> <C-W>l
xmap <C-+> <C-W>+
xmap <C-,> <C-W><
xmap <C--> <C-W>-
xmap <C-.> <C-W>>
xmap <C-=> <C-W>=
xmap <C-h> <C-W>h
xmap <C-j> <C-W>j
xmap <C-k> <C-W>k
xmap <C-l> <C-W>l

" window resizing {{{3

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
map <M-j> <C-j>Z8
map <M-k> <C-k>Z8
map <M-h> <C-h>Z8
map <M-l> <C-l>Z8

" window moving {{{3


map <M-S-J> <C-W>J
map <M-S-K> <C-W>K
map <M-S-H> <C-W>H
map <M-S-L> <C-W>L


" Function Key maps {{{3

" f1: show the wildmenu {{{4
map <F1> :<C-U>emenu <C-Z>
imap <F1> <ESC><F1>

" in cmode, it means print time
cnoremap <f1> <C-R>=escape(strftime("%Y-%m-%d %H:%M:%S"), '\ ')<CR>

" f2: winmanager {{{4

" f3: shell {{{4

if !has('win32')
    map <F3> :<C-U>!gnome-terminal &<CR>:call feedkeys("\<lt>CR>")<CR>
elseif executable('sh.exe')
    map <F3> :<C-U>!start sh.exe --login -i<CR>
else
    map <F3> :<C-U>!start cmd.exe<CR>
endif
imap <F3> <ESC><F3>a

" f4: clear hlsearch and qf/loc window {{{4
map <F4> :<C-U>noh\|pcl\|ccl\|lcl<CR>
imap <F4> <ESC><F4>a

" }}}4

" }}}3

" }}}2
" ----------------------------------------------------------
" plugin settings {{{1
if has('eval')

" 2html {{{2

let html_dynamic_folds = 1
let html_ignore_conceal = 1
let html_no_pre = 1
let html_use_css = 1

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

" cctree {{{2

map <leader>ctt :CCTreeLoadDB cscope.out<CR>
map <leader>ct> <C-\>>
map <leader>ct< <C-\><
map <leader>ct- <C-\>-
map <leader>ct= <C-\>=


" ctk {{{2

amenu 1.246 ToolBar.BuiltIn25 :CC<CR>
tmenu ToolBar.BuiltIn25 CTK Compile


" delimitMate {{{2

let delimitMate_expand_cr = 1
let delimitMate_expand_space = 1
autocmd FileType python let b:delimitMate_nesting_quotes = ['"']
autocmd FileType markdown let b:delimitMate_nesting_quotes = ['`']

" fuzzyfinder {{{2

let g:fuf_modesDisable = []
let g:fuf_mrufile_maxItem = 400
let g:fuf_mrucmd_maxItem = 400
nnoremap <silent> <leader>s,     :FufBufferTag<CR>
vnoremap <silent> <leader>s,     :FufBufferTagWithSelectedText!<CR>
nnoremap <silent> <leader>s.     :FufBufferTagAll<CR>
vnoremap <silent> <leader>s.     :FufBufferTagAllWithSelectedText!<CR>
nnoremap <silent> <leader>s<     :FufBufferTag!<CR>
vnoremap <silent> <leader>s<     :FufBufferTagWithSelectedText<CR>
nnoremap <silent> <leader>s>     :FufBufferTagAll!<CR>
vnoremap <silent> <leader>s>     :FufBufferTagAllWithSelectedText<CR>
nnoremap <silent> <leader>s]     :FufBufferTagAllWithCursorWord!<CR>
nnoremap <silent> <leader>s<C-]> :FufTagWithCursorWord!<CR>
nnoremap <silent> <leader>s}     :FufBufferTagWithCursorWord!<CR>
nnoremap <silent> <leader>sd     :FufDirWithCurrentBufferDir<CR>
nnoremap <silent> <leader>sD     :FufDirWithFullCwd<CR>
nnoremap <silent> <leader>s<C-d> :FufDir<CR>
nnoremap <silent> <leader>se     :FufEditDataFile<CR>
nnoremap <silent> <leader>sG     :FufTaggedFile!<CR>
nnoremap <silent> <leader>sg     :FufTaggedFile<CR>
nnoremap <silent> <leader>sh     :FufHelp<CR>
nnoremap <silent> <leader>si     :FufBookmarkDir<CR>
nnoremap <silent> <leader>s<C-i> :FufBookmarkDirAdd<CR>
nnoremap <silent> <leader>sj     :FufBuffer<CR>
nnoremap <silent> <leader>sk     :FufFileWithCurrentBufferDir<CR>
nnoremap <silent> <leader>sK     :FufFileWithFullCwd<CR>
nnoremap <silent> <leader>s<C-k> :FufFile<CR>
nnoremap <silent> <leader>sl     :FufCoverageFileChange<CR>
nnoremap <silent> <leader>sL     :FufCoverageFileChange<CR>
nnoremap <silent> <leader>s<C-l> :FufCoverageFileRegister<CR>
nnoremap <silent> <leader>sm     :FufMruCmd<CR>
nnoremap <silent> <leader>sn     :FufMruFile<CR>
nnoremap <silent> <leader>sN     :FufMruFileInCwd<CR>
nnoremap <silent> <leader>so     :FufJumpList<CR>
nnoremap <silent> <leader>sp     :FufChangeList<CR>
nnoremap <silent> <leader>sq     :FufQuickfix<CR>
nnoremap <silent> <leader>sr     :FufRenewCache<CR>
nnoremap <silent> <leader>sT     :FufTag!<CR>
nnoremap <silent> <leader>st     :FufTag<CR>
nnoremap <silent> <leader>su     :FufBookmarkFile<CR>
nnoremap <silent> <leader>s<C-u> :FufBookmarkFileAdd<CR>
vnoremap <silent> <leader>s<C-u> :FufBookmarkFileAddAsSelectedText<CR>
nnoremap <silent> <leader>sy     :FufLine<CR>


" latex-suite {{{2

let g:tex_flavor='latex'

" lua-inspect {{{2

let g:loaded_luainspect=1 "disable luainspect

" minibufexplpp {{{2

let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplorerMoreThanOne = 2

nmap <leader>on :on<CR><leader>mbe<C-W>j
xmap <leader>on <ESC><leader>on

" mru {{{2

let g:MRU_Check_File = 1
let g:MRU_Exclude_Files = '\c\v(\\|\/)%(Temp|Tmp)\1'
if has('win32')
    let g:MRU_File = expand($VIM.'/_vim_mru_files')
else
    let g:MRU_File = expand('~/.vim/_vim_mru_files')
endif
let g:MRU_Max_Entries = 1000

menutrans Recent\ Files 最近使用的文件(&R)
menutrans Refresh\ list 刷新列表(&R)

map <leader>u :<C-U>MRU<CR>
map <leader>ru :<C-U>MRU 

" neocomplcache {{{2


" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
"let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
" Set minimum syntax keyword length.
"let g:neocomplcache_min_syntax_length = 3
"let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
"let g:neocomplcache_dictionary_filetype_lists = {
"    \ 'default' : '',
"    \ 'vimshell' : $HOME.'/.vimshell_hist',
"    \ 'scheme' : $HOME.'/.gosh_completions'
"    \ }

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
"imap <C-k>     <Plug>(neocomplcache_snippets_expand)
"smap <C-k>     <Plug>(neocomplcache_snippets_expand)
"inoremap <expr><C-g>     neocomplcache#undo_completion()
"inoremap <expr><C-l>     neocomplcache#complete_common_string()

" SuperTab like snippets behavior.
"imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"

" Recommended key-mappings.
" <CR>: close popup and save indent.
"set completeopt-=longest
"inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
" <TAB>: completion.
"inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
"inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
"inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
"inoremap <expr><C-y>  neocomplcache#close_popup()
"inoremap <expr><C-e>  neocomplcache#cancel_popup()

" AutoComplPop like behavior.
"let g:neocomplcache_enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplcache_enable_auto_select = 1
"let g:neocomplcache_disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<TAB>"
"inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
"if !exists('g:neocomplcache_omni_patterns')
"let g:neocomplcache_omni_patterns = {}
"endif
"let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
""autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
"let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'

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

" sessionman {{{2

nmap <leader>pc :SessionClose<CR>
nmap <leader>pe :SessionShowLast<CR>
nmap <leader>pl :SessionList<CR>
nmap <leader>po :SessionOpenLast<CR>
nmap <leader>ps :SessionSave<CR>

" supertab {{{2

let g:SuperTabDefaultCompletionType = "<C-N>"
"let g:SuperTabCrMapping = 0
"let g:SuperTabLongestEnhanced = 1
"let g:SuperTabLongestHighlight = 1

" surround {{{2

let g:surround_{char2nr("c")} = "/* \r */"

" taglist {{{2

if !executable("ctags")
    let g:loaded_taglist = 'no'
else
    let g:Tlist_Show_One_File = 1
    let g:Tlist_Exit_OnlyWindow = 1
endif

" vcscommand {{{2

let g:VCSCommandMapPrefix = "<leader>vc"

" winmanager {{{2

let g:NERDTree_title="[NERD Tree]" 
let g:winManagerWindowLayout = 'NERDTree|TagList'

function! NERDTree_Start()
    exec 'NERDTree'
endfunction

function! NERDTree_IsValid()
    return 1
endfunction


nmap <leader>wm :<c-u>if IsWinManagerVisible() <BAR> WMToggle<CR> <BAR> else <BAR> WMToggle<CR>:q<CR> endif <CR><CR>
map <F2> <leader>wm
imap <F2> <ESC><leader>wm

" }}}2

endif

if exists('s:cpo_save')
    let &cpo = s:cpo_save
    unlet s:cpo_save
endif

" }}}1
" vim: set ft=vim ff=unix fdm=marker ts=8 sw=4 et sta nu:
