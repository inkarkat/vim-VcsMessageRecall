" VcsMessageRecall/svn.vim: Repository message store location for Subversion.
"
" DEPENDENCIES:
"   - ingo/fs/path.vim autoload script
"   - ingo/fs/traversal.vim autoload script
"
" Copyright: (C) 2012-2014 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.04.007	18-Jul-2014	Support Subversion 1.7 repository layout with
"				only a single .svn directory inside the working
"				copy root.
"   1.04.006	01-Aug-2013	ingo#fs#traversal#FindLastContainedInUpDir now
"				defaults to the current buffer's directory; omit
"				the argument.
"   1.04.005	01-Jun-2013	Move ingofile.vim into ingo-library.
"   1.04.004	26-Mar-2013	Rename to
"				ingo#fs#traversal#FindLastContainedInUpDir()
"   1.04.003	22-Mar-2013	Factor out s:FindLastContainedInUpDir() to
"				ingo/fstraversal.vim.
"   1.02.002	12-Jul-2012	FIX: Typo in function name breaks Subversion
"				support.
"   1.00.001	25-Jun-2012	file creation

function! VcsMessageRecall#svn#MessageStore()
    if isdirectory(ingo#fs#path#Combine(expand('%:p:h'), '.svn'))
	" Detection for Subversion <= 1.6 (where there are .svn directories in
	" every directory of the working copy), or when in the working copy
	" root.

	" Iterate upwards from CWD until we're in a directory without a .svn
	" directory.
	let l:svnRoot = ingo#fs#traversal#FindLastContainedInUpDir('.svn')
	if empty(l:svnRoot)
	    throw 'VcsMessageRecall: Cannot determine base directory of the Subversion repository!'
	endif

	let l:svnDirspec = ingo#fs#path#Combine(l:svnRoot, '.svn')
    else
	" Detection for Subversion >= 1.7, where there's only a single .svn
	" directory in the working copy root.
	let l:svnDirspec = finddir('.svn', '.;')
	if empty(l:svnDirspec)
	    throw 'VcsMessageRecall: Cannot determine base directory of the Subversion repository!'
	endif
    endif

    return ingo#fs#path#Combine(l:svnDirspec, 'commit-msgs')
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
