se go+=gmrLtT 

fun! SetSyn(name)
  if a:name == "fvwm1"
    let use_fvwm_1 = 1
    let use_fvwm_2 = 0
    let name = "fvwm"
  elseif a:name == "fvwm2"
    let use_fvwm_2 = 1
    let use_fvwm_1 = 0
    let name = "fvwm"
  else
    let name = a:name
  endif
  if !exists("s:syntax_menu_synonly")
    exe "set ft=" . name
    if exists("g:syntax_manual")
      exe "set syn=" . name
    endif
  else
    exe "set syn=" . name
  endif
endfun

an 50.5.10 &Syntax.&C\ filetype :cal SetSyn("c")<CR>
an 50.5.20 &Syntax.&C++\ filetype :cal SetSyn("cpp")<CR>
an 50.5.30 &Syntax.&Lua\ filetype :cal SetSyn("lua")<CR>
an 50.5.40 &Syntax.-SEP0- <Nop>
