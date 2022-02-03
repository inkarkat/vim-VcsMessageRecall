" VcsMessageRecall.vim: Browse and re-insert previous VCS commit messages.
"
" DEPENDENCIES:
"   - Requires Vim 7.0 or higher.
"
" Copyright: (C) 2012-2022 Ingo Karkat
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

if ! exists('g:VcsMessageRecall_git_MessageRecallOptions')
    let g:VcsMessageRecall_git_MessageRecallOptions = {
    \   'ignorePattern': "^Merge branch\\%(es\\)\\? '[^\\n]*'\\%( into [^\\n]\\+\\)\\?\\n*$",
    \}
endif
if ! exists('g:VcsMessageRecall_hg_MessageRecallOptions')
    let g:VcsMessageRecall_hg_MessageRecallOptions = {}
endif
if ! exists('g:VcsMessageRecall_svn_MessageRecallOptions')
    let g:VcsMessageRecall_svn_MessageRecallOptions = {}
endif


"- autocmds --------------------------------------------------------------------

augroup VcsMessageRecall
    autocmd!
    autocmd FileType gitcommit,gitcommit.* call VcsMessageRecall#Setup(function('VcsMessageRecall#git#MessageStore'), '.git', '# Please enter \%(a\|the\) commit message', g:VcsMessageRecall_git_MessageRecallOptions)
    autocmd FileType hgcommit,hgcommit.*   call VcsMessageRecall#Setup(function('VcsMessageRecall#hg#MessageStore' ), '.hg', 'HG: Enter commit message\.', g:VcsMessageRecall_hg_MessageRecallOptions)
    autocmd FileType svn,svn.*             call VcsMessageRecall#Setup(function('VcsMessageRecall#svn#MessageStore'), '.svn', '--This line, and those below, will be ignored--', g:VcsMessageRecall_svn_MessageRecallOptions)
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
