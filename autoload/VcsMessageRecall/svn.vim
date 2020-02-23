" VcsMessageRecall/svn.vim: Repository message store location for Subversion.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin
"
" Copyright: (C) 2012-2020 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

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
