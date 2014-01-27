function! SendText(text)
    lua <<EOF
    if not winapi then
        package.cpath = package.cpath..";D:/Lua52/clibs/?.dll"
        winapi = require 'winapi'
    end
    local W = winapi
    local f = W.get_foreground_window()
    W.set_encoding(W.CP_UTF8)
    W.set_clipboard(vim.eval("a:text"))
    local w = W.find_window_ex(function(win)
        local t = win:get_text()
        if t and t:match "^YY5.%d+" then
            return true
        end
    end)
    assert(w)
    w:set_foreground()
    w:post_message(513, 0, 35*2^16+200) -- mouse down
    w:post_message(514, 0, 35*2^16+200) -- mouse up
    W.send_to_window(17)
    W.send_to_window(65)
    W.sleep(10)
    W.send_to_window(65, true) -- ctrl-a
    W.send_to_window(86)
    W.sleep(10)
    W.send_to_window(86, true) -- ctrl-v
    W.send_to_window(17, true)
    W.sleep(10)
    W.send_to_window(13)
    W.sleep(10)
    W.send_to_window(13, true) -- enter
    f:set_foreground()
EOF
endfunction

command! -narg=0 -bar SendCurrentLine call SendText(getline("."))
nmap <2-leftmouse> <C-\><C-N>:SendCurrentLine<CR>
nmap <CR> <C-\><C-N>:SendCurrentLine<CR><down>


