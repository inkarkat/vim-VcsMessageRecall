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
    autocmd FileType gitcommit call MessageRecall#Setup('', '')
    autocmd FileType svn.txt   call MessageRecall#Setup('', '')
augroup END

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
