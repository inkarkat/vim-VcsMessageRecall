" VcsMessageRecall.vim: Browse and re-insert previous VCS commit messages.
"
" DEPENDENCIES:
"   - escapings.vim autoload script
"   - ingofile.vim autoload script
"   - MessageRecall.vim autoload script
"
" Copyright: (C) 2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.00.004	23-Jun-2012	Do the boilerplate search from the start of the
"				buffer and omit any empty lines before the
"				boilerplate.
"				Use message stores that are local to the current
"				repository; it usually doesn't make sense to
"				re-use messages done to a different repository.
"	003	20-Jun-2012	Build filespec with
"				ingofile#CombineToFilespec().
"				Configure new a:options.whenRangeNoMatch to
"				"all": when the commit message boilerplate has
"				been deleted, the entire buffer should be
"				captured.
"	002	18-Jun-2012	Add support for Mercurial.
"	001	11-Jun-2012	file creation

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_VcsMessageRecall') || (v:version < 700)
    finish
endif
let g:loaded_VcsMessageRecall = 1

function! s:GitMessageStore()
    " Git stores the temporary file directly in $GIT_DIR, and we have the
    " environment variable set, anyway.
    return ingofile#CombineToFilespec((exists('$GIT_DIR') ? $GIT_DIR : expand('%:p:h')), 'commit-msgs')
endfunction

function! s:HgMessageStore()
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
function! s:SvnMessageStore()
    " Iterate upwards from CWD until we're in a directory without a .svn
    " directory.
    let l:svnRoot = s:FindLastContainedInUpDir('.svn', expand('%:p:h'))
    if empty(l:svnRoot)
	throw 'VcsMessageRecall: Cannot determine base directory of the Subversion repository!'
    endif

    let l:svnDirspec = ingofile#CombineToFilespec(l:svnRoot, '.svn')
    return ingofile#CombineToFilespec(l:svnDirspec, 'commit-msgs')
endfunction

augroup VcsMessageRecall
    autocmd!
    autocmd FileType gitcommit,gitcommit.* call MessageRecall#Setup(s:GitMessageStore(), {'whenRangeNoMatch': 'all', 'range': '1,1/^\n*# Please enter the commit message for your changes\./-1'})
    autocmd FileType hgcommit,hgcommit.*   call MessageRecall#Setup(s:HgMessageStore() , {'whenRangeNoMatch': 'all', 'range': '1,1/^\n*HG: Enter commit message\./-1'})
    autocmd FileType svn,svn.*             call MessageRecall#Setup(s:SvnMessageStore(), {'whenRangeNoMatch': 'all', 'range': '1,1/^\n*--This line, and those below, will be ignored--/-1'})
augroup END

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
