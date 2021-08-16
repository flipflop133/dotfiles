let g:nnn#action = {
      \ '<c-t>': 'tab split',
      \ '<c-x>': 'split',
      \ '<c-v>': 'vsplit'
	  \}

" nnn floating window
let g:nnn#layout = { 'window': { 'width': 0.5, 'height': 0.6, 'xoffset': 40, 'border': 'sharp' } }

" open nnn file picker
nnoremap <silent> <C-n> :Np<CR>

" nnn default options
let g:nnn#command = 'nnn -eux'
