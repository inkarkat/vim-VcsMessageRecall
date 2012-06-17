" VcsMessageRecall.vim: summary
"
" DEPENDENCIES:
"
" Copyright: (C) 2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	001	11-Jun-2012	file creation

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_VcsMessageRecall') || (v:version < 700)
    finish
endif
let g:loaded_VcsMessageRecall = 1

augroup VcsMessageRecall
    autocmd!
    autocmd FileType gitcommit call MessageRecall#Setup($HOME . '/.gitcommit-messages', '1,/^# Please enter the commit message for your changes\./-1')
    autocmd FileType svn.txt   call MessageRecall#Setup($HOME . '/.svncommit-messages', '1,/^--This line, and those below, will be ignored--/-1')
augroup END

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
