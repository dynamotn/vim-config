" vim:foldmethod=marker:foldmarker={,}
" Something on startup {
augroup Startup
  autocmd!
  " Check has stdin from cmd
  autocmd StdinReadPre * let g:dynamo_has_std_in=1
augroup END
" }

" Custom fold level of config file {
" ############
" # Category #
" ############
" ## Subcategory
" ### Sub-subcategory
" # Just a comment
augroup FoldConfigFile
  function! ConfigFileFolds()
    let this_line=getline(v:lnum)
    if match(this_line, '^#\{2,} ') >= 0
      return '>' . (len(this_line) - len(substitute(this_line, '^#\{2,}', '', 'g')))
    endif
    let two_following_lines=0
    if line(v:lnum) + 2 <= line('$')
      let line_1_after=getline(v:lnum+1)
      let line_2_after=getline(v:lnum+2)
      let two_following_lines=1
    endif
    if !two_following_lines
      return '='
    else
      if (match(this_line, '^#####') >= 0) &&
         \ (match(line_1_after, '^# ') >= 0) &&
         \ (match(line_2_after, '^#####') >= 0)
        return '>1'
      else
        return '='
      endif
    endif
  endfunction

  autocmd!
  autocmd FileType conf setlocal foldmethod=expr | setlocal foldexpr=ConfigFileFolds()
augroup END
" }

" Autoinstall when change list plugins file {
augroup AutoInstallWhenChangeListPlugins
  autocmd!
  autocmd BufWritePost $VIMHOME/config/list_plugins.vim call dynamo#plugin#Update()
  autocmd BufWritePost $VIMHOME/*.vim source $MYVIMRC
augroup END
" }
