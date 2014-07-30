" Lua C API Functions
"
" Lua base functions {{{

syntax keyword luaConstant LUA_VERSION_MAJOR LUA_VERSION_MINOR
syntax keyword luaConstant LUA_VERSION_NUM
syntax keyword luaConstant LUA_VERSION_RELEASE
syntax keyword luaConstant LUA_VERSION
syntax keyword luaConstant LUA_RELEASE
syntax keyword luaConstant LUA_AUTHORS
syntax keyword luaConstant LUA_SIGNATURE
syntax keyword luaConstant LUA_MULTRET
syntax keyword luaConstant LUA_REGISTRYINDEX
syntax keyword luaConstant LUA_OK
syntax keyword luaConstant LUA_YIELD
syntax keyword luaConstant LUA_ERRRUN
syntax keyword luaConstant LUA_ERRSYNTAX
syntax keyword luaConstant LUA_ERRMEM
syntax keyword luaConstant LUA_ERRGCMM
syntax keyword luaConstant LUA_ERRERR
syntax keyword luaConstant LUA_API
syntax keyword luaConstant LUALIB_API

syntax keyword luaConstant LUA_TNONE
syntax keyword luaConstant LUA_TNIL
syntax keyword luaConstant LUA_TBOOLEAN
syntax keyword luaConstant LUA_TLIGHTUSERDATA
syntax keyword luaConstant LUA_TNUMBER
syntax keyword luaConstant LUA_TSTRING
syntax keyword luaConstant LUA_TTABLE
syntax keyword luaConstant LUA_TFUNCTION
syntax keyword luaConstant LUA_TUSERDATA
syntax keyword luaConstant LUA_TTHREAD
syntax keyword luaConstant LUA_NUMTAGS

syntax keyword luaConstant LUA_MINSTACK

syntax keyword luaConstant LUA_RIDX_MAINTHREAD
syntax keyword luaConstant LUA_RIDX_GLOBALS
syntax keyword luaConstant LUA_RIDX_LAST

syntax keyword luaConstant LUA_OPADD
syntax keyword luaConstant LUA_OPSUB
syntax keyword luaConstant LUA_OPMUL
syntax keyword luaConstant LUA_OPDIV
syntax keyword luaConstant LUA_OPMOD
syntax keyword luaConstant LUA_OPPOW
syntax keyword luaConstant LUA_OPUNM

syntax keyword luaConstant LUA_OPEQ
syntax keyword luaConstant LUA_OPLT
syntax keyword luaConstant LUA_OPLE

syntax keyword luaConstant LUA_GCSTOP
syntax keyword luaConstant LUA_GCRESTART
syntax keyword luaConstant LUA_GCCOLLECT
syntax keyword luaConstant LUA_GCCOUNT
syntax keyword luaConstant LUA_GCCOUNTB
syntax keyword luaConstant LUA_GCSTEP
syntax keyword luaConstant LUA_GCSETPAUSE
syntax keyword luaConstant LUA_GCSETSTEPMUL
syntax keyword luaConstant LUA_GCSETMAJORINC
syntax keyword luaConstant LUA_GCISRUNNING
syntax keyword luaConstant LUA_GCGEN
syntax keyword luaConstant LUA_GCINC

syntax keyword luaConstant LUA_HOOKCALL
syntax keyword luaConstant LUA_HOOKRET
syntax keyword luaConstant LUA_HOOKLINE
syntax keyword luaConstant LUA_HOOKCOUNT
syntax keyword luaConstant LUA_HOOKTAILCALL

syntax keyword luaConstant LUA_MASKCALL
syntax keyword luaConstant LUA_MASKRET
syntax keyword luaConstant LUA_MASKLINE
syntax keyword luaConstant LUA_MASKCOUNT

syntax keyword luaType lua_Alloc
syntax keyword luaType lua_CFunction
syntax keyword luaType lua_Debug
syntax keyword luaType lua_Hook
syntax keyword luaType lua_Integer
syntax keyword luaType lua_Number
syntax keyword luaType lua_Reader
syntax keyword luaType lua_State
syntax keyword luaType lua_Unsigned
syntax keyword luaType lua_Writer

syntax keyword luaFunction lua_absindex
syntax keyword luaFunction lua_arith
syntax keyword luaFunction lua_atpanic
syntax keyword luaFunction lua_call
syntax keyword luaFunction lua_callk
syntax keyword luaFunction lua_checkstack
syntax keyword luaFunction lua_close
syntax keyword luaFunction lua_compare
syntax keyword luaFunction lua_concat
syntax keyword luaFunction lua_copy
syntax keyword luaFunction lua_createtable
syntax keyword luaFunction lua_dump
syntax keyword luaFunction lua_error
syntax keyword luaFunction lua_gc
syntax keyword luaFunction lua_getallocf
syntax keyword luaFunction lua_getctx
syntax keyword luaFunction lua_getfield
syntax keyword luaFunction lua_getglobal
syntax keyword luaFunction lua_gethook
syntax keyword luaFunction lua_gethookcount
syntax keyword luaFunction lua_gethookmask
syntax keyword luaFunction lua_getinfo
syntax keyword luaFunction lua_getlocal
syntax keyword luaFunction lua_getmetatable
syntax keyword luaFunction lua_getstack
syntax keyword luaFunction lua_gettable
syntax keyword luaFunction lua_gettop
syntax keyword luaFunction lua_getupvalue
syntax keyword luaFunction lua_getuservalue
syntax keyword luaFunction lua_insert
syntax keyword luaFunction lua_isboolean
syntax keyword luaFunction lua_iscfunction
syntax keyword luaFunction lua_isfunction
syntax keyword luaFunction lua_islightuserdata
syntax keyword luaFunction lua_isnil
syntax keyword luaFunction lua_isnone
syntax keyword luaFunction lua_isnoneornil
syntax keyword luaFunction lua_isnumber
syntax keyword luaFunction lua_isstring
syntax keyword luaFunction lua_istable
syntax keyword luaFunction lua_isthread
syntax keyword luaFunction lua_isuserdata
syntax keyword luaFunction lua_len
syntax keyword luaFunction lua_load
syntax keyword luaFunction lua_newstate
syntax keyword luaFunction lua_newtable
syntax keyword luaFunction lua_newthread
syntax keyword luaFunction lua_newuserdata
syntax keyword luaFunction lua_next
syntax keyword luaFunction lua_pcall
syntax keyword luaFunction lua_pcallk
syntax keyword luaFunction lua_pop
syntax keyword luaFunction lua_pushboolean
syntax keyword luaFunction lua_pushcclosure
syntax keyword luaFunction lua_pushcfunction
syntax keyword luaFunction lua_pushfstring
syntax keyword luaFunction lua_pushglobaltable
syntax keyword luaFunction lua_pushinteger
syntax keyword luaFunction lua_pushlightuserdata
syntax keyword luaFunction lua_pushliteral
syntax keyword luaFunction lua_pushlstring
syntax keyword luaFunction lua_pushnil
syntax keyword luaFunction lua_pushnumber
syntax keyword luaFunction lua_pushstring
syntax keyword luaFunction lua_pushthread
syntax keyword luaFunction lua_pushunsigned
syntax keyword luaFunction lua_pushvalue
syntax keyword luaFunction lua_pushvfstring
syntax keyword luaFunction lua_rawequal
syntax keyword luaFunction lua_rawget
syntax keyword luaFunction lua_rawgeti
syntax keyword luaFunction lua_rawgetp
syntax keyword luaFunction lua_rawlen
syntax keyword luaFunction lua_rawset
syntax keyword luaFunction lua_rawseti
syntax keyword luaFunction lua_rawsetp
syntax keyword luaFunction lua_register
syntax keyword luaFunction lua_remove
syntax keyword luaFunction lua_replace
syntax keyword luaFunction lua_resume
syntax keyword luaFunction lua_setallocf
syntax keyword luaFunction lua_setfield
syntax keyword luaFunction lua_setglobal
syntax keyword luaFunction lua_sethook
syntax keyword luaFunction lua_setlocal
syntax keyword luaFunction lua_setmetatable
syntax keyword luaFunction lua_settable
syntax keyword luaFunction lua_settop
syntax keyword luaFunction lua_setupvalue
syntax keyword luaFunction lua_setuservalue
syntax keyword luaFunction lua_status
syntax keyword luaFunction lua_toboolean
syntax keyword luaFunction lua_tocfunction
syntax keyword luaFunction lua_tointeger
syntax keyword luaFunction lua_tointegerx
syntax keyword luaFunction lua_tolstring
syntax keyword luaFunction lua_tonumber
syntax keyword luaFunction lua_tonumberx
syntax keyword luaFunction lua_topointer
syntax keyword luaFunction lua_tostring
syntax keyword luaFunction lua_tothread
syntax keyword luaFunction lua_tounsigned
syntax keyword luaFunction lua_tounsignedx
syntax keyword luaFunction lua_touserdata
syntax keyword luaFunction lua_type
syntax keyword luaFunction lua_typename
syntax keyword luaFunction lua_upvalueid
syntax keyword luaFunction lua_upvalueindex
syntax keyword luaFunction lua_upvaluejoin
syntax keyword luaFunction lua_version
syntax keyword luaFunction lua_xmove
syntax keyword luaFunction lua_yield
syntax keyword luaFunction lua_yieldk
" }}}
"
" Lua auxlib functions {{{
syntax keyword luaConstant LUAL_BUFFERSIZE
syntax keyword luaConstant LUA_ERRFILE
syntax keyword luaConstant LUA_NOREF
syntax keyword luaConstant LUA_REFNIL
syntax keyword luaConstant LUA_FILEHANDLE

syntax keyword luaType luaL_Buffer
syntax keyword luaType luaL_Stream
syntax keyword luaType luaL_Reg

syntax keyword luaFunction luaL_addchar
syntax keyword luaFunction luaL_addlstring
syntax keyword luaFunction luaL_addsize
syntax keyword luaFunction luaL_addstring
syntax keyword luaFunction luaL_addvalue
syntax keyword luaFunction luaL_argcheck
syntax keyword luaFunction luaL_argerror
syntax keyword luaFunction luaL_buffinit
syntax keyword luaFunction luaL_buffinitsize
syntax keyword luaFunction luaL_callmeta
syntax keyword luaFunction luaL_checkany
syntax keyword luaFunction luaL_checkint
syntax keyword luaFunction luaL_checkinteger
syntax keyword luaFunction luaL_checklong
syntax keyword luaFunction luaL_checklstring
syntax keyword luaFunction luaL_checknumber
syntax keyword luaFunction luaL_checkoption
syntax keyword luaFunction luaL_checkstack
syntax keyword luaFunction luaL_checkstring
syntax keyword luaFunction luaL_checktype
syntax keyword luaFunction luaL_checkudata
syntax keyword luaFunction luaL_checkunsigned
syntax keyword luaFunction luaL_checkversion
syntax keyword luaFunction luaL_dofile
syntax keyword luaFunction luaL_dostring
syntax keyword luaFunction luaL_error
syntax keyword luaFunction luaL_execresult
syntax keyword luaFunction luaL_fileresult
syntax keyword luaFunction luaL_getmetafield
syntax keyword luaFunction luaL_getmetatable
syntax keyword luaFunction luaL_getsubtable
syntax keyword luaFunction luaL_gsub
syntax keyword luaFunction luaL_len
syntax keyword luaFunction luaL_loadbuffer
syntax keyword luaFunction luaL_loadbufferx
syntax keyword luaFunction luaL_loadfile
syntax keyword luaFunction luaL_loadfilex
syntax keyword luaFunction luaL_loadstring
syntax keyword luaFunction luaL_newlib
syntax keyword luaFunction luaL_newlibtable
syntax keyword luaFunction luaL_newmetatable
syntax keyword luaFunction luaL_newstate
syntax keyword luaFunction luaL_openlibs
syntax keyword luaFunction luaL_optint
syntax keyword luaFunction luaL_optinteger
syntax keyword luaFunction luaL_optlong
syntax keyword luaFunction luaL_optlstring
syntax keyword luaFunction luaL_optnumber
syntax keyword luaFunction luaL_optstring
syntax keyword luaFunction luaL_optunsigned
syntax keyword luaFunction luaL_prepbuffer
syntax keyword luaFunction luaL_prepbuffsize
syntax keyword luaFunction luaL_pushresult
syntax keyword luaFunction luaL_pushresultsize
syntax keyword luaFunction luaL_ref
syntax keyword luaFunction luaL_requiref
syntax keyword luaFunction luaL_setfuncs
syntax keyword luaFunction luaL_setmetatable
syntax keyword luaFunction luaL_testudata
syntax keyword luaFunction luaL_tolstring
syntax keyword luaFunction luaL_traceback
syntax keyword luaFunction luaL_typename
syntax keyword luaFunction luaL_unref
syntax keyword luaFunction luaL_where
" }}}
"
" Inline Lua code {{{
if exists('b:current_syntax')
    let s:prev_syntax=b:current_syntax
    unlet b:current_syntax
endif
syn include @LuaCode syntax/lua.vim
if exists('s:prev_syntax')
    let b:current_syntax=s:prev_syntax
    unlet s:prev_syntax
else
    unlet b:current_syntax
endif
syn region luaCode matchgroup=Keyword start=+Lua(+ end=+)+ contains=@LuaCode

" }}}
"
" Default highlighting {{{
if version >= 508 || !exists("did_c_ansi_syntax_inits")
  if version < 508
    let did_c_ansi_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink luaType            cType
  HiLink luaFunction        cFunction
  HiLink luaConstant        cConstant
  delcommand HiLink
endif
" }}}

" vim: fdm=marker
