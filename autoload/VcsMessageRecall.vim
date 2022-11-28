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

function! VcsMessageRecall#Setup( MessageStore, vcsMetaDataDirName, boilerplateStartLinePattern, messageRecallOptions, AdjacentMessageStores ) abort
    try
	if MessageRecall#IsStoredMessage(expand('%'))
	    " Avoid recursive setup when a stored message is edited.
	    " MessageRecall#Setup() has the same guard, but we already want to
	    " avoid determining the message store (since that costs time / may
	    " produce an error).
	    return
	endif

	let l:messageStore = ingo#actions#ValueOrFunc(a:MessageStore)
	if ! exists('b:MessageRecall_ConfiguredMessageStores') && ! empty(a:AdjacentMessageStores)
	    let l:adjacentMessageStores = call(a:AdjacentMessageStores, [l:messageStore])
	    if ! empty(l:adjacentMessageStores)
		let b:MessageRecall_ConfiguredMessageStores = l:adjacentMessageStores
	    endif
	endif

	let l:messageRecallOptions = {
	\   'whenRangeNoMatch': 'all',
	\   'range': printf('1,1/\n\zs\n*%s/-1', a:boilerplateStartLinePattern),
	\   'subDirForUserProvidedDirspec': (empty(a:vcsMetaDataDirName) ? '' : ingo#fs#path#Combine(a:vcsMetaDataDirName, g:VcsMessageRecall_StoreDirName)),
	\}
	call extend(l:messageRecallOptions, a:messageRecallOptions, 'force')

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
function! VcsMessageRecall#ObtainAdjacentMessageStores( messageStore ) abort
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

    return ingo#dict#FromValues(function('VcsMessageRecall#GetStoreName'), l:otherMessageStoreDirspecs)
"****D echomsg '****' string(a:messageStore) string(l:workingCopyRootParentDirspec) string(l:relativeMessageStorePath)
endfunction

function! VcsMessageRecall#GetSubmoduleStoreName( absoluteStoreDirspec ) abort
    return fnamemodify(a:absoluteStoreDirspec, ':h:t')
endfunction
function! VcsMessageRecall#ObtainSubmoduleMessageStores( messageStore ) abort
    let l:absoluteMessageStore = fnamemodify(a:messageStore, ':p')
    " Assumption: There's one version control system metadata subdirectory and
    " then the commit-msgs subdir in it, so two directories up is the working
    " copy root.
    let l:moduleDirspec = ingo#fs#path#Combine(fnamemodify(l:absoluteMessageStore, ':h:h'), 'modules')
    if ! isdirectory(l:moduleDirspec)
	return {}
    endif

    let l:submoduleMessageStoreDirspecs = ingo#compat#glob(ingo#fs#path#Combine(l:moduleDirspec, '*', g:VcsMessageRecall_StoreDirName), 1, 1)

    return ingo#dict#FromValues(function('VcsMessageRecall#GetSubmoduleStoreName'), l:submoduleMessageStoreDirspecs)
endfunction
function! VcsMessageRecall#ObtainAdjacentSubmoduleMessageStores( messageStore ) abort
    let l:absoluteMessageStore = fnamemodify(a:messageStore, ':p')
    let l:moduleDirspec = ingo#fs#path#Combine(fnamemodify(l:absoluteMessageStore, ':h:h:h:h'), 'modules')
    if ! isdirectory(l:moduleDirspec)
	return {}
    endif

    let l:submoduleMessageStoreDirspecs = ingo#compat#glob(ingo#fs#path#Combine(l:moduleDirspec, '*', g:VcsMessageRecall_StoreDirName), 1, 1)

    return ingo#dict#FromValues(function('VcsMessageRecall#GetSubmoduleStoreName'), l:submoduleMessageStoreDirspecs)
endfunction
function! VcsMessageRecall#ObtainSuperProjectMessageStores( messageStore ) abort
    let l:absoluteMessageStore = fnamemodify(a:messageStore, ':p')
    if ! fnamemodify(l:absoluteMessageStore, ':h:h:t') ==# 'modules'
	return {}
    endif

    let l:superProjectMessageStoreDirspec = ingo#fs#path#Combine(fnamemodify(l:absoluteMessageStore, ':h:h:h:h'), g:VcsMessageRecall_StoreDirName)
    let l:superProjectName = fnamemodify(l:absoluteMessageStore, ':h:h:h:h:h:t')

    return {l:superProjectName : l:superProjectMessageStoreDirspec}
endfunction
function! VcsMessageRecall#ObtainSubmoduleAwareMessageStores( messageStore ) abort
    " Submodules take precedence over adjacent working copies.
    let l:result = VcsMessageRecall#ObtainSubmoduleMessageStores(a:messageStore)
    if empty(l:result)
	" There are no commit messages for submodules; try adjacent working copies.
	let l:result = VcsMessageRecall#ObtainAdjacentMessageStores(a:messageStore)
	if empty(l:result)
	    " If no adjacent working copies are found, it could be because we're
	    " in a submodule right now; paths to adjacent submodules are
	    " slightly different.
	    let l:result = VcsMessageRecall#ObtainAdjacentSubmoduleMessageStores(a:messageStore)
	    " Also include the superproject's commit message; we may want to
	    " recall in that direction as well.
	    call extend(l:result, VcsMessageRecall#ObtainSuperProjectMessageStores(a:messageStore))
	endif
    endif
    return l:result
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
