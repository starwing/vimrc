-- options --
local dstdir = [[\Vim\vim74]]
local srcdir = [[\Work\Sources\Vim\src\]]
local flags  = [[IME=yes CSCOPE=yes OLE=yes WINVER=0x0500]]
local optflags = {
    user    = [[USERNAME=SW USERDOMAIN=SB_DiaoSi_Mo]],
    sdkdir   = [[SDK_INCLUDE_DIR="C:\Program Files\Microsoft SDKs\Windows\v7.1\Include"]],
    sdkdir64 = [[SDK_INCLUDE_DIR="C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\Include"]],
    lua     = [[LUA=\Lua52 DYNAMIC_LUA=yes LUA_VER=52]],
    mz      = [[MZSCHEME=\Racket DYNAMIC_MZSCHEME=yes MZSCHEME_VER=3m_9x82yo]],
    perl    = [[PERL=\perl DYNAMIC_PERL=yes PERL_VER=516]],
    python  = [[PYTHON=\python27 DYNAMIC_PYTHON=yes PYTHON_VER=27]],
    python3 = [[PYTHON3=\python34 DYNAMIC_PYTHON3=yes PYTHON3_VER=34]],
    ruby    = [[RUBY=\ruby191 DYNAMIC_RUBY=yes RUBY_VER=191 RUBY_VER_LONG=1.9.1]],
    tcl     = [[TCL=\Tcl DYNAMIC_TCL=yes TCL_VER=86 TCL_VER_LONG=8.6]],
}
local uses = { "user", "sdkdir64", "lua", "perl", "python", "python3", "tcl" }
-- end --

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
