" VcsMessageRecall.vim: Browse and re-insert previous VCS commit messages.
"
" DEPENDENCIES:
"   - Requires Vim 7.0 or higher.
"
" Copyright: (C) 2012-2024 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_VcsMessageRecall') || (v:version < 700)
    finish
endif
let g:loaded_VcsMessageRecall = 1
let s:save_cpo = &cpo
set cpo&vim

"- configuration ---------------------------------------------------------------

if ! exists('g:VcsMessageRecall_StoreDirName')
    let g:VcsMessageRecall_StoreDirName = 'commit-msgs'
endif

if ! exists('g:VcsMessageRecall_git_MessageTrailerPattern')
    let g:VcsMessageRecall_git_MessageTrailerPattern = '[[:upper:]][[:alnum:]-]*:'
endif
let s:gitTrailerPattern = (empty(g:VcsMessageRecall_git_MessageTrailerPattern)
\   ? ''
\   : printf('\%%(\%%(%s\)[^\n]*\n\%%(\s\+[^\n]*\n\)*\)*', g:VcsMessageRecall_git_MessageTrailerPattern)
\)
if ! exists('g:VcsMessageRecall_git_MessageRecallOptions')
    let g:VcsMessageRecall_git_MessageRecallOptions = {
    \   'ignorePattern': "^Merge branch\\%(es\\)\\? '[^\\n]*'\\%( into [^\\n]\\+\\)\\?\\n*$",
    \   'replacedMessageRegister': '"',
    \}
endif
if ! exists('g:VcsMessageRecall_hg_MessageRecallOptions')
    let g:VcsMessageRecall_hg_MessageRecallOptions = {}
endif
if ! exists('g:VcsMessageRecall_svn_MessageRecallOptions')
    let g:VcsMessageRecall_svn_MessageRecallOptions = {}
endif

if ! exists('g:VcsMessageRecall_git_AdjacentMessageStores')
    let g:VcsMessageRecall_git_AdjacentMessageStores = function('VcsMessageRecall#ObtainSubmoduleAwareMessageStores')
endif
if ! exists('g:VcsMessageRecall_hg_AdjacentMessageStores')
    let g:VcsMessageRecall_hg_AdjacentMessageStores = function('VcsMessageRecall#ObtainAdjacentMessageStores')
endif
if ! exists('g:VcsMessageRecall_svn_AdjacentMessageStores')
    let g:VcsMessageRecall_svn_AdjacentMessageStores = function('VcsMessageRecall#ObtainAdjacentMessageStores')
endif


"- autocmds --------------------------------------------------------------------

augroup VcsMessageRecall
    autocmd!
    autocmd FileType gitcommit,gitcommit.* call VcsMessageRecall#Setup(function('VcsMessageRecall#git#MessageStore'), '.git', s:gitTrailerPattern . '# \%(Please enter \%(a\|the\) commit message\|It looks like you may be committing a merge\.\)', g:VcsMessageRecall_git_MessageRecallOptions, g:VcsMessageRecall_git_AdjacentMessageStores)
    autocmd FileType hgcommit,hgcommit.*   call VcsMessageRecall#Setup(function('VcsMessageRecall#hg#MessageStore' ), '.hg', 'HG: Enter commit message\.', g:VcsMessageRecall_hg_MessageRecallOptions, g:VcsMessageRecall_hg_AdjacentMessageStores)
    autocmd FileType svn,svn.*             call VcsMessageRecall#Setup(function('VcsMessageRecall#svn#MessageStore'), '.svn', '--This line, and those below, will be ignored--', g:VcsMessageRecall_svn_MessageRecallOptions, g:VcsMessageRecall_svn_AdjacentMessageStores)
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
