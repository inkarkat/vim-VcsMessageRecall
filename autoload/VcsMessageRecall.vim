" VcsMessageRecall.vim: Browse and re-insert previous VCS commit messages.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin
"
" Copyright: (C) 2012-2022 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
let s:save_cpo = &cpo
set cpo&vim

function! VcsMessageRecall#Setup( MessageStore, vcsMetaDataDirName, boilerplateStartLinePattern ) abort
    try
	if MessageRecall#IsStoredMessage(expand('%'))
	    " Avoid recursive setup when a stored message is edited.
	    " MessageRecall#Setup() has the same guard, but we already want to
	    " avoid determining the message store (since that costs time / may
	    " produce an error).
	    return
	endif

	if type(a:MessageStore) == type(function('tr'))
	    let l:messageStore = call(a:MessageStore, [])
	else
	    let l:messageStore = a:MessageStore
	endif

	call s:ConfigureAdjacentMessageStores(l:messageStore)

	let l:messageRecallOptions = {
	\   'whenRangeNoMatch': 'all',
	\   'range': printf('1,1/\n\zs\n*%s/-1', a:boilerplateStartLinePattern),
	\   'subDirForUserProvidedDirspec': (empty(a:vcsMetaDataDirName) ? '' : ingo#fs#path#Combine(a:vcsMetaDataDirName, g:VcsMessageRecall_StoreDirName)),
	\}

	call MessageRecall#Setup(l:messageStore, l:messageRecallOptions)
    catch /^VcsMessageRecall:/
	call ingo#msg#CustomExceptionMsg('VcsMessageRecall')
    catch /^MessageRecall:/
	call ingo#msg#CustomExceptionMsg('MessageRecall')
    endtry
endfunction

function! VcsMessageRecall#GetStoreName( absoluteStoreDirspec ) abort
    return fnamemodify(a:absoluteStoreDirspec, ':h:h:h:t')
endfunction
function! s:ConfigureAdjacentMessageStores( messageStore ) abort
    let l:absoluteMessageStore = fnamemodify(a:messageStore, ':p')
    " Assumption: There's one version control system metadata subdirectory and
    " then the commit-msgs subdir in it, so two directories up is the working
    " copy root.
    let l:workingCopyRootParentDirspec = fnamemodify(l:absoluteMessageStore, ':h:h:h:h')
    let l:relativeMessageStorePath = ingo#fs#path#split#AtBasePath(l:absoluteMessageStore, fnamemodify(l:absoluteMessageStore, ':h:h:h'))

    let l:otherMessageStoreDirspecs =
    \   filter(
    \       ingo#compat#glob(ingo#fs#path#Combine(l:workingCopyRootParentDirspec, '*', l:relativeMessageStorePath), 1, 1),
    \       '! ingo#fs#path#Equals(v:val, l:absoluteMessageStore)'
    \   )

    let l:otherMessageStores = ingo#dict#FromValues(function("VcsMessageRecall#GetStoreName"), l:otherMessageStoreDirspecs)
    if ! empty(l:otherMessageStores) && ! exists('b:MessageRecall_ConfiguredMessageStores')
	let b:MessageRecall_ConfiguredMessageStores = l:otherMessageStores
    endif
"****D echomsg '****' string(a:messageStore) string(l:workingCopyRootParentDirspec) string(l:relativeMessageStorePath)
"****D echomsg '****' string(l:otherMessageStores)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
