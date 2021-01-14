" VcsMessageRecall/git.vim: Repository message store location for Git.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin
"
" Copyright: (C) 2012-2021 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

function! VcsMessageRecall#git#MessageStore()
    " Git stores the temporary file directly in $GIT_DIR, and we have the
    " environment variable set, anyway.
    return ingo#fs#path#Combine((exists('$GIT_DIR') ? $GIT_DIR : expand('%:p:h')), g:VcsMessageRecall_StoreDirName)
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
