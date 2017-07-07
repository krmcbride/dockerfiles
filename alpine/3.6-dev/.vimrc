set runtimepath+=/usr/local/vim_runtime

source /usr/local/vim_runtime/vimrcs/basic.vim
source /usr/local/vim_runtime/vimrcs/filetypes.vim
source /usr/local/vim_runtime/vimrcs/plugins_config.vim
source /usr/local/vim_runtime/vimrcs/extended.vim

try
source /usr/local/vim_runtime/my_configs.vim
catch
endtry
