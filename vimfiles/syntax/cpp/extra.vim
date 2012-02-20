" ==========================================================
" File Name:   cpp_extra.vim
" Author:      StarWing
" Version:     1.0
" Last Change:  2008-11-23 04:39:06
" ==========================================================

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Read the C syntax to start with
if version < 600
  so <sfile>:p:h/../c/extra.vim
else
  runtime! syntax/c/extra.vim
  unlet! b:current_syntax
endif
