" VcsMessageRecall.vim: Browse and re-insert previous VCS commit messages.
"
" DEPENDENCIES:
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
    autocmd FileType gitcommit,gitcommit.* call MessageRecall#Setup(ingofile#CombineToFilespec($HOME, '.gitcommit-messages'), {'whenRangeNoMatch': 'all', 'range': '1,1/^\n*# Please enter the commit message for your changes\./-1'})
    autocmd FileType hgcommit,hgcommit.*   call MessageRecall#Setup(ingofile#CombineToFilespec($HOME, '.hgcommit-messages') , {'whenRangeNoMatch': 'all', 'range': '1,1/^\n*HG: Enter commit message\./-1'})
    autocmd FileType svn,svn.*             call MessageRecall#Setup(ingofile#CombineToFilespec($HOME, '.svncommit-messages'), {'whenRangeNoMatch': 'all', 'range': '1,1/^\n*--This line, and those below, will be ignored--/-1'})
augroup END

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
