" ANSI C Functions
"
" Standard I/O functions {{{
syntax keyword stdFunction clearerr
syntax keyword stdFunction fclose
syntax keyword stdFunction feof
syntax keyword stdFunction ferror
syntax keyword stdFunction fflush
syntax keyword stdFunction fgetc
syntax keyword stdFunction fgetpos
syntax keyword stdFunction fgets
syntax keyword stdFunction fopen
syntax keyword stdFunction fprintf
syntax keyword stdFunction fputc
syntax keyword stdFunction fputs
syntax keyword stdFunction fread
syntax keyword stdFunction freopen
syntax keyword stdFunction fscanf
syntax keyword stdFunction fseek
syntax keyword stdFunction fsetpos
syntax keyword stdFunction ftell
syntax keyword stdFunction fwrite
syntax keyword stdFunction getc
syntax keyword stdFunction getchar
syntax keyword stdFunction gets
syntax keyword stdFunction perror
syntax keyword stdFunction printf
syntax keyword stdFunction putc
syntax keyword stdFunction putchar
syntax keyword stdFunction puts
syntax keyword stdFunction remove
syntax keyword stdFunction rename
syntax keyword stdFunction rewind
syntax keyword stdFunction scanf
syntax keyword stdFunction setbuf
syntax keyword stdFunction setvbuf
syntax keyword stdFunction snprintf
syntax keyword stdFunction sprintf
syntax keyword stdFunction sscanf
syntax keyword stdFunction tmpfile
syntax keyword stdFunction tmpnam
syntax keyword stdFunction ungetc
syntax keyword stdFunction vprintf
syntax keyword stdFunction vfprintf
syntax keyword stdFunction vsprintf
syntax keyword stdFunction vsnprintf
syntax keyword stdFunction vscanf
syntax keyword stdFunction vfscanf
syntax keyword stdFunction vsscanf
" }}}

" String and character functions {{{
syntax keyword stdFunction isalnum
syntax keyword stdFunction isalpha
syntax keyword stdFunction isblank
syntax keyword stdFunction iscntrl
syntax keyword stdFunction isdigit
syntax keyword stdFunction isgraph
syntax keyword stdFunction islower
syntax keyword stdFunction isprint
syntax keyword stdFunction ispunct
syntax keyword stdFunction isspace
syntax keyword stdFunction isupper
syntax keyword stdFunction isxdigit
syntax keyword stdFunction memchr
syntax keyword stdFunction memcmp
syntax keyword stdFunction memcpy
syntax keyword stdFunction memmove
syntax keyword stdFunction memset
syntax keyword stdFunction strcat
syntax keyword stdFunction strchr
syntax keyword stdFunction strcmp
syntax keyword stdFunction strcoll
syntax keyword stdFunction strcpy
syntax keyword stdFunction strcspn
syntax keyword stdFunction strerror
syntax keyword stdFunction strlen
syntax keyword stdFunction strncat
syntax keyword stdFunction strncmp
syntax keyword stdFunction strncpy
syntax keyword stdFunction strpbrk
syntax keyword stdFunction strrchr
syntax keyword stdFunction strspn
syntax keyword stdFunction strstr
syntax keyword stdFunction strtok
syntax keyword stdFunction strxfrm
syntax keyword stdFunction tolower
syntax keyword stdFunction toupper
" }}}

" Mathematical Functions {{{
syntax keyword stdFunction acos
syntax keyword stdFunction acosh
syntax keyword stdFunction asin
syntax keyword stdFunction asinh
syntax keyword stdFunction atan
syntax keyword stdFunction atanh
syntax keyword stdFunction atan2
syntax keyword stdFunction cbrt
syntax keyword stdFunction ceil
syntax keyword stdFunction copy
syntax keyword stdFunction sign
syntax keyword stdFunction cos
syntax keyword stdFunction cosh
syntax keyword stdFunction erf
syntax keyword stdFunction erfc
syntax keyword stdFunction exp
syntax keyword stdFunction exp2
syntax keyword stdFunction expm1
syntax keyword stdFunction fabs
syntax keyword stdFunction fdim
syntax keyword stdFunction floor
syntax keyword stdFunction fma
syntax keyword stdFunction fmax
syntax keyword stdFunction fmin
syntax keyword stdFunction fmod
syntax keyword stdFunction frexp
syntax keyword stdFunction hypot
syntax keyword stdFunction ilogb
syntax keyword stdFunction ldexp
syntax keyword stdFunction lgamma
syntax keyword stdFunction llrint
syntax keyword stdFunction llround
syntax keyword stdFunction log
syntax keyword stdFunction log1p
syntax keyword stdFunction log10
syntax keyword stdFunction log2
syntax keyword stdFunction logb
syntax keyword stdFunction lrint
syntax keyword stdFunction lround
syntax keyword stdFunction modf
syntax keyword stdFunction nan
syntax keyword stdFunction nearbyint
syntax keyword stdFunction nextafter
syntax keyword stdFunction nexttoward
syntax keyword stdFunction pow
syntax keyword stdFunction remainder
syntax keyword stdFunction remquo
syntax keyword stdFunction rint
syntax keyword stdFunction round
syntax keyword stdFunction scalbn
syntax keyword stdFunction scalbln
syntax keyword stdFunction sin
syntax keyword stdFunction sinh
syntax keyword stdFunction sqrt
syntax keyword stdFunction tan
syntax keyword stdFunction tanh
syntax keyword stdFunction tgamma
syntax keyword stdFunction trunc
" }}}

" Time Date and Localization Functions {{{
syntax keyword stdFunction asctime
syntax keyword stdFunction clock
syntax keyword stdFunction ctime
syntax keyword stdFunction difftime
syntax keyword stdFunction gmtime
syntax keyword stdFunction localeconv
syntax keyword stdFunction localtime
syntax keyword stdFunction mktime
syntax keyword stdFunction setlocale
syntax keyword stdFunction strftime
syntax keyword stdFunction time
" }}}

" Dymanic Allocation Functions {{{
syntax keyword stdFunction calloc
syntax keyword stdFunction free
syntax keyword stdFunction malloc
syntax keyword stdFunction realloc
" }}}

" Miscellaneous Functions {{{
syntax keyword stdFunction abort
syntax keyword stdFunction abs
syntax keyword stdFunction assert
syntax keyword stdFunction atexit
syntax keyword stdFunction atof
syntax keyword stdFunction atoi
syntax keyword stdFunction atol
syntax keyword stdFunction atoll
syntax keyword stdFunction bsearch
syntax keyword stdFunction div
syntax keyword stdFunction exit
syntax keyword stdFunction _Exit
syntax keyword stdFunction getenv
syntax keyword stdFunction labs
syntax keyword stdFunction ldiv
syntax keyword stdFunction llabs
syntax keyword stdFunction lldiv
syntax keyword stdFunction longjmp
syntax keyword stdFunction mblen
syntax keyword stdFunction mbstowcs
syntax keyword stdFunction mbtowc
syntax keyword stdFunction qsort
syntax keyword stdFunction raise
syntax keyword stdFunction rand
syntax keyword stdFunction setjmp
syntax keyword stdFunction signal
syntax keyword stdFunction srand
syntax keyword stdFunction strtod
syntax keyword stdFunction strtof
syntax keyword stdFunction strtol
syntax keyword stdFunction strtold
syntax keyword stdFunction strtoll
syntax keyword stdFunction strtoul
syntax keyword stdFunction strtoull
syntax keyword stdFunction system
syntax keyword stdFunction va_arg
syntax keyword stdFunction va_start
syntax keyword stdFunction va_end
syntax keyword stdFunction va_copy
syntax keyword stdFunction wcstombs
syntax keyword stdFunction wctomb
" }}}

" Default highlighting {{{
if version >= 508 || !exists("did_c_ansi_syntax_inits")
  if version < 508
    let did_c_ansi_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink stdFunction            cFunction
  delcommand HiLink
endif
" }}}

" vim: fdm=marker


