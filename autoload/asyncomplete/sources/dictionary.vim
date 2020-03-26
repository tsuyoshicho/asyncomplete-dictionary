let s:cache = {}

function! asyncomplete#sources#dictionary#completor(opt, ctx) abort
  let l:typed = a:ctx['typed']
  let l:col = a:ctx['col']

  let l:kw = matchstr(l:typed, '\w\+$')
  let l:kwlen = len(l:kw)
  let l:startcol = l:col - l:kwlen

  if !has_key(s:cache, &filetype)
    let l:matches = []
    let l:dictionaries = split(&dictionary, '[^\\]\zs,\ze')
    let l:dictionaries = map(copy(l:dictionaries), {i,v -> substitute(v, '\\,', ',', '') })

    for l:dictionary in l:dictionaries
      let l:matches = l:matches + readfile(l:dictionary)
    endfor

    let s:cache[&filetype] =  map(l:matches, "{'word': v:val, 'menu': '[dict]', 'dup': 1, 'icase': 1}")
  endif

  call asyncomplete#complete(a:opt['name'], a:ctx, l:startcol, s:cache[&filetype])
endfunction

function! asyncomplete#sources#dictionary#get_source_options(opts) abort
  return extend(extend({}, a:opts), {})
endfunction
