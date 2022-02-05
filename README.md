VCS MESSAGE RECALL
===============================================================================
_by Ingo Karkat_

DESCRIPTION
------------------------------------------------------------------------------

This plugin automatically persists commit messages from Git, Mercurial,
Subversion (and potentially other version control systems) when Vim is invoked
as the commit message editor. It sets up mappings and commands to iterate
through stored past messages, and recall the contents (without the boilerplate
text at the bottom of each message) for use in the currently edited message.
This way, you automatically collect a history of (committed or aborted) past
messages, and can quickly base your current message on contents recalled from
that history.

### RELATED WORKS

- svn\_commit ([vimscript #1451](http://www.vim.org/scripts/script.php?script_id=1451)) will look in the current directory for aborted
  subversion commit log messages, and then read in the newest one to your
  current commit log.
- vim-git-msg-wheel ([vimscript #5750](http://www.vim.org/scripts/script.php?script_id=5750)) shows a completion menu with the last
  Git commit messages (titles only), by querying Git's log.

USAGE
------------------------------------------------------------------------------

    See MessageRecall-message-usage for the available mappings and commands.

    The commit messages are stored separately for each repository, no matter from
    which subdirectory of the repository you're committing. The message store is
    located in a directory below the version control system's metadata directory:
        {.git,.hg,.svn}/commit-msgs/
    If you need to recall messages from a different repository, you can pass that
    path to the :MessageRecall command or use the |:MessageStore|[!] command to
    add / change to another message store. Alternatively, the plugin can be
    reconfigured to use a single, global message store.

### EXAMPLE

You commit a set of changes via "git commit". Vim is invoked on the
.git/COMMIT\_EDITMSG file, which so far just shows the boilerplate comments at
the bottom of the file.
You press CTRL-P to recall the previous commit message, because this commit is
related to it, and you want to re-use parts of its description. The previous
commit message is inserted above the boilerplate.
Was it that message? You browse through some more via CTRL-P and CTRL-N, then
start editing. Oh, there also was some useful information in the third last
commit. A 3\_CTRL-P opens that message in the preview window (because your
current message is now modified, and therefore won't be replaced).
From there, you yank and paste the sentence into your current commit message.
You could have also incorporated the entire message via :3MessageRecall,
either from the preview window, or directly inside the current message.

Finally, you finish your message. But DUH! you actually forgot to fix
something. You bail out via :cquit!, and Git aborts the commit. Nothing is
lost, though. On the next try, a simple CTRL-P or :MessageRecall will retrieve
your carefully crafted text.

INSTALLATION
------------------------------------------------------------------------------

The code is hosted in a Git repo at
    https://github.com/inkarkat/vim-VcsMessageRecall
You can use your favorite plugin manager, or "git clone" into a directory used
for Vim packages. Releases are on the "stable" branch, the latest unstable
development snapshot on "master".

This script is also packaged as a vimball. If you have the "gunzip"
decompressor in your PATH, simply edit the \*.vmb.gz package in Vim; otherwise,
decompress the archive first, e.g. using WinZip. Inside Vim, install by
sourcing the vimball or via the :UseVimball command.

    vim VcsMessageRecall*.vmb.gz
    :so %

To uninstall, use the :RmVimball command.

### DEPENDENCIES

- Requires Vim 7.0 or higher.
- Requires the ingo-library.vim plugin ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)), version 1.038 or
  higher.
- Requires the EditSimilar plugin ([vimscript #2544](http://www.vim.org/scripts/script.php?script_id=2544)), version 2.00 or higher.
- Requires the BufferPersist plugin ([vimscript #4115](http://www.vim.org/scripts/script.php?script_id=4115)).
- Requires the MessageRecall plugin ([vimscript #4116](http://www.vim.org/scripts/script.php?script_id=4116)).

CONFIGURATION
------------------------------------------------------------------------------

The message store is located in a directory below the version control system's
metadata directory; to change the name:

    let g:VcsMessageRecall_StoreDirName = 'commit-msgs'

The MessageRecall configuration can be tweaked by adding options into a
Dictionary, e.g. for Git:

    let g:VcsMessageRecall_git_MessageRecallOptions = {
    \   'ignorePattern': "^Merge branch",
    \}

Options provided by VcsMessageRecall ("range", "whenRangeNoMatch") can be
overridden, too. For example, if you use a localized version of the VCS
utilities, you have to adapt the patterns for the boilerplate detection in the
"range" option.

Alternatively, you can override the autocmds after the plugin has been
sourced, e.g. in a file ~/.vim/after/plugin/VcsMessageRecall.vim
For example, to use a single, global message store for all Subversion commits:

    autocmd! VcsMessageRecall FileType svn,svn.*
    \   call VcsMessageRecall#Setup(
    \       $HOME . '/.svn-commit-msgs',
    \       '--This line, and those below, will be ignored--',
    \       g:VcsMessageRecall_svn_MessageRecallOptions
    \   )

CONTRIBUTING
------------------------------------------------------------------------------

Report any bugs, send patches, or suggest features via the issue tracker at
https://github.com/inkarkat/vim-VcsMessageRecall/issues or email (address
below).

HISTORY
------------------------------------------------------------------------------

##### 1.06    RELEASEME
- Minor: Make the "commit-msgs" directory name configurable via
  g:VcsMessageRecall\_StoreDirName.
- ENH: Configure the MessageRecall plugin (version 1.40 or higher) to have
  :MessageStore {dirspec} directly accept the working copy root directory;
  i.e. the version control system's {metadata}/commit-msgs part can be omitted
  now.
- ENH: Allow overriding the MessageRecall options via
  g:VcsMessageRecall\_{git,hg,svn}\_MessageRecallOptions Dictionaries.
- Ignore Git "Merge branch(s) '...'" commit message boilerplate by default.
  This can be undone via: let g:VcsMessageRecall\_git\_MessageRecallOptions = {}
- BUG: Git uses a slightly different boilerplate message for merges.
- Store the original commit message in the default register when replacing it.
- Git may have a merge commit warning in front of the usual boilerplate.

##### 1.05    23-Feb-2020
- ENH: Message stores from working copies that are located next to the current
  one are configured (in b:MessageRecall\_ConfiguredMessageStores)
  automatically for easy access via :MessageStore {dir}.

__You need to update to ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)) version 1.038!__

##### 1.04    23-Dec-2014
- Factor out function to and use ingo-library.
- Support Subversion 1.7 repository layout with only a single .svn directory
  inside the working copy root.
- FIX: Make Mercurial root dir detection work when CWD is outside of the
  working copy.

__You need to separately install ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)) version
  1.012 (or higher)!__

##### 1.03    09-Nov-2012 (unreleased)
- FIX: On Cygwin and Mercurial, the system() calls have a trailing newline,
  which breaks the concatenation and leads to strange errors.

##### 1.02    12-Jul-2012
- FIX: Typo in function name breaks Subversion support.
- FIX: Avoid determining message store location when a stored message is
  edited.
- Split off VcsMessageRecall#Setup() to consolidate the setup duplicated for
  each VCS and to introduce error handling. Exceptions should not reach the
  user, as this aborts the opening of the file. Rather, just print out the
  error and continue.
- Revise range regexp again to also match an empty line above the boilerplate;
  this will be discarded by BufferPersist, anyway. We need a match in that
  case to properly replace a just-opened, otherwise empty commit message via
  CTRL-P or :MessageRecall.

##### 1.01    25-Jun-2012
- Revise range regexp to avoid capturing an empty line before (more empty lines
before) the boilerplate, and to avoid capturing the first line of the
boilerplate when at line 1.

##### 1.00    25-Jun-2012
- First published version.

##### 0.01    18-Jun-2012
- Started development.

------------------------------------------------------------------------------
Copyright: (C) 2012-2022 Ingo Karkat -
The [VIM LICENSE](http://vimdoc.sourceforge.net/htmldoc/uganda.html#license) applies to this plugin.

Maintainer:     Ingo Karkat &lt;ingo@karkat.de&gt;
