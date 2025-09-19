vim9script

if PlugLoaded('vimcomplete.vim')
    var options = {
        completor: { shuffleEqualPriority: true, postfixHighlight: true, triggerWordLen: 2 },
        buffer: { enable: true, priority: 10, urlComplete: true },
        path: { enable: false },
        abbrev: { enable: true, priority: 10 },
        lsp: { enable: false, priority: 10, maxCount: 5 },
        omnifunc: { enable: true, priority: 8, filetypes: ['c', 'python', 'javascript'] },
        vsnip: { enable: true, priority: 11 },
        vimscript: { enable: true, priority: 11 },
        tag: { enable: true, priority: 11 },
    }

    autocmd VimEnter * g:VimCompleteOptionsSet(options)
endif
