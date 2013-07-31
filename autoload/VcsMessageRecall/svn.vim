" VcsMessageRecall/svn.vim: Repository message store location for Subversion.
"
" DEPENDENCIES:
"   - ingo/fs/path.vim autoload script
"   - ingo/fs/traversal.vim autoload script
"
" Copyright: (C) 2012-2013 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.04.005	01-Jun-2013	Move ingofile.vim into ingo-library.
"   1.04.004	26-Mar-2013	Rename to
"				ingo#fs#traversal#FindLastContainedInUpDir()
"   1.04.003	22-Mar-2013	Factor out s:FindLastContainedInUpDir() to
"				ingo/fstraversal.vim.
"   1.02.002	12-Jul-2012	FIX: Typo in function name breaks Subversion
"				support.
"   1.00.001	25-Jun-2012	file creation

function! VcsMessageRecall#svn#MessageStore()
    " Iterate upwards from CWD until we're in a directory without a .svn
    " directory.
    let l:svnRoot = ingo#fs#traversal#FindLastContainedInUpDir('.svn', expand('%:p:h'))
    if empty(l:svnRoot)
	throw 'VcsMessageRecall: Cannot determine base directory of the Subversion repository!'
    endif

    let l:svnDirspec = ingo#fs#path#Combine(l:svnRoot, '.svn')
    return ingo#fs#path#Combine(l:svnDirspec, 'commit-msgs')
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
