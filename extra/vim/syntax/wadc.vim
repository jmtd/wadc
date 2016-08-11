" Vim syntax file
" Language:     WadC
" Author:       Jonatan Dowland <jon@dow.land>
" URL:          https://jmtd.net/wadc/
" Licence:      GPL-2 (http://www.gnu.org)
" Remarks:      Vim 6 or greater

" Quit when a (custom) syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

syn clear

syn keyword     wadcTodo            contained TODO FIXME XXX BUG
syn cluster     wadcCommentGroup    contains=wadcTodo
syn region      wadcComment         start="/\*" end="\*/" contains=@wadcCommentGroup
syn region      wadcComment         start="--" end="$" contains=@wadcCommentGroup
hi def link     wadcComment         Comment
hi def link     wadcTodo            Todo

syn region      wadcInclude         start="^#\"" end="$"
hi def link     wadcInclude         Include

syn region      wadcString          start="\"" end="\""
hi def link     wadcString          String

" not working yet
syn match       wadcNumber          display contained "\d\+"
hi def link     wadcNumber          Number
