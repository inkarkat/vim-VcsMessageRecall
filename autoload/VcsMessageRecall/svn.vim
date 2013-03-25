" VcsMessageRecall/svn.vim: Repository message store location for Subversion.
"
" DEPENDENCIES:
"   - ingo/fstraversal.vim autoload script
"   - ingofile.vim autoload script
"
" Copyright: (C) 2012-2013 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.04.003	22-Mar-2013	Factor out s:FindLastContainedInUpDir() to
"				ingo/fstraversal.vim.
"   1.02.002	12-Jul-2012	FIX: Typo in function name breaks Subversion
"				support.
"   1.00.001	25-Jun-2012	file creation

function! VcsMessageRecall#svn#MessageStore()
    " Iterate upwards from CWD until we're in a directory without a .svn
    " directory.
    let l:svnRoot = ingo#fstraversal#FindLastContainedInUpDir('.svn', expand('%:p:h'))
    if empty(l:svnRoot)
	throw 'VcsMessageRecall: Cannot determine base directory of the Subversion repository!'
    endif

    let l:svnDirspec = ingofile#CombineToFilespec(l:svnRoot, '.svn')
    return ingofile#CombineToFilespec(l:svnDirspec, 'commit-msgs')
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
