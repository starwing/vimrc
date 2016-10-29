-- options --
local dstdir = [[\Vim\vim80]]
local srcdir = [[\Work\Sources\Vim\src\]]
local rtdir  = [[\Work\Sources\Vim\runtime\]]
local flags  = [[DIRECTX=yes IME=yes CSCOPE=yes OLE=yes WINVER=0x0500]]
local optflags = {
    user    = [[USERNAME=SW USERDOMAIN=SB_DiaoSi_Mo]],
    sdkdir   = [[SDK_INCLUDE_DIR="C:\Program Files\Microsoft SDKs\Windows\v7.1\Include"]],
    sdkdir64 = [[SDK_INCLUDE_DIR="C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\Include"]],
    lua     = [[LUA=\Lua53 DYNAMIC_LUA=yes LUA_VER=53]],
    mz      = [[MZSCHEME=\Racket DYNAMIC_MZSCHEME=yes MZSCHEME_VER=3m_9x82yo]],
    perl    = [[PERL=\perl DYNAMIC_PERL=yes PERL_VER=522]],
    python  = [[PYTHON=\python27 DYNAMIC_PYTHON=yes PYTHON_VER=27]],
    python3 = [[PYTHON3=\python35 DYNAMIC_PYTHON3=yes PYTHON3_VER=35]],
    ruby    = [[RUBY=\ruby192 DYNAMIC_RUBY=yes RUBY_VER=192 RUBY_VER_LONG=1.9.1]],
    tcl     = [[TCL=\Tcl DYNAMIC_TCL=yes TCL_VER=86 TCL_VER_LONG=8.6]],
    vs2015  = [[DEFINES="/GL /GS- /O2 /Oy /Oi"]],
}
local uses = { "vs2015", "user", "sdkdir64", "lua", "perl", "python3", "tcl" }
-- end --

if arg[1] == "copy" then
   local runtimes = {}
   for dir in io.popen("dir /A:D /B "..rtdir, "r"):lines() do
      if dir ~= 'icons' and dir ~= 'print' then
         runtimes[#runtimes+1] = dir
      end
   end
   for k, v in ipairs(runtimes) do
      os.execute("xcopy>nul /i/s/q/y "..rtdir..v.." "..dstdir.."\\"..v)
   end
   os.execute("xcopy>nul /i/s/q/y "..rtdir.."doc\\*.txt".." "..dstdir.."\\doc")
   os.execute("copy>nul /y "..rtdir.."*.vim".." "..dstdir)
   os.execute("copy>nul /y "..rtdir.."rgb.txt".." "..dstdir)
   os.execute([[vim --cmd "helptags ]]..dstdir..[[/doc|q"]])
   return
end

-- parse argument options
for i, curarg in ipairs(arg) do
    if curarg == '--help' then
        print("usage: "..arg[0].." [options] [srcdir]")
        os.exit(1)
    elseif curarg:match '^--use-' then
        local name, newarg = curarg:match '^--use-(.+)=(.*)$'
        if not name then
            name = curarg:match '^--use-(.+)$'
        else
            optflags[name] = newarg
        end
        uses[#uses+1] = name
    elseif not curarg:match "^-" then
        flags = curarg .. " " .. flags
    end
end

-- apply vim build options
for i, v in ipairs(uses) do
    if optflags[v] then
        flags = flags .. " " .. optflags[v]
        optflags[v] = nil
    end
end

local function spawn(cmdline)
    cmdline = "cd "..srcdir.." && "..cmdline
    print(cmdline)
    return os.execute(cmdline)
end

-- build
if spawn("nmake -f Make_mvc.mak GUI=yes "..flags) then
    os.execute("copy "..srcdir.."gvim.exe "..dstdir)
    if spawn("nmake -f Make_mvc.mak GUI=no "..flags) then
        os.execute("copy "..srcdir.."vim.exe "..dstdir)
    end
end

