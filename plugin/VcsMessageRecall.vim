" VcsMessageRecall.vim: Browse and re-insert previous VCS commit messages.
"
" DEPENDENCIES:
"   - MessageRecall.vim autoload script
"   - VcsMessageRecall/git.vim autoload script
"   - VcsMessageRecall/hg.vim autoload script
"   - VcsMessageRecall/svn.vim autoload script
"
" Copyright: (C) 2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.01.006	25-Jun-2012	Revise range regexp to avoid capturing an empty
"				line before (more empty lines before) the
"				boilerplate, and to avoid capturing the first
"				line of the boilerplate when at line 1.
"   1.00.005	25-Jun-2012	Move message store strategies for the individual
"				VCS into separate autoload scripts.
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

augroup VcsMessageRecall
    autocmd!
    autocmd FileType gitcommit,gitcommit.* call MessageRecall#Setup(VcsMessageRecall#git#MessageStore(), {'whenRangeNoMatch': 'all', 'range': '1,1/.\n\zs\n*# Please enter the commit message for your changes\./-1'})
    autocmd FileType hgcommit,hgcommit.*   call MessageRecall#Setup(VcsMessageRecall#hg#MessageStore() , {'whenRangeNoMatch': 'all', 'range': '1,1/.\n\zs\n*HG: Enter commit message\./-1'})
    autocmd FileType svn,svn.*             call MessageRecall#Setup(VcsMessageRecall#svn#MessageStore(), {'whenRangeNoMatch': 'all', 'range': '1,1/.\n\zs\n*--This line, and those below, will be ignored--/-1'})
augroup END

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
