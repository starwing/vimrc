let s:current_syntax=b:current_syntax
unlet b:current_syntax
syn include @GLSL syntax/glsl.vim
let b:current_syntax=s:current_syntax
syn region glShaderLang matchgroup=Keyword start=+GLSL(+ end=+)+ contains=@GLSL
syn region glShaderParen start=+(+ end=+)+ contains=@GLSL,glShaderParen transparent contained containedin=glShaderLang
syn cluster cParenGroup add=glShaderParen
