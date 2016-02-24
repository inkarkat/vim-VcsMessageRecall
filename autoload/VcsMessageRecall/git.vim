" VcsMessageRecall/git.vim: Repository message store location for Git.
"
" DEPENDENCIES:
"   - ingo/fs/path.vim autoload script
"
" Copyright: (C) 2012-2013 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.04.002	01-Jun-2013	Move ingofile.vim into ingo-library.
"   1.00.001	25-Jun-2012	file creation

function! VcsMessageRecall#git#MessageStore()
    " Git stores the temporary file directly in $GIT_DIR, and we have the
    " environment variable set, anyway.
    return ingo#fs#path#Combine((exists('$GIT_DIR') ? $GIT_DIR : expand('%:p:h')), 'commit-msgs')
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
