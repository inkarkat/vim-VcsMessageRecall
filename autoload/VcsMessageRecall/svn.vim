" VcsMessageRecall/svn.vim: Repository message store location for Subversion.
"
" DEPENDENCIES:
"   - ingofile.vim autoload script
"
" Copyright: (C) 2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.02.002	12-Jul-2012	FIX: Typo in function name breaks Subversion
"				support.
"   1.00.001	25-Jun-2012	file creation

function! s:FindLastContainedInUpDir( name, path )
    let l:dir = a:path
    let l:prevDir = ''
    while l:dir !=# l:prevDir
	if empty(globpath(l:dir, a:name, 1))
	    return l:prevDir
	endif
	let l:prevDir = l:dir
	let l:dir = fnamemodify(l:dir, ':h')
	if (has('win32') || has('win64')) && l:dir =~ '^\\\\[^\\]\+$'
	    break
	endif
    endwhile

    return l:dir
endfunction
function! VcsMessageRecall#svn#MessageStore()
    " Iterate upwards from CWD until we're in a directory without a .svn
    " directory.
    let l:svnRoot = s:FindLastContainedInUpDir('.svn', expand('%:p:h'))
    if empty(l:svnRoot)
	throw 'VcsMessageRecall: Cannot determine base directory of the Subversion repository!'
    endif

    let l:svnDirspec = ingofile#CombineToFilespec(l:svnRoot, '.svn')
    return ingofile#CombineToFilespec(l:svnDirspec, 'commit-msgs')
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
