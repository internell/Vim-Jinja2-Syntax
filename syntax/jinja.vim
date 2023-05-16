" Vim syntax file
" Language:	Jinja template
" Maintainer:	Armin Ronacher <armin.ronacher@active-4.com>
" Last Change:	2008 May 9
" Version:      1.1
"
" Known Bugs:
"   because of odd limitations dicts and the modulo operator
"   appear wrong in the template.
"
" Changes:
"
"     2008 May 9:     Added support for Jinja 2 changes (new keyword rules)

" .vimrc variable to disable html highlighting
if !exists('g:jinjaalt_syntax_html')
  let g:jinjaalt_syntax_html=1
endif

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if !exists("main_syntax")
  if v:version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'jinjaalt'
endif

" Pull in the HTML syntax.
if g:jinjaalt_syntax_html
  if v:version < 600
    so <sfile>:p:h/html.vim
  else
    let ext = expand('%:e')
    if ext !~ 'htm\|nunj|jinja\|j2' &&
          \ findfile(ext . '.vim', $VIMRUNTIME . '/syntax') != ''
      execute 'runtime! syntax/' . ext . '.vim'
    else
      runtime! syntax/html.vim
    endif
    unlet b:current_syntax
  endif
endif

syntax case match

" Jinja template built-in tags and parameters (without filter, macro, is and raw, they
" have special threatment)
syn keyword jinjaAltStatement containedin=jinjaAltVarBlock,jinjaAltTagBlock,jinjaAltNested contained and if else in not or recursive as import

syn keyword jinjaAltStatement containedin=jinjaAltVarBlock,jinjaAltTagBlock,jinjaAltNested contained is filter skipwhite nextgroup=jinjaAltFilter
syn keyword jinjaAltStatement containedin=jinjaAltTagBlock contained macro skipwhite nextgroup=jinjaAltFunction
syn keyword jinjaAltStatement containedin=jinjaAltTagBlock contained block skipwhite nextgroup=jinjaAltBlockName

" Variable Names
syn match jinjaAltVariable containedin=jinjaAltVarBlock,jinjaAltTagBlock,jinjaAltNested contained /[a-zA-Z_][a-zA-Z0-9_]*/
syn keyword jinjaAltSpecial containedin=jinjaAltVarBlock,jinjaAltTagBlock,jinjaAltNested contained false true none False True None loop super caller varargs kwargs

" Filters
syn match jinjaAltOperator "|" containedin=jinjaAltVarBlock,jinjaAltTagBlock,jinjaAltNested contained skipwhite nextgroup=jinjaAltFilter
syn match jinjaAltFilter contained /[a-zA-Z_][a-zA-Z0-9_]*/
syn match jinjaAltFunction contained /[a-zA-Z_][a-zA-Z0-9_]*/
syn match jinjaAltBlockName contained /[a-zA-Z_][a-zA-Z0-9_]*/

" Jinja template constants
syn region jinjaAltString containedin=jinjaAltVarBlock,jinjaAltTagBlock,jinjaAltNested contained start=/"/ skip=/\(\\\)\@<!\(\(\\\\\)\@>\)*\\"/ end=/"/
syn region jinjaAltString containedin=jinjaAltVarBlock,jinjaAltTagBlock,jinjaAltNested contained start=/'/ skip=/\(\\\)\@<!\(\(\\\\\)\@>\)*\\'/ end=/'/
syn match jinjaAltNumber containedin=jinjaAltVarBlock,jinjaAltTagBlock,jinjaAltNested contained /[0-9]\+\(\.[0-9]\+\)\?/

" Operators
syn match jinjaAltOperator containedin=jinjaAltVarBlock,jinjaAltTagBlock,jinjaAltNested contained /[+\-*\/<>=!,:]/
syn match jinjaAltPunctuation containedin=jinjaAltVarBlock,jinjaAltTagBlock,jinjaAltNested contained /[()\[\]]/
syn match jinjaAltOperator containedin=jinjaAltVarBlock,jinjaAltTagBlock,jinjaAltNested contained /\./ nextgroup=jinjaAltAttribute
syn match jinjaAltAttribute contained /[a-zA-Z_][a-zA-Z0-9_]*/

" Jinja template tag and variable blocks
syn region jinjaAltNested matchgroup=jinjaAltOperator start="(" end=")" transparent display containedin=jinjaAltVarBlock,jinjaAltTagBlock,jinjaAltNested contained
syn region jinjaAltNested matchgroup=jinjaAltOperator start="\[" end="\]" transparent display containedin=jinjaAltVarBlock,jinjaAltTagBlock,jinjaAltNested contained
" syn region jinjaAltNested matchgroup=jinjaAltOperator start="{" end="}" transparent display containedin=jinjaAltVarBlock,jinjaAltTagBlock,jinjaAltNested contained
syn region jinjaAltTagBlock matchgroup=jinjaAltTagDelim start=/\[%[-+]\?/ end=/[-+]\?%\]/ containedin=ALLBUT,jinjaAltTagBlock,jinjaAltVarBlock,jinjaAltRaw,jinjaAltString,jinjaAltNested,jinjaAltComment

syn region jinjaAltVarBlock matchgroup=jinjaAltVarDelim start=/\[\[-\?/ end=/-\?\]\]/ containedin=ALLBUT,jinjaAltTagBlock,jinjaAltVarBlock,jinjaAltRaw,jinjaAltString,jinjaAltNested,jinjaAltComment

" Jinja template 'raw' tag
syn region jinjaAltRaw matchgroup=jinjaAltRawDelim start="\[%\s*raw\s*%\]" end="\[%\s*endraw\s*%\]" containedin=ALLBUT,jinjaAltTagBlock,jinjaAltVarBlock,jinjaAltString,jinjaAltComment

" Jinja comments
syn region jinjaAltComment matchgroup=jinjaAltCommentDelim start="\[#" end="#\]" containedin=ALLBUT,jinjaAltTagBlock,jinjaAltVarBlock,jinjaAltString,jinjaAltComment

" Block start keywords.  A bit tricker.  We only highlight at the start of a
" tag block and only if the name is not followed by a comma or equals sign
" which usually means that we have to deal with an assignment.
syn match jinjaAltStatement containedin=jinjaAltTagBlock contained /\(\[%[-+]\?\s*\)\@<=\<[a-zA-Z_][a-zA-Z0-9_]*\>\(\s*[,=]\)\@!/

" and context modifiers
syn match jinjaAltStatement containedin=jinjaAltTagBlock contained /\<with\(out\)\?\s\+context\>/


" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if v:version >= 508 || !exists("did_jinjaalt_syn_inits")
  if v:version < 508
    let did_jinjaalt_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink jinjaAltPunctuation jinjaAltOperator
  HiLink jinjaAltAttribute jinjaAltVariable
  HiLink jinjaAltFunction jinjaAltFilter

  HiLink jinjaAltTagDelim jinjaAltTagBlock
  HiLink jinjaAltVarDelim jinjaAltVarBlock
  HiLink jinjaAltCommentDelim jinjaAltComment
  HiLink jinjaAltRawDelim jinjaAlt

  HiLink jinjaAltSpecial Special
  HiLink jinjaAltOperator Normal
  HiLink jinjaAltRaw Normal
  HiLink jinjaAltTagBlock PreProc
  HiLink jinjaAltVarBlock PreProc
  HiLink jinjaAltStatement Statement
  HiLink jinjaAltFilter Function
  HiLink jinjaAltBlockName Function
  HiLink jinjaAltVariable Identifier
  HiLink jinjaAltString Constant
  HiLink jinjaAltNumber Constant
  HiLink jinjaAltComment Comment

  delcommand HiLink
endif

let b:current_syntax = "jinjaalt"

if main_syntax ==# 'jinjaalt'
  unlet main_syntax
endif
