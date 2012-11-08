" VcsMessageRecall/hg.vim: Repository message store location for Mercurial.
"
" DEPENDENCIES:
"   - escapings.vim autoload script
"   - ingofile.vim autoload script
"
" Copyright: (C) 2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.00.001	25-Jun-2012	file creation

function! VcsMessageRecall#hg#MessageStore()
    " Mercurial stores the temporary file in the temp directory.
    " With 'autochdir', we have to go to the launching directory first.
    " Otherwise, just try with the CWD, it's likely that we're inside the repo.
    " The Mercurial command "hg root" tells us the root of the repository.
    let l:hgRoot = ''
    let l:hgDirspec = ''
    if ! &autochdir
	let l:hgRoot = system('hg root')
    endif
    if empty(l:hgRoot)
	let l:hgRoot = system('cd ' . escapings#shellescape($PWD) . '&& hg root')
    endif
    if empty(l:hgRoot)
	let l:hgDirspec = finddir('.hg', ';')
    endif
    if empty(l:hgRoot) && empty(l:hgDirspec)
	throw 'VcsMessageRecall: Cannot determine base directory of the Mercurial repository!'
    elseif empty(l:hgDirspec)
	let l:hgDirspec = ingofile#CombineToFilespec(l:hgRoot, '.hg')
    endif

    return ingofile#CombineToFilespec(l:hgDirspec, 'commit-msgs')
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
