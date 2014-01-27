" File System Operations on file under cursor
"=============================================================================
" Informations : Author and more (press za to open this under Vim)  {{{1
"
" Author: niva
"
" Mail: nivaemail@gmail.com
"
" Website: http://lemachupicchu.fr
"
" Main Feature: Enable vim user to rename (or delete) file when cursor pass 
" over its filename/filepath.
"
" Usage: Just type :REN or :DEL to do some action onfile under cursor
"
" Recognition priority :
"
"   0.	Check that filename under cursor exists and is in an opened NERDTree buffer
"   1.	Check that filename under cursor is in the current directory
"   2.	Check that the filepath under cursor exists
"   3.	Check that file opened in the current buffer exists
"
"
" Versions:
" version 1.0 Initial Upload
" version 1.1 Compatibility win32 and unix OS
" version 1.2 Add new rename feature when cursor is over filepath
"             Add Delete feature
" version 1.3 Add Dictionaries to store commands
"             Enable delete files in NERDTree that have spaces inside filename
" version 1.4 Fix bug with whitespace into NERDTree
"             Extend features to include files as webdeveloppers files (html,css,xhtml))
" version 1.5 Add Menu Feature and opening filepath in windows browser
" 			  Rename script because of added features
" 
" Last date revision : 20/04/2011
"
" }}}1
"=============================================================================
" Dictionaries of commands depending on OS {{{1


" List of patterns to substitute depending on OS
let s:lpatwin   = [ ['\/','\\'], ['\\\\','\\'], ['\\','\'] ] 
let s:lpatunix  = [ ['\\','\/'], ['\/\/','\/'] ] 

"}}}1
"=============================================================================
" Function to init Dicts and Lists {{{1
function! s:InitDicts()

	let g:cmdDic  = {
				\ 'REN'     : {'maincall': 'call '   , 'cmd': ['rename']  												, 'parA':'tofeed', 'needparAFileOrPath':'f', 'parB':'tofeed', 'actionQuestion':'Rename this file to'         , 'needBracket':'yes'}, 
				\ 'DEL'     : {'maincall': 'call '   , 'cmd': ['delete']  												, 'parA':'tofeed', 'needparAFileOrPath':'f', 'parB':''      , 'actionQuestion':'Delete this file'            , 'needBracket':'yes'},
				\ 'BROZ'    : {'maincall': 'system ' , 'cmd': ['explorer.exe /select,']									, 'parA':'tofeed', 'needparAFileOrPath':'b', 'parB':''      , 'actionQuestion':'Open directory of this file' , 'needBracket':'no' },
				\ 'INFOS'   : {'maincall': 'echo '   , 'cmd': ['getftype','getfperm','strftime("%Y %b %d %X",getftime']	, 'parA':'tofeed', 'needparAFileOrPath':'f', 'parB':''      , 'actionQuestion':'Get permissions of this file', 'needBracket':'yes'}
				\}

	if !empty(g:cmdDic)
		echo "dict not empty"
	endif

	let s:patList = []

	let s:patList=deepcopy(s:lpatunix)

	if has("win32")
		let s:patList=deepcopy(s:lpatwin)
	endif
endfunc
" }}}1
"=============================================================================
" Function to detect file under cursor (in NERDTree)  {{{1
function! <SID>:SysIOAction(action)

	if !has("win32")
		if a:action=="BROZ"
			echo "browsing feature not available yet under unix"
			return 0
		endif
	endif
	" echo "asked action:"a:action."."
	" if empty(g:cmdDic)
	" 	echo "dico vide"
	" endif

	call s:InitDicts() 

	let l:memoCurrentDir=getcwd()

	let g:fileToAlter=""
	let g:pathOfFileToAlter=""
	"
	"=============================================================================
	if  stridx(bufname("%"),"NERD")>-1
		"=============================================================================
		" Specific NERDTree buffer case {{{2

		" sauvegarde du nom du fichier
		let g:fileToAlter=substitute(getline(line(".")), '^\(\(|\|`\)\s*`*\)\+-', '', ""  )
		let g:fileToAlter=substitute(g:fileToAlter, '\(\/\|\*\)$', '', ""  )


		mark a

		norm pcd

		let g:pathOfFileToAlter=getcwd()
		" End of Specific NERDTree buffer case }}}2
		"=============================================================================
	elseif filereadable(expand("<cfile>"))!=0
		"=============================================================================
		" File Under cursor {{{2                  
		let g:integralDir=expand("<cfile>")
		let g:fileToAlter=substitute(g:fileToAlter, '\(\/\|\*\)$', '', ""  )
		exe "cd ".fnamemodify(g:integralDir, ":p:h")
		let g:pathOfFileToAlter=fnamemodify(g:integralDir, ":p:h")
		let g:fileToAlter=fnamemodify(g:integralDir, ":p:t")
		" End of File Under cursor }}}2
		"=============================================================================
	elseif filereadable(expand("%:p:h")."/".expand("<cfile>"))!=0

		let g:integralDir=expand("%:p:h")."/".expand("<cfile>:h")
		exe "cd ".g:integralDir
		let g:pathOfFileToAlter=g:integralDir
		let g:fileToAlter=expand("<cfile>:t")

	elseif filereadable(expand("%:p"))!=0
		" Current Opened Buffer {{{2
		exe "cd ".expand("%:p:h")
		let g:pathOfFileToAlter=expand("%:p:h")
		let g:fileToAlter=expand("%:p:t")
		" End of Current Opened Buffer }}}2
		"=============================================================================
	endif
	"=============================================================================
	" Ask user to alter the file to {{{2
	"
	" parA
	call s:FeedCmdParA(a:action,g:fileToAlter)

	let l:cmdtest=s:BuildCmd(a:action)

	" test to ask or just show question
	if g:cmdDic[a:action].maincall=="call "

		let l:newFileName=inputdialog(g:cmdDic[a:action].actionQuestion, g:fileToAlter)
		if l:newFileName != ""

			" parB
			call s:FeedCmdParB(a:action,l:newFileName)
			let l:cmdtest=s:BuildCmd(a:action)

			exe l:cmdtest

			if stridx(bufname("%"),"NERD")>-1
				norm 'a
				silent norm Kkrj
			endif

		endif
	elseif g:cmdDic[a:action].maincall=="system "
		call system("".l:cmdtest)
		echo 'call system("'.l:cmdtest.'")'
	else
		" just show
		exe l:cmdtest
	endif
	" End of Asking user to rename the file to }}}2
	"=============================================================================


	exe "cd ".l:memoCurrentDir
endfunction 
"}}}1
"=============================================================================
" Function to feed param if needed {{{1
function! s:FeedCmdParA(action,arg)

	if g:cmdDic[a:action].parA=="tofeed"
		if g:cmdDic[a:action].needparAFileOrPath == "f"
			let g:cmdDic[a:action].parA=s:SubSomeChars(a:arg)
		elseif g:cmdDic[a:action].needparAFileOrPath == "b"
			let g:cmdDic[a:action].parA=s:SubSomeChars(g:pathOfFileToAlter).s:AddGoodSlashForOS().s:SubSomeChars(a:arg)
		else
			let g:cmdDic[a:action].parA=g:pathOfFileToAlter
		endif
	endif

endfunc
function! s:FeedCmdParB(action,arg)
	if g:cmdDic[a:action].parB=="tofeed"
		" echo g:cmdDic[a:action]
		let g:cmdDic[a:action].parB=','
		let g:cmdDic[a:action].parB.=s:AddQuoteOnMSWin()
		let g:cmdDic[a:action].parB.=s:SubSomeChars(a:arg)
		let g:cmdDic[a:action].parB.=s:AddQuoteOnMSWin()
	endif
endfunc
"}}}1
"=============================================================================
" Function to sub some non wanted characters {{{1
function! s:SubSomeChars(var)
	let l:tmp=a:var
	for item in s:patList 
		let l:tmp=substitute(l:tmp, ''.item[0], ''.item[1], "g") 
	endfor             
	return l:tmp
endfunc
"}}}1
"=============================================================================
" Function that build the command to launch {{{1
function! s:BuildCmd(action)

	let l:cmd=g:cmdDic[a:action].maincall

	if g:cmdDic[a:action].maincall == "system "
		let l:cmd=""
	endif

	let l:listLen = len(g:cmdDic[a:action].cmd)
	let l:idx = 1
	for funktion in g:cmdDic[a:action].cmd 

		let l:cmd.=funktion
		if g:cmdDic[a:action].needBracket == "yes"
			let l:cmd.="("
		endif


		let l:cmd.=s:AddQuoteOnMSWin()
		let l:cmd.=g:cmdDic[a:action].parA

		if l:listLen > 1
			let l:cmd.=s:AddQuoteOnMSWin().")"
			" end second funk
			if stridx(funktion,'(') > -1
				let l:cmd.=')'
			endif
			" concat with next function to call
			if l:idx!=l:listLen
				let l:cmd.='." ".'
			endif
		endif
		let l:idx+=1
	endfor             

	if l:listLen == 1
		let l:cmd.=s:AddQuoteOnMSWin()
		let l:cmd.=g:cmdDic[a:action].parB
		if g:cmdDic[a:action].needBracket == "yes"
			let l:cmd.=")"
		endif
	endif
	return l:cmd
endfunc
"}}}1
"=============================================================================
" Function that add quote on commands specific for windows {{{1
function! s:AddQuoteOnMSWin()
	if has("win32")
		return '"'
	endif
endfunc
"}}}1
"=============================================================================
" Function that add slash on good os {{{1
function! s:AddGoodSlashForOS()
	if has("win32")
		return '\'
	else
		return '/'
	endif
endfunc
"}}}1
"=============================================================================
" Function that Feed List to display to user {{{1
function! FeedList (findstart, base)
	if a:findstart
	else
		let res=["DEL", "REN", "BROZ", "INFOS"]
		return res
	endif
endfunction
"}}}1
"=============================================================================
" Function that get choice of user {{{1
fun! <SID>:GetChoice() 
	silent norm yy
	" sub carriage return
	let g:choice=substitute(@", '\n', '', "")
	bd!
	" echo g:choice
	call <SID>:SysIOAction(g:choice)
endfunction "}}}1
"=============================================================================
" Function that display listing {{{1
function! <SID>:DisplayListing()

	1split
	enew
	set completefunc=FeedList

	unlet g:choice

	" remap cr in current opened buffer to detect menu choice
	inoremap <buffer> <CR> <CR><Esc>:call <SID>:GetChoice()<CR>

	"
	call feedkeys("i", 'n') 
	call feedkeys("\<C-X>\<C-U>\<Down>", 'n') 

endfunc
"}}}1
"=============================================================================
"Generate the help documentation of this script {{{1
fun! <SID>:GenerateHelpFile( nameOfDestFile )

	let helpcontent=[]

	call add(helpcontent, "*fsohelp.txt*  File System Operations For Vim version 7.0            Last change:  01 May 2011")
	call add(helpcontent, "")
	call add(helpcontent, "")
	call add(helpcontent, "PERSONAL COLOUR SWITCHER                                *fsohlp* ")
	call add(helpcontent, "")
	call add(helpcontent, "")
	call add(helpcontent, "Author:  Niva Niva.  <nivaemail at gmail dot com>")
	call add(helpcontent, "")
	call add(helpcontent, "Need unix vimuser to add file manager feature under unix. Email me please.")
	call add(helpcontent, "")
	call add(helpcontent, "==============================================================================")
	call add(helpcontent, "CONTENTS                                                 *fso* *fso-contents*")
	call add(helpcontent, "")
	call add(helpcontent, "	1. Contents.....................|fso-contents|")
	call add(helpcontent, "	2. Fso Features Overview........|fso-overview|")
	call add(helpcontent, "	3. Fso Installation.............|fso-installation|")
	call add(helpcontent, "	4. Fso Usage....................|fso-usage|")
	call add(helpcontent, "	5. Fso Versions.................|fso-versions|")
	call add(helpcontent, "")
	call add(helpcontent, "==============================================================================")
	call add(helpcontent, "FSO FEATURES OVERVIEW                           *fso-features* *fso-overview*")
	call add(helpcontent, "")
	call add(helpcontent, "")
	call add(helpcontent, "	Main Feature ~")
	call add(helpcontent, "")
	call add(helpcontent, "	. Enable vim user to do some operating action on file on which cursor")
	call add(helpcontent, "	  is passing over.")
	call add(helpcontent, "")
	call add(helpcontent, "	Features ~")
	call add(helpcontent, "")
	call add(helpcontent, "	. renaming")
	call add(helpcontent, "	. deleting")
	call add(helpcontent, "	. browsing filepath with system files'explorer")
	call add(helpcontent, "	. showing permissions and others informations")
	call add(helpcontent, "")
	call add(helpcontent, "")
	call add(helpcontent, "                                ->> GO BACK to Contents Menu ->> |fso-contents|")
	call add(helpcontent, "==============================================================================")
	call add(helpcontent, "FSO INSTALLATION                                          *fso-installation*")
	call add(helpcontent, "")
	call add(helpcontent, "")
	call add(helpcontent, "	Under Windows ~")
	call add(helpcontent, "")
	call add(helpcontent, "	Copy this vimswcript to %homepath%/vimfiles/plugin")
	call add(helpcontent, "")
	call add(helpcontent, "")
	call add(helpcontent, "	Under Unix ~")
	call add(helpcontent, "")
	call add(helpcontent, "	Copy this vimswcript to ~/vimfiles/plugin")
	call add(helpcontent, "")
	call add(helpcontent, "")
	call add(helpcontent, "	Optional Help File ~")
	call add(helpcontent, "")
	call add(helpcontent, "	Just type the command FSOHLP and hit enter.")
	call add(helpcontent, ">")
	call add(helpcontent, "		:FSOHLP")
	call add(helpcontent, "<")
	call add(helpcontent, "	This will generate the help file in $home/vimfile/doc and call helptags for you.")
	call add(helpcontent, "")
	call add(helpcontent, "	Then you can access to this help by typing:")
	call add(helpcontent, ">")
	call add(helpcontent, "		:h fso")
	call add(helpcontent, "<")
	call add(helpcontent, "")
	call add(helpcontent, "                                ->> GO BACK to Contents Menu ->> |fso-contents|")
	call add(helpcontent, "==============================================================================")
	call add(helpcontent, "FSO USAGE                                                       *fso-usage*")
	call add(helpcontent, "")
	call add(helpcontent, "")
	call add(helpcontent, "	Simpliest main action to do  ~")
	call add(helpcontent, "")
	call add(helpcontent, "	1. Just pass your cursor over a filename.")
	call add(helpcontent, "	2. Type an FSO command or enter FSo popup menu.")
	call add(helpcontent, "")
	call add(helpcontent, "")
	call add(helpcontent, "")
	call add(helpcontent, "	Available Commands (type :THECMD and hit ENTER)  ~")
	call add(helpcontent, "")
	call add(helpcontent, "	o REN")
	call add(helpcontent, ">")
	call add(helpcontent, "	>> Show an input dialog to let your enter the new filename of the")
	call add(helpcontent, "	   file.")
	call add(helpcontent, "<")
	call add(helpcontent, "")
	call add(helpcontent, "	o DEL")
	call add(helpcontent, ">")
	call add(helpcontent, "	>> Show a confirm dialog box to let your decide to delete the file.")
	call add(helpcontent, "<           ")
	call add(helpcontent, "")
	call add(helpcontent, "	o BROZ")
	call add(helpcontent, ">")
	call add(helpcontent, "	>> Open windows explorer to the directory that contains the file under")
	call add(helpcontent, "	   cursor.")
	call add(helpcontent, "<           ")
	call add(helpcontent, "")
	call add(helpcontent, "	o INFOS or INFO or INF")
	call add(helpcontent, ">")
	call add(helpcontent, "	>> Echo the permissions, type, size and last modification date of the")
	call add(helpcontent, "	   file.")
	call add(helpcontent, "<           ")
	call add(helpcontent, "           ")
	call add(helpcontent, "	Popup Menu Command ~")
	call add(helpcontent, "")
	call add(helpcontent, "	o LSD")
	call add(helpcontent, ">")
	call add(helpcontent, "	>> Show all available commands in a popup menu.")
	call add(helpcontent, "	   Just select with arrow keys or Ctrl-N Ctrl-P and hit Enter.")
	call add(helpcontent, "<")
	call add(helpcontent, "")
	call add(helpcontent, "                                ->> GO BACK to Contents Menu ->> |fso-contents|")
	call add(helpcontent, "==============================================================================")
	call add(helpcontent, "FSO VERSIONS                                                   *fso-versions*")
	call add(helpcontent, "")
	call add(helpcontent, "")
	call add(helpcontent, "")
	call add(helpcontent, "")
	call add(helpcontent, "	Version 1.7 : ~")
	call add(helpcontent, "")
	call add(helpcontent, "	o Fix bug to BROZ command that can open directory in windows explorer of relative filepath on which cursor pass over")
	call add(helpcontent, "")
	call add(helpcontent, "")
	call add(helpcontent, "	Version 1.6 : ~")
	call add(helpcontent, "")
	call add(helpcontent, "	o Add the vimscript documentation")
	call add(helpcontent, "")
	call add(helpcontent, "")
	call add(helpcontent, "	Version 1.5 : ~")
	call add(helpcontent, "")
	call add(helpcontent, "	o Add Menu Feature and opening filepath in windows browser")
	call add(helpcontent, "	o Change the name of the script because of all features coming...")
	call add(helpcontent, "")
	call add(helpcontent, "")
	call add(helpcontent, "	Version 1.4 : ~")
	call add(helpcontent, "")
	call add(helpcontent, "	o Fix bug with whitespace into NERDTree")
	call add(helpcontent, "        o Extend features to include files as webdeveloppers files ")
	call add(helpcontent, "	(html,css,xhtml))")
	call add(helpcontent, "    	o Add Delete feature")
	call add(helpcontent, "")
    call add(helpcontent, "")
	call add(helpcontent, "	Version 1.3 : ~")
	call add(helpcontent, "")
	call add(helpcontent, "	o Add Dictionaries to store commands")
	call add(helpcontent, "        o Enable delete files in NERDTree that have spaces inside filename")
	call add(helpcontent, "")
	call add(helpcontent, "	Version 1.2 : ~")
	call add(helpcontent, "")
	call add(helpcontent, "	o Add new Rename feature when cursor is over filepath")
	call add(helpcontent, "        o Add Delete feature")
	call add(helpcontent, "")
	call add(helpcontent, "	Version 1.1 : ~")
	call add(helpcontent, "")
	call add(helpcontent, "	o Add Compatibility win32 and unix OS")
	call add(helpcontent, "")
	call add(helpcontent, "")
	call add(helpcontent, "	Version 1.0 : ~")
	call add(helpcontent, "")
	call add(helpcontent, "	o Initial upload")
	call add(helpcontent, "")
	call add(helpcontent, "")
	call add(helpcontent, "                                ->> GO BACK to Contents Menu ->> |fso-contents|")
	call add(helpcontent, "==============================================================================")
	call add(helpcontent, "")
	call add(helpcontent, "vim:tw=78:ts=8:noet:ft=help:fo+=t:norl:noet:")

    " write all content to the help file
    call writefile(helpcontent, expand("$home")."/vimfiles/doc/".a:nameOfDestFile , "b")

	exe "helptags ".expand("$home")."/vimfiles/doc"

endfunction
"}}}1
"=============================================================================
"Standalone cmd {{{1
"RENAME
command! -nargs=0 -complete=file REN call <SID>:SysIOAction("REN")  
"DELETE
command! -nargs=0 -complete=file DEL call <SID>:SysIOAction("DEL")  
"OPEN DIR
command! -nargs=0 -complete=file BROZ call <SID>:SysIOAction("BROZ")  
"INFO
command! -nargs=0 -complete=file INFOS call <SID>:SysIOAction("INFOS")  
command! -nargs=0 -complete=file INFO call <SID>:SysIOAction("INFOS")  
command! -nargs=0 -complete=file INF call <SID>:SysIOAction("INFOS")  
"}}}1
"=============================================================================
"Menu cmd {{{1
command! -nargs=0 -complete=file LSD call <SID>:DisplayListing()  
"}}}1
"=============================================================================
"Help file cmd {{{1
command! -nargs=0 -complete=file FSOHLP call <SID>:GenerateHelpFile("fsohelp.txt")
"}}}1
"=============================================================================
"Autosource when saving this file {{{1
autocmd bufwritepost ~/vimfiles/plugin/ren.vim source ~/vimfiles/plugin/ren.vim
"}}}1

" vim: set ft=vim ff=unix fdm=marker ts=4 :expandtab:
