
; Assembly Editor interface for Win32 IDE
; Copyright (c) 2001-2004, Tomasz Grysztar.
; All rights reserved.

SEGMENT_LENGTH	      = 100h
BLOCK_LENGTH	      = 100h * SEGMENT_LENGTH
SEGMENT_HEADER_LENGTH = 8
SEGMENT_DATA_LENGTH   = SEGMENT_LENGTH - SEGMENT_HEADER_LENGTH

proc AsmEdit, hwnd,wmsg,wparam,lparam

  editor_memory dd ?
  editor_style dd ?

  label editor_data

  first_line dd ?
  lines_count dd ?
  peak_line_length dd ?
  window_line dd ?
  window_position dd ?
  window_line_number dd ?
  caret_line dd ?
  caret_position dd ?
  caret_line_number dd ?
  selection_line dd ?
  selection_position dd ?
  selection_line_number dd ?
  editor_mode dd ?

  editor_status_size = $ - editor_data

  editor_font dd ?
  font_width dd ?
  font_height dd ?
  screen_base dd ?
  screen_offset dd ?
  screen_width dd ?
  screen_height dd ?
  screen_size dd ?
  window_width dd ?
  window_height dd ?
  background_color dd ?
  text_color dd ?
  selection_background dd ?
  selection_text dd ?
  syntax_proc dd ?
  syntax_colors dd ?
  menu_handle dd ?
  menu_window dd ?
  line_buffer dd ?
  line_buffer_size dd ?
  unallocated_segments dd ?
  unallocated_segments_end dd ?
  released_segments dd ?
  memory_search_block dd ?
  memory_search_segment dd ?
  undo_data dd ?
  search_data dd ?
  search_flags dd ?
  caret_x dd ?
  caret_y dd ?
  current_operation db ?
  last_operation db ?
  mouse_select db ?
  focus db ?

  editor_data_size = $ - editor_data

  return_value dd ?
  background_brush dd ?
  selection_brush dd ?
  ps PAINTSTRUCT
  tm TEXTMETRIC
  sc SCROLLINFO
  point POINT
  rect RECT
  char dd ?
  kbstate rb 100h
  was_selection db ?
  line_selection db ?
  clipboard_opened db ?
  redraw_now db ?
  notification db ?

	enter
	push	ebx esi edi
	invoke	GetWindowLong,[hwnd],GWL_STYLE
	mov	[editor_style],eax
	cmp	[wmsg],WM_CREATE
	je	wm_create
	cmp	[wmsg],WM_GETDLGCODE
	je	wm_getdlgcode
	invoke	GetWindowLong,[hwnd],0
	or	eax,eax
	jz	defwndproc
	mov	[editor_memory],eax
	lea	esi,[eax+8]
	lea	edi,[editor_data]
	mov	ecx,editor_data_size shr 2
	rep	movsd
	mov	[return_value],0
	mov	[notification],0
	mov	[redraw_now],0
	mov	[clipboard_opened],0
	cmp	[wmsg],WM_DESTROY
	je	wm_destroy
	cmp	[wmsg],WM_PAINT
	je	wm_paint
	invoke	HideCaret,[hwnd]
	cmp	[wmsg],WM_HSCROLL
	je	wm_hscroll
	cmp	[wmsg],WM_VSCROLL
	je	wm_vscroll
	cmp	[wmsg],WM_SIZE
	je	wm_size
	cmp	[selection_line],0
	setnz	al
	mov	[was_selection],al
	xor	al,al
	xchg	[current_operation],al
	mov	[last_operation],al
	mov	eax,[wmsg]
	cmp	eax,WM_SETFOCUS
	je	wm_setfocus
	cmp	eax,WM_KILLFOCUS
	je	wm_killfocus
	cmp	eax,WM_KEYDOWN
	je	wm_keydown
	cmp	eax,WM_SYSKEYDOWN
	je	wm_syskeydown
	cmp	eax,WM_CHAR
	je	wm_char
	cmp	eax,WM_LBUTTONDOWN
	je	wm_lbuttondown
	cmp	eax,WM_LBUTTONUP
	je	wm_lbuttonup
	cmp	eax,WM_MOUSEMOVE
	je	wm_mousemove
	cmp	eax,WM_LBUTTONDBLCLK
	je	wm_lbuttondblclk
	cmp	eax,WM_MOUSEWHEEL
	je	wm_mousewheel
	cmp	eax,WM_RBUTTONDOWN
	je	wm_rbuttondown
	cmp	eax,WM_COPY
	je	wm_copy
	cmp	eax,WM_CUT
	je	wm_cut
	cmp	eax,WM_PASTE
	je	wm_paste
	cmp	eax,WM_CLEAR
	je	wm_clear
	cmp	eax,WM_SETTEXT
	je	wm_settext
	cmp	eax,WM_GETTEXTLENGTH
	je	wm_gettextlength
	cmp	eax,WM_GETTEXT
	je	wm_gettext
	cmp	eax,WM_SETFONT
	je	wm_setfont
	cmp	eax,WM_GETFONT
	je	wm_getfont
	cmp	eax,WM_UNDO
	je	wm_undo
	cmp	eax,EM_UNDO
	je	wm_undo
	cmp	eax,EM_CANUNDO
	je	em_canundo
	cmp	eax,EM_EMPTYUNDOBUFFER
	je	em_emptyundobuffer
	cmp	eax,EM_REPLACESEL
	je	em_replacesel
	cmp	eax,AEM_SETMODE
	je	aem_setmode
	cmp	eax,AEM_GETMODE
	je	aem_getmode
	cmp	eax,AEM_SETSYNTAXHIGHLIGHT
	je	aem_setsyntaxhighlight
	cmp	eax,AEM_SETRIGHTCLICKMENU
	je	aem_setrightclickmenu
	cmp	eax,AEM_GETLINELENGTH
	je	aem_getlinelength
	cmp	eax,AEM_GETLINE
	je	aem_getline
	cmp	eax,AEM_SETPOS
	je	aem_setpos
	cmp	eax,AEM_GETPOS
	je	aem_getpos
	cmp	eax,AEM_FINDFIRST
	je	aem_findfirst
	cmp	eax,AEM_FINDNEXT
	je	aem_findnext
	cmp	eax,AEM_CANFINDNEXT
	je	aem_canfindnext
	cmp	eax,AEM_GETWORDATCARET
	je	aem_getwordatcaret
	cmp	eax,AEM_SETTEXTCOLOR
	je	aem_settextcolor
	cmp	eax,AEM_SETSELCOLOR
	je	aem_setselcolor
	invoke	ShowCaret,[hwnd]
defwndproc:
	invoke	DefWindowProc,[hwnd],[wmsg],[wparam],[lparam]
	jmp	finish_wndproc
wm_create:
	call	init_editor_memory
	jc	create_failed
	invoke	SetWindowLong,[hwnd],0,[editor_memory]
	mov	[syntax_proc],SyntaxProc
	mov	[syntax_colors],0
	mov	[current_operation],0
	mov	[focus],0
	mov	[mouse_select],0
	mov	[menu_handle],0
	mov	eax,SEGMENT_DATA_LENGTH*2
	mov	[line_buffer_size],eax
	invoke	VirtualAlloc,0,eax,MEM_COMMIT,PAGE_READWRITE
	or	eax,eax
	jz	create_failed
	mov	[line_buffer],eax
	mov	[screen_base],0
	invoke	GetSysColor,COLOR_WINDOW
	mov	[background_color],eax
	invoke	GetSysColor,COLOR_WINDOWTEXT
	mov	[text_color],eax
	invoke	GetSysColor,COLOR_HIGHLIGHT
	mov	[selection_background],eax
	invoke	GetSysColor,COLOR_HIGHLIGHTTEXT
	mov	[selection_text],eax
	mov	eax,[asmedit_font]
	mov	[editor_font],eax
	invoke	GetDC,[hwnd]
	mov	ebx,eax
	invoke	SelectObject,ebx,[editor_font]
	lea	eax,[tm]
	invoke	GetTextMetrics,ebx,eax
	mov	eax,[tm.tmHeight]
	mov	[font_height],eax
	mov	eax,[tm.tmAveCharWidth]
	mov	[font_width],eax
	invoke	ReleaseDC,[hwnd],ebx
	mov	[return_value],0
	jmp	done
    create_failed:
	or	eax,-1
	jmp	finish_wndproc
wm_destroy:
	invoke	VirtualFree,[line_buffer],0,MEM_RELEASE
	invoke	VirtualFree,[screen_base],0,MEM_RELEASE
	call	release_search_data
	call	release_editor_memory
	invoke	SetWindowLong,[hwnd],0,0
	xor	eax,eax
	jmp	finish_wndproc
wm_getdlgcode:
	mov	eax,DLGC_WANTCHARS+DLGC_WANTARROWS
	jmp	finish_wndproc
wm_paint:
	lea	eax,[rect]
	invoke	GetUpdateRect,[hwnd],eax,FALSE
	or	eax,eax
	jz	finish_wndproc
	cmp	[screen_base],0
	je	finish_wndproc
	lea	eax,[ps]
	invoke	BeginPaint,[hwnd],eax
	mov	ebx,eax
	invoke	CreateSolidBrush,[background_color]
	mov	[background_brush],eax
	invoke	CreateSolidBrush,[selection_background]
	mov	[selection_brush],eax
	invoke	SelectObject,ebx,[editor_font]
	mov	esi,[screen_base]
	add	esi,[screen_offset]
	mov	eax,[screen_width]
	mul	[screen_height]
	lea	edi,[esi+eax]
	mov	[rect.top],0
	mov	eax,[font_height]
	mov	[rect.bottom],eax
	mov	ecx,[screen_height]
    paint_screen:
	push	ecx
	mov	[rect.left],0
	mov	ecx,[screen_width]
    paint_line:
	cmp	byte [esi],0
	je	paint_empty_block
	mov	edx,1
	mov	al,[edi]
    get_characters_block:
	cmp	edx,ecx
	je	get_color
	cmp	al,[edi+edx]
	jne	get_color
	cmp	byte [esi+edx],0
	je	get_color
	inc	edx
	jmp	get_characters_block
    paint_empty_block:
	mov	edx,1
	test	byte [edi],80h
	jnz	get_empty_selection
    get_empty_block:
	cmp	edx,ecx
	je	fill_empty_block
	cmp	byte [esi+edx],0
	jne	fill_empty_block
	test	byte [edi+edx],80h
	jnz	fill_empty_block
	inc	edx
	jmp	get_empty_block
    fill_empty_block:
	push	ecx edx
	mov	eax,[font_width]
	mul	edx
	add	eax,[rect.left]
	mov	[rect.right],eax
	lea	eax,[rect]
	invoke	FillRect,ebx,eax,[background_brush]
	jmp	paint_next_block
    get_empty_selection:
	cmp	edx,ecx
	je	fill_empty_selection
	cmp	byte [esi+edx],0
	jne	fill_empty_selection
	test	byte [edi+edx],80h
	jz	fill_empty_selection
	inc	edx
	jmp	get_empty_selection
    fill_empty_selection:
	push	ecx edx
	mov	eax,[font_width]
	mul	edx
	add	eax,[rect.left]
	mov	[rect.right],eax
	lea	eax,[rect]
	invoke	FillRect,ebx,eax,[selection_brush]
	jmp	paint_next_block
    get_color:
	push	ecx edx
	test	byte [edi],80h
	jnz	highlight_color
	invoke	SetBkColor,ebx,[background_color]
	mov	al,[edi]
	or	al,al
	jnz	syntax_color
    default_color:
	invoke	SetTextColor,ebx,[text_color]
	jmp	color_ok
    syntax_color:
	movzx	eax,al
	mov	edx,[syntax_colors]
	or	edx,edx
	jz	default_color
	mov	eax,[edx+(eax-1)*4]
	invoke	SetTextColor,ebx,eax
	jmp	color_ok
    highlight_color:
	invoke	SetBkColor,ebx,[selection_background]
	invoke	SetTextColor,ebx,[selection_text]
    color_ok:
	mov	ecx,[esp]
	mov	eax,[font_width]
	mul	ecx
	add	eax,[rect.left]
	mov	[rect.right],eax
	lea	eax,[rect]
	invoke	DrawText,ebx,esi,ecx,eax,DT_LEFT+DT_NOPREFIX+DT_SINGLELINE
    paint_next_block:
	pop	edx ecx
	sub	ecx,edx
	add	esi,edx
	add	edi,edx
	mov	eax,[rect.right]
	mov	[rect.left],eax
	or	ecx,ecx
	jnz	paint_line
	mov	eax,[font_height]
	add	[rect.top],eax
	add	[rect.bottom],eax
	pop	ecx
	dec	ecx
	jnz	paint_screen
	invoke	DeleteObject,[background_brush]
	invoke	DeleteObject,[selection_brush]
	lea	eax,[ps]
	invoke	EndPaint,[hwnd],eax
	xor	eax,eax
	jmp	finish_wndproc
wm_setfocus:
	or	[focus],-1
	call	create_caret
	mov	[notification],AEN_SETFOCUS
	cmp	[was_selection],0
	je	done
	jmp	moved_window
wm_killfocus:
	mov	[focus],0
	invoke	DestroyCaret
	mov	[notification],AEN_KILLFOCUS
	cmp	[was_selection],0
	je	done
	jmp	moved_window
wm_hscroll:
	mov	[sc.cbSize],sizeof.SCROLLINFO
	mov	[sc.fMask],SIF_ALL
	lea	eax,[sc]
	invoke	GetScrollInfo,[hwnd],SB_HORZ,eax
	movzx	eax,word [wparam]
	cmp	eax,SB_LINEUP
	je	hscroll_left
	cmp	eax,SB_LINEDOWN
	je	hscroll_right
	cmp	eax,SB_THUMBTRACK
	je	hscroll_pos
	cmp	eax,SB_PAGEUP
	je	hscroll_wleft
	cmp	eax,SB_PAGEDOWN
	je	hscroll_wright
    hscroll_ignore:
	jmp	done
    hscroll_left:
	cmp	[window_position],0
	je	hscroll_ignore
	dec	[window_position]
	jmp	moved_window
    hscroll_right:
	mov	eax,[peak_line_length]
	sub	eax,[sc.nPage]
	cmp	[window_position],eax
	jge	hscroll_ignore
	inc	[window_position]
	jmp	moved_window
    hscroll_pos:
	mov	eax,[sc.nTrackPos]
	mov	[window_position],eax
	jmp	moved_window
    hscroll_wleft:
	mov	eax,[sc.nPage]
	sub	[window_position],eax
	jnc	moved_window
	mov	[window_position],0
	jmp	moved_window
    hscroll_wright:
	mov	eax,[sc.nPage]
	mov	ecx,[peak_line_length]
	sub	ecx,eax
	add	[window_position],eax
	cmp	[window_position],ecx
	jbe	moved_window
	mov	[window_position],ecx
	jmp	moved_window
wm_vscroll:
	mov	[sc.cbSize],sizeof.SCROLLINFO
	mov	[sc.fMask],SIF_ALL
	lea	eax,[sc]
	invoke	GetScrollInfo,[hwnd],SB_VERT,eax
	movzx	eax,word [wparam]
	cmp	eax,SB_LINEUP
	je	vscroll_up
	cmp	eax,SB_LINEDOWN
	je	vscroll_down
	cmp	eax,SB_THUMBTRACK
	je	vscroll_pos
	cmp	eax,SB_PAGEUP
	je	vscroll_pageup
	cmp	eax,SB_PAGEDOWN
	je	vscroll_pagedown
    vscroll_ignore:
	jmp	done
    vscroll_up:
	mov	esi,[window_line]
	mov	esi,[esi+4]
	or	esi,esi
	jz	vscroll_ignore
	dec	[window_line_number]
	mov	[window_line],esi
	jmp	moved_window
    vscroll_down:
	mov	eax,[sc.nPos]
	add	eax,[sc.nPage]
	cmp	eax,[sc.nMax]
	ja	vscroll_ignore
	mov	esi,[window_line]
    vscroll_skip_line:
	mov	esi,[esi]
	btr	esi,0
	jc	vscroll_skip_line
	or	esi,esi
	jz	vscroll_ignore
	inc	[window_line_number]
	mov	[window_line],esi
	jmp	moved_window
    vscroll_pos:
	mov	eax,[sc.nTrackPos]
	call	find_line
	or	esi,esi
	jz	vscroll_ignore
	mov	[window_line],esi
	mov	[window_line_number],ecx
	jmp	moved_window
    vscroll_pageup:
	mov	esi,[window_line]
	mov	ecx,[sc.nPage]
    scroll_up:
	mov	eax,[esi+4]
	or	eax,eax
	jz	scroll_ok
	dec	[window_line_number]
	mov	esi,eax
	loop	scroll_up
	jmp	scroll_ok
    vscroll_pagedown:
	mov	esi,[window_line]
	mov	eax,[sc.nPos]
	add	eax,[sc.nPage]
	mov	ecx,[sc.nMax]
	sub	ecx,eax
	inc	ecx
	cmp	ecx,[sc.nPage]
	jbe	scroll_down
	mov	ecx,[sc.nPage]
    scroll_down:
	mov	eax,[esi]
	btr	eax,0
	jnc	scroll_next_line
	mov	esi,eax
	jmp	scroll_down
    scroll_next_line:
	or	eax,eax
	jz	scroll_ok
	inc	[window_line_number]
	mov	esi,eax
	loop	scroll_down
    scroll_ok:
	mov	[window_line],esi
	jmp	moved_window
wm_mousewheel:
	mov	esi,[window_line]
	mov	eax,[wparam]
	sar	eax,16
	cdq
	mov	ecx,120
	idiv	ecx
	imul	eax,[whell_scroll_lines]
	mov	ecx,eax
	cmp	ecx,0
	jg	scroll_up
	neg	ecx
	jnz	scroll_down
	jmp	done
wm_size:
	call	update_positions
	mov	eax,[screen_width]
	mul	[screen_height]
	mov	[screen_size],eax
	mov	[screen_offset],0
	shl	eax,2
	or	eax,eax
	jz	screen_allocated
	mov	ebx,eax
	mov	eax,[screen_base]
	or	eax,eax
	jz	screen_released
	invoke	VirtualFree,eax,0,MEM_RELEASE
    screen_released:
	invoke	VirtualAlloc,0,ebx,MEM_COMMIT,PAGE_READWRITE
    screen_allocated:
	mov	[screen_base],eax
	call	update_screen
	lea	ebx,[rect]
	invoke	GetClientRect,[hwnd],ebx
	invoke	InvalidateRect,[hwnd],ebx,FALSE
	jmp	done
wm_keydown:
	lea	ebx,[kbstate]
	invoke	GetKeyboardState,ebx
	cmp	[was_selection],0
	jne	process_key
	mov	eax,[caret_line]
	mov	[selection_line],eax
	mov	eax,[caret_position]
	mov	[selection_position],eax
	mov	eax,[caret_line_number]
	mov	[selection_line_number],eax
    process_key:
	mov	eax,[wparam]
	cmp	eax,VK_LEFT
	je	left_key
	cmp	eax,VK_RIGHT
	je	right_key
	cmp	eax,VK_UP
	je	up_key
	cmp	eax,VK_DOWN
	je	down_key
	cmp	eax,VK_BACK
	je	backspace__key
	cmp	eax,VK_HOME
	je	home_key
	cmp	eax,VK_END
	je	end_key
	cmp	eax,VK_PGUP
	je	pgup_key
	cmp	eax,VK_PGDN
	je	pgdn_key
	cmp	eax,VK_DELETE
	je	del_key
	cmp	eax,VK_INSERT
	je	ins_key
	cmp	eax,VK_F6
	je	duplicate_line
	cmp	eax,VK_APPS
	je	menu_key
	test	[kbstate+VK_CONTROL],80h
	jz	convert_to_ascii
	cmp	eax,'Y'
	je	remove_line
    convert_to_ascii:
	mov	ax,word [lparam+2]
	and	eax,7Fh
	lea	ebx,[kbstate]
	lea	edx,[char]
	invoke	ToAscii,[wparam],eax,ebx,edx,FALSE
	or	eax,eax
	jz	ignore
	mov	al,byte [char]
	cmp	al,20h
	jae	character
	cmp	al,0Dh
	je	character
	cmp	al,9
	je	character
	jmp	ignore
  left_key:
	test	[kbstate+VK_CONTROL],80h
	jnz	word_left
	cmp	[caret_position],0
	jle	moved_caret
	dec	[caret_position]
	jmp	moved_caret
  right_key:
	test	[kbstate+VK_CONTROL],80h
	jnz	word_right
	mov	eax,[caret_position]
	cmp	eax,[peak_line_length]
	jae	moved_caret
	inc	[caret_position]
	jmp	moved_caret
  up_key:
	call	move_line_up
	jmp	moved_caret
  down_key:
	call	move_line_down
	jmp	moved_caret
  home_key:
	test	[kbstate+VK_CONTROL],80h
	jnz	screen_home
	mov	[caret_position],0
	jmp	moved_caret
  end_key:
	test	[kbstate+VK_CONTROL],80h
	jnz	screen_end
	call	move_to_line_end
	jmp	moved_caret
  screen_home:
	mov	eax,[window_line]
	mov	[caret_line],eax
	mov	eax,[window_line_number]
	mov	[caret_line_number],eax
	jmp	moved_caret
  screen_end:
	mov	eax,[window_line_number]
	add	eax,[window_height]
	dec	eax
	call	find_line
	mov	[caret_line],esi
	mov	[caret_line_number],ecx
	jmp	moved_caret
  pgup_key:
	test	[kbstate+VK_CONTROL],80h
	jnz	text_home
	call	move_page_up
	jmp	moved_caret
  pgdn_key:
	test	[kbstate+VK_CONTROL],80h
	jnz	text_end
	call	move_page_down
	jmp	moved_caret
  text_home:
	mov	eax,[first_line]
	mov	[caret_line],eax
	mov	[caret_line_number],1
	jmp	moved_caret
  text_end:
	or	eax,-1
	call	find_line
	mov	[caret_line],esi
	mov	[caret_line_number],ecx
	jmp	moved_caret
  word_left:
	call	move_to_previous_word
	jmp	moved_caret
  word_right:
	call	get_caret_segment
	call	move_to_next_word
	jmp	moved_caret
  ins_key:
	test	[kbstate+VK_MENU],80h
	jnz	switch_blocks
	test	[kbstate+VK_CONTROL],80h
	jnz	wm_copy
	test	[kbstate+VK_SHIFT],80h
	jnz	wm_paste
	xor	[editor_mode],AEMODE_OVERWRITE
	mov	[notification],AEN_MODECHANGE
	call	create_caret
	cmp	[was_selection],1
	je	done
	mov	[selection_line],0
	jmp	done
  del_key:
	test	[kbstate+VK_CONTROL],80h
	jnz	wm_clear
	test	[kbstate+VK_SHIFT],80h
	jnz	wm_cut
	cmp	[was_selection],0
	je	no_selection
	test	[editor_style],AES_SECURESEL
	jz	wm_clear
    no_selection:
	mov	esi,[caret_line]
	test	[editor_mode],AEMODE_OVERWRITE
	jnz	delete_char
	call	check_line_length
	cmp	ecx,[caret_position]
	ja	delete_char
	cmp	dword [esi],0
	je	ignore
	call	store_status_for_undo
	call	cut_line_break
	mov	esi,[caret_line]
	call	check_line_length
	mov	[selection_line],0
	jmp	text_modified
    delete_char:
	mov	[current_operation],VK_DELETE
	cmp	[last_operation],VK_DELETE
	je	undo_delete_ok
	call	store_status_for_undo
    undo_delete_ok:
	call	delete_character
	mov	esi,[caret_line]
	call	check_line_length
	mov	[selection_line],0
	jmp	text_modified
  backspace__key:
	cmp	[was_selection],0
	je	no_selection_to_clear
	test	[editor_style],AES_SECURESEL
	jz	wm_clear
    no_selection_to_clear:
	cmp	[caret_position],0
	je	line_back
	test	[kbstate+VK_CONTROL],80h
	jnz	word_back
	mov	[current_operation],VK_BACK
	cmp	[last_operation],VK_BACK
	je	undo_back_ok
	call	store_status_for_undo
    undo_back_ok:
	dec	[caret_position]
	call	delete_character
	mov	esi,[caret_line]
	call	check_line_length
	mov	[selection_line],0
	jmp	text_modified
    line_back:
	test	[editor_mode],AEMODE_OVERWRITE
	jnz	ignore
	mov	esi,[caret_line]
	mov	esi,[esi+4]
	or	esi,esi
	jz	ignore
	call	store_status_for_undo
	mov	[caret_line],esi
	dec	[caret_line_number]
	call	check_line_length
	mov	[caret_position],ecx
	call	cut_line_break
	mov	esi,[caret_line]
	call	check_line_length
	mov	[selection_line],0
	jmp	text_modified
    word_back:
	call	store_status_for_undo
	push	[caret_position]
	mov	esi,[caret_line]
	xor	eax,eax
	xchg	eax,[esi+4]
	push	eax
	call	move_to_previous_word
	pop	eax
	mov	esi,[caret_line]
	mov	[esi+4],eax
	pop	ecx
	sub	ecx,[caret_position]
	call	delete_from_line
	mov	esi,[caret_line]
	call	check_line_length
	jmp	text_modified
  character:
	cmp	al,0Dh
	je	enter_key
	cmp	al,9
	je	tab_key
	cmp	[was_selection],0
	je	no_selection_to_replace
	call	store_status_for_undo
	test	[editor_style],AES_SECURESEL
	jnz	character_undo_ok
	push	eax
	call	delete_block
	pop	eax
	call	put_character
	mov	esi,[caret_line]
	call	check_line_length
	mov	[selection_line],0
	jmp	text_modified
    no_selection_to_replace:
	mov	[current_operation],VK_SPACE
	cmp	[last_operation],VK_SPACE
	je	character_undo_ok
	call	store_status_for_undo
    character_undo_ok:
	call	put_character
	mov	esi,[caret_line]
	call	check_line_length
	mov	[selection_line],0
	jmp	text_modified
  tab_key:
	call	store_status_for_undo
	cmp	[was_selection],0
	je	tab_securesel
	test	[editor_style],AES_SECURESEL
	jnz	tab_securesel
	call	delete_block
	call	make_tab
	mov	[selection_line],0
	jmp	text_modified
    tab_securesel:
	call	make_tab
	mov	[selection_line],0
	jmp	text_modified
    make_tab:
	test	[editor_style],AES_SMARTTABS
	jz	standard_tab
	mov	esi,[caret_line]
	mov	esi,[esi+4]
	or	esi,esi
	jz	standard_tab
	mov	edx,[caret_position]
	call	find_segment
	cmp	edx,SEGMENT_DATA_LENGTH
	jae	standard_tab
	push	dword 0
    find_space:
	lea	edi,[esi+SEGMENT_HEADER_LENGTH+edx]
	mov	ecx,SEGMENT_DATA_LENGTH
	sub	ecx,edx
	mov	ebx,ecx
	mov	al,20h
	repne	scasb
	jne	no_space_in_this_segment
	sub	ebx,ecx
	dec	ebx
	add	edx,ebx
	add	[esp],ebx
	call	get_indent
	pop	ecx
	or	ebx,ebx
	jz	standard_tab
	add	ecx,ebx
	jmp	insert_tab_spaces
    no_space_in_this_segment:
	pop	ecx
	mov	esi,[esi]
	btr	esi,0
	jnc	standard_tab
	add	ecx,SEGMENT_DATA_LENGTH
	sub	ecx,edx
	xor	edx,edx
	push	ecx
	jmp	find_space
    standard_tab:
	mov	ecx,[caret_position]
	and	ecx,not 111b
	sub	ecx,[caret_position]
	add	ecx,8
    insert_tab_spaces:
	xor	esi,esi
	push	ecx
	call	insert_into_line
	pop	ecx
	add	[caret_position],ecx
	mov	esi,[caret_line]
	call	check_line_length
	ret
  enter_key:
	call	store_status_for_undo
	cmp	[was_selection],0
	je	enter_secureselection_ok
	test	[editor_style],AES_SECURESEL
	jnz	enter_secureselection_ok
	call	delete_block
    enter_secureselection_ok:
	xor	ebx,ebx
	test	[editor_style],AES_AUTOINDENT
	jz	auto_indent_ok
	test	[editor_mode],AEMODE_OVERWRITE
	jnz	auto_indent_ok
	call	get_caret_segment
	call	get_indent
	add	[caret_position],ebx
	mov	esi,[caret_line]
	xor	edx,edx
	call	get_indent
    auto_indent_ok:
	call	break_line
	mov	[selection_line],0
	test	[editor_mode],AEMODE_OVERWRITE
	jnz	text_modified
	mov	esi,[caret_line]
	call	check_line_length
	jmp	text_modified
    get_indent:
	xor	ebx,ebx
    find_indent_origin:
	cmp	edx,SEGMENT_DATA_LENGTH
	jb	find_indent
	mov	esi,[esi]
	btr	esi,0
	jnc	no_indent
	sub	edx,SEGMENT_DATA_LENGTH
	jmp	find_indent_origin
    find_indent:
	lea	edi,[esi+SEGMENT_HEADER_LENGTH+edx]
	mov	ecx,SEGMENT_DATA_LENGTH
	sub	ecx,edx
	add	ebx,ecx
	mov	al,20h
	repe	scasb
	je	segment_indent
	sub	ebx,ecx
	dec	ebx
	ret
    segment_indent:
	xor	edx,edx
	mov	esi,[esi]
	btr	esi,0
	jc	find_indent
    no_indent:
	xor	ebx,ebx
	ret
  remove_line:
	mov	esi,[caret_line]
	mov	esi,[esi]
	or	esi,esi
	jnz	do_remove
	mov	edi,[caret_line]
	add	edi,SEGMENT_HEADER_LENGTH
	mov	ecx,SEGMENT_DATA_LENGTH
	mov	al,20h
	repe	scasb
	je	ignore
    do_remove:
	call	store_status_for_undo
    cut_extra_segments:
	btr	esi,0
	jnc	replace_with_next_line
	call	store_segment_for_undo
	or	eax,-1
	xchg	eax,[esi]
	mov	esi,eax
	inc	[released_segments]
	jmp	cut_extra_segments
    replace_with_next_line:
	or	esi,esi
	jz	clear_current_line
	call	store_segment_for_undo
	mov	ebx,esi
	xchg	esi,[caret_line]
	mov	eax,[esi+4]
	mov	[ebx+4],eax
	call	store_segment_for_undo
	or	dword [esi],-1
	inc	[released_segments]
	call	cancel_line
	mov	esi,[esi+4]
	or	esi,esi
	jz	line_removed
    find_last_segment_of_previous_line:
	mov	eax,[esi]
	btr	eax,0
	jnc	link_to_new_next_line
	mov	esi,eax
	jmp	find_last_segment_of_previous_line
    link_to_new_next_line:
	call	store_segment_for_undo
	mov	[esi],ebx
    line_removed:
	mov	[caret_position],0
	mov	[selection_line],0
	jmp	text_modified
    clear_current_line:
	mov	esi,[caret_line]
	call	store_segment_for_undo
	mov	dword [esi],0
	lea	edi,[esi+SEGMENT_HEADER_LENGTH]
	mov	ecx,SEGMENT_DATA_LENGTH
	mov	al,20h
	rep	stosb
	jmp	line_removed
  duplicate_line:
	call	store_status_for_undo
	call	allocate_segment
	jc	memory_shortage
	call	store_free_segment_for_undo
	mov	esi,[caret_line]
	mov	edi,eax
	mov	[edi+4],esi
	push	edi
    duplicate_segment:
	mov	ebx,edi
	add	edi,SEGMENT_HEADER_LENGTH
	add	esi,SEGMENT_HEADER_LENGTH
	mov	ecx,SEGMENT_DATA_LENGTH
	rep	movsb
	sub	esi,SEGMENT_LENGTH
	mov	eax,[esi]
	btr	eax,0
	jnc	all_segments_duplicated
	mov	esi,eax
	call	allocate_segment
	jc	memory_shortage
	call	store_free_segment_for_undo
	mov	edi,eax
	or	eax,1
	mov	[ebx],eax
	or	ebx,1
	mov	[edi+4],ebx
	jmp	duplicate_segment
    all_segments_duplicated:
	inc	[lines_count]
	call	store_segment_for_undo
	mov	[ebx],eax
	pop	ebx
	mov	[esi],ebx
	mov	esi,eax
	or	esi,esi
	jz	text_modified
	call	store_segment_for_undo
	mov	[esi+4],ebx
	jmp	text_modified
  menu_key:
	cmp	[menu_handle],0
	je	ignore
	lea	ebx,[point]
	mov	eax,[caret_x]
	mov	[ebx+POINT.x],eax
	mov	eax,[caret_y]
	add	eax,[font_height]
	mov	[ebx+POINT.y],eax
	invoke	ClientToScreen,[hwnd],ebx
	invoke	TrackPopupMenu,[menu_handle],TPM_RIGHTBUTTON,[ebx+POINT.x],[ebx+POINT.y],0,[menu_window],0
	jmp	ignore
wm_syskeydown:
	mov	eax,[wparam]
	cmp	eax,VK_INSERT
	je	switch_blocks
	cmp	eax,VK_BACK
	je	wm_undo
	mov	al,[last_operation]
	mov	[current_operation],al
	invoke	ShowCaret,[hwnd]
	jmp	defwndproc
  switch_blocks:
	xor	[editor_mode],AEMODE_VERTICALSEL
	mov	[notification],AEN_MODECHANGE
	cmp	[was_selection],0
	je	ignore
	jmp	moved_window
wm_char:
	test	[lparam],1 shl 31
	jz	ignore
	mov	eax,[wparam]
	jmp	character
wm_lbuttondown:
	cmp	[focus],0
	jne	focus_ok
	invoke	SetFocus,[hwnd]
	mov	esi,[editor_memory]
	add	esi,8
	lea	edi,[editor_data]
	mov	ecx,editor_data_size shr 2
	rep	movsd
    focus_ok:
	lea	ebx,[kbstate]
	invoke	GetKeyboardState,ebx
	cmp	[was_selection],0
	jne	selection_ok
	mov	eax,[caret_line]
	mov	[selection_line],eax
	mov	eax,[caret_position]
	mov	[selection_position],eax
	mov	eax,[caret_line_number]
	mov	[selection_line_number],eax
    selection_ok:
	call	get_mouse_position
	invoke	SetCapture,[hwnd]
	or	[mouse_select],-1
	jmp	moved_caret
    get_mouse_position:
	mov	ax,word [lparam]
	cwde
	cdq
	idiv	[font_width]
	add	eax,[window_position]
	cmp	eax,[peak_line_length]
	jg	mouse_out_of_line
	cmp	eax,0
	jge	click_position_ok
	xor	eax,eax
	jmp	click_position_ok
    mouse_out_of_line:
	mov	eax,[peak_line_length]
    click_position_ok:
	mov	[caret_position],eax
	mov	ax,word [lparam+2]
	cwde
	cdq
	idiv	[font_height]
	add	eax,[window_line_number]
	cmp	eax,0
	jg	click_line_ok
	mov	eax,1
    click_line_ok:
	call	find_line
	mov	[caret_line],esi
	mov	[caret_line_number],ecx
	ret
wm_lbuttonup:
	invoke	ReleaseCapture
	mov	[mouse_select],0
	jmp	done
wm_mousemove:
	cmp	[mouse_select],0
	je	ignore
	cmp	[was_selection],0
	jne	select
	mov	eax,[caret_line]
	mov	ebx,[caret_line_number]
	mov	[selection_line],eax
	mov	[selection_line_number],ebx
	mov	eax,[caret_position]
	mov	[selection_position],eax
    select:
	call	get_mouse_position
	jmp	moved_selection
wm_lbuttondblclk:
	mov	[mouse_select],0
	call	get_mouse_position
	call	get_word_edges
	mov	[caret_position],ecx
	mov	[selection_position],ebx
	mov	eax,[caret_line]
	mov	[selection_line],eax
	mov	eax,[caret_line_number]
	mov	[selection_line_number],eax
	jmp	moved_selection
    get_word_edges:
	call	get_caret_segment
	mov	ebx,[caret_position]
	sub	ebx,edx
    find_left_edge:
	or	edx,edx
	jz	left_edge_in_previous_segment
	cmp	edx,SEGMENT_DATA_LENGTH
	ja	left_edge_ok
	mov	al,[esi+SEGMENT_HEADER_LENGTH+edx-1]
	call	recognize_character
	jc	left_edge_ok
	dec	edx
	jmp	find_left_edge
    left_edge_in_previous_segment:
	mov	esi,[esi+4]
	btr	esi,0
	jnc	left_edge_ok
	mov	edx,SEGMENT_DATA_LENGTH
	sub	ebx,edx
	jmp	find_left_edge
    left_edge_ok:
	add	ebx,edx
	call	get_caret_segment
	mov	ecx,[caret_position]
	sub	ecx,edx
    find_right_edge:
	cmp	edx,SEGMENT_DATA_LENGTH
	jae	right_edge_in_next_segment
	mov	al,[esi+SEGMENT_HEADER_LENGTH+edx]
	call	recognize_character
	jc	right_edge_ok
	inc	edx
	jmp	find_right_edge
    right_edge_in_next_segment:
	mov	esi,[esi]
	btr	esi,0
	jnc	right_edge_ok
	xor	edx,edx
	add	ecx,SEGMENT_DATA_LENGTH
	jmp	find_right_edge
    right_edge_ok:
	add	ecx,edx
	ret
wm_rbuttondown:
	cmp	[menu_handle],0
	je	ignore
	lea	eax,[point]
	invoke	GetCursorPos,eax
	invoke	TrackPopupMenu,[menu_handle],TPM_RIGHTBUTTON,[point.x],[point.y],0,[menu_window],0
	jmp	ignore
wm_copy:
	cmp	[was_selection],0
	je	ignore
	call	copy_to_clipboard
	jmp	ignore
    copy_to_clipboard:
	call	get_block_length
	inc	ecx
	invoke	GlobalAlloc,GMEM_MOVEABLE+GMEM_DDESHARE,ecx
	mov	ebx,eax
	invoke	GlobalLock,ebx
	mov	edi,eax
	push	ebx
	call	copy_block
	pop	ebx
	invoke	GlobalUnlock,ebx
	invoke	OpenClipboard,[hwnd]
	invoke	EmptyClipboard
	invoke	SetClipboardData,CF_TEXT,ebx
	or	eax,eax
	jz	copy_failed
	invoke	CloseClipboard
	ret
    copy_failed:
	invoke	GlobalFree,ebx
	ret
wm_cut:
	cmp	[was_selection],0
	je	ignore
	call	copy_to_clipboard
wm_clear:
	cmp	[was_selection],0
	je	ignore
	call	store_status_for_undo
	call	delete_block
	mov	[selection_line],0
	jmp	text_modified
wm_paste:
	call	store_status_for_undo
	cmp	[was_selection],0
	je	paste_secureselection_ok
	test	[editor_style],AES_SECURESEL
	jnz	paste_secureselection_ok
	call	delete_block
    paste_secureselection_ok:
	invoke	OpenClipboard,NULL
	invoke	GetClipboardData,CF_TEXT
	or	eax,eax
	jnz	do_paste
	invoke	CloseClipboard
	jmp	ignore
    do_paste:
	or	[clipboard_opened],-1
	mov	ebx,eax
	invoke	GlobalLock,ebx
	mov	esi,eax
	push	ebx
	call	insert_block
	jc	paste_failed
	pop	ebx
	invoke	GlobalUnlock,ebx
	invoke	CloseClipboard
	mov	[clipboard_opened],0
	test	[editor_style],AES_SECURESEL
	jz	no_selection_after_paste
	mov	eax,[caret_line]
	mov	ecx,[caret_line_number]
	mov	edx,[caret_position]
	xchg	eax,[selection_line]
	xchg	ecx,[selection_line_number]
	xchg	edx,[selection_position]
	mov	[caret_line],eax
	mov	[caret_line_number],ecx
	mov	[caret_position],edx
	jmp	text_modified
    no_selection_after_paste:
	mov	[selection_line],0
	jmp	text_modified
    paste_failed:
	call	undo_changes
	pop	ebx
	invoke	GlobalUnlock,ebx
	invoke	CloseClipboard
	mov	[clipboard_opened],0
	jmp	text_modified
wm_settext:
	mov	esi,[lparam]
	call	set_text
	mov	[return_value],TRUE
	jmp	text_modified
wm_gettextlength:
	mov	esi,[first_line]
    count_text_length:
	call	check_line_length
	add	[return_value],ecx
	mov	esi,[esi]
	or	esi,esi
	jz	ignore
	add	[return_value],2
	jmp	count_text_length
wm_gettext:
	mov	esi,[first_line]
	mov	edi,[lparam]
	sub	[wparam],1
	jc	ignore
    copy_text:
	push	esi edi
	call	check_line_length
	pop	edi esi
	test	[editor_style],AES_OPTIMALFILL
	jz	direct_copy
	or	ecx,ecx
	jz	direct_copy
	push	edi ecx
	mov	edi,[line_buffer]
	xor	edx,edx
	call	copy_from_line
	push	esi
	mov	esi,[line_buffer]
	mov	edi,[line_buffer]
	add	edi,[peak_line_length]
	mov	ebx,edi
	mov	ecx,[esp+4]
	xor	al,al
	rep	stosb
	mov	ecx,[esp+4]
	invoke	syntax_proc,esi,ecx,ebx
	pop	esi ecx edi
	mov	eax,[return_value]
	add	eax,ecx
	cmp	eax,[wparam]
	jbe	optimal_fill_size_ok
	mov	ecx,[wparam]
	sub	eax,[return_value]
    optimal_fill_size_ok:
	push	esi edi
	mov	esi,[line_buffer]
	mov	ebx,[peak_line_length]
	jecxz	optimal_fill_done
	xor	edx,edx
    optimal_fill:
	lodsb
	cmp	al,20h
	jne	store_character
	cmp	byte [esi-1+ebx],0
	jne	store_character
	mov	eax,esi
	sub	eax,[line_buffer]
	test	eax,111b
	jz	store_tab
	inc	edx
	mov	al,20h
	stosb
	loop	optimal_fill
	jmp	optimal_fill_done
    store_tab:
	mov	al,20h
	or	edx,edx
	jz	store_character
	sub	edi,edx
	mov	al,9
    store_character:
	stosb
	xor	edx,edx
	loop	optimal_fill
    optimal_fill_done:
	pop	eax
	neg	eax
	add	eax,edi
	add	[return_value],eax
	pop	esi
	jmp	line_copied
    direct_copy:
	mov	eax,[return_value]
	add	eax,ecx
	cmp	eax,[wparam]
	jbe	direct_copy_size_ok
	mov	ecx,[wparam]
	sub	eax,[return_value]
    direct_copy_size_ok:
	add	[return_value],ecx
	xor	edx,edx
	call	copy_from_line
    line_copied:
	or	esi,esi
	jz	text_copied
	mov	ecx,[return_value]
	add	ecx,2
	cmp	ecx,[wparam]
	ja	text_copied
	mov	ax,0A0Dh
	stosw
	mov	[return_value],ecx
	cmp	ecx,[wparam]
	jne	copy_text
    text_copied:
	xor	al,al
	stosb
	jmp	ignore
aem_getlinelength:
	mov	esi,[caret_line]
	mov	eax,[wparam]
	or	eax,eax
	jz	return_length
	call	find_line
	cmp	ecx,[wparam]
	je	return_length
	or	[return_value],-1
	jmp	ignore
    return_length:
	call	check_line_length
	mov	[return_value],ecx
	jmp	ignore
aem_getline:
	mov	esi,[caret_line]
	mov	eax,[wparam]
	or	eax,eax
	jz	get_line
	call	find_line
	cmp	ecx,[wparam]
	jne	ignore
    get_line:
	push	esi
	call	check_line_length
	pop	esi
	mov	[return_value],ecx
	mov	edi,[lparam]
	call	copy_from_line
	xor	al,al
	stosb
	jmp	ignore
wm_setfont:
	mov	esi,[wparam]
	or	esi,esi
	jnz	get_metrics
	mov	esi,[asmedit_font]
    get_metrics:
	invoke	GetDC,[hwnd]
	mov	ebx,eax
	invoke	SelectObject,ebx,esi
	lea	eax,[tm]
	invoke	GetTextMetrics,ebx,eax
	invoke	ReleaseDC,[hwnd],ebx
	test	[tm.tmPitchAndFamily],TMPF_FIXED_PITCH
	jnz	ignore
	mov	[return_value],esi
	mov	[editor_font],esi
	mov	eax,[tm.tmHeight]
	mov	[font_height],eax
	mov	eax,[tm.tmAveCharWidth]
	mov	[font_width],eax
	call	create_caret
	mov	eax,[lparam]
	mov	[redraw_now],al
	jmp	wm_size
wm_getfont:
	mov	eax,[editor_font]
	cmp	eax,[asmedit_font]
	je	ignore
	mov	[return_value],eax
	jmp	ignore
wm_undo:
	cmp	[undo_data],0
	je	ignore
	call	undo_changes
	mov	[last_operation],0
	call	create_caret
	jmp	text_modified
em_canundo:
	mov	eax,[undo_data]
	or	eax,eax
	jz	ignore
	mov	[return_value],TRUE
	jmp	ignore
em_emptyundobuffer:
	call	clear_undo_data
	jmp	ignore
em_replacesel:
	test	[editor_mode],AEMODE_VERTICALSEL + AEMODE_OVERWRITE
	jnz	ignore
	cmp	[wparam],0
	je	replace_undo_ok
	call	store_status_for_undo
    replace_undo_ok:
	cmp	[was_selection],0
	je	simple_replace
	push	[caret_line_number]
	push	[caret_position]
	call	delete_block
	pop	edx ecx
	cmp	ecx,[caret_line_number]
	jne	simple_replace
	cmp	edx,[caret_position]
	jne	simple_replace
	mov	esi,[lparam]
	call	insert_block
	mov	esi,[caret_line]
	mov	ecx,[caret_line_number]
	mov	edx,[caret_position]
	xchg	esi,[selection_line]
	xchg	ecx,[selection_line_number]
	xchg	edx,[selection_position]
	mov	[caret_line],esi
	mov	[caret_line_number],ecx
	mov	[caret_position],edx
	mov	[notification],AEN_TEXTCHANGE
	pop	[editor_mode]
	jmp	text_modified
    simple_replace:
	mov	esi,[lparam]
	call	insert_block
	mov	[notification],AEN_TEXTCHANGE
	pop	[editor_mode]
	jmp	text_modified
aem_setmode:
	mov	eax,[wparam]
	xchg	[editor_mode],eax
	cmp	eax,[editor_mode]
	je	ignore
	mov	[notification],AEN_MODECHANGE
	call	create_caret
	cmp	[was_selection],0
	jne	moved_window
	jmp	done
aem_getmode:
	mov	eax,[editor_mode]
	mov	[return_value],eax
	jmp	ignore
aem_setsyntaxhighlight:
	mov	eax,[wparam]
	mov	ebx,[lparam]
	mov	[syntax_colors],eax
	mov	[syntax_proc],ebx
	or	eax,eax
	jnz	wm_size
	mov	[syntax_proc],SyntaxProc
	jmp	wm_size
aem_setrightclickmenu:
	mov	eax,[wparam]
	mov	ebx,[lparam]
	mov	[menu_handle],eax
	mov	[menu_window],ebx
	jmp	ignore
aem_settextcolor:
	mov	eax,[wparam]
	mov	ebx,[lparam]
	mov	[text_color],eax
	mov	[background_color],ebx
	jmp	wm_size
aem_setselcolor:
	mov	eax,[wparam]
	mov	ebx,[lparam]
	mov	[selection_text],eax
	mov	[selection_background],ebx
	jmp	wm_size
aem_setpos:
	mov	edi,[wparam]
	virtual at edi
	pos	AEPOS
	end	virtual
	cmp	[selection_line],0
	jne	selection_current_ok
	mov	eax,[caret_line]
	mov	[selection_line],eax
	mov	eax,[caret_line_number]
	mov	[selection_line_number],eax
	mov	eax,[caret_position]
	mov	[selection_position],eax
    selection_current_ok:
	mov	eax,[pos.selectionLine]
	or	eax,eax
	jz	selection_line_ok
	call	find_line
	mov	[selection_line],esi
	mov	[selection_line_number],ecx
    selection_line_ok:
	mov	eax,[pos.selectionPosition]
	sub	eax,1
	jc	selection_position_set
	cmp	eax,[peak_line_length]
	jbe	new_selection_position
	mov	eax,[peak_line_length]
    new_selection_position:
	mov	[selection_position],eax
    selection_position_set:
	mov	eax,[pos.caretLine]
	or	eax,eax
	jz	caret_line_ok
	call	find_line
	mov	[caret_line],esi
	mov	[caret_line_number],ecx
    caret_line_ok:
	mov	eax,[pos.caretPosition]
	sub	eax,1
	jc	moved_selection
	cmp	eax,[peak_line_length]
	jbe	new_caret_position
	mov	eax,[peak_line_length]
    new_caret_position:
	mov	[caret_position],eax
	jmp	moved_selection
aem_getpos:
	mov	edi,[wparam]
	mov	eax,[caret_line_number]
	mov	[pos.selectionLine],eax
	mov	[pos.caretLine],eax
	mov	eax,[caret_position]
	inc	eax
	mov	[pos.selectionPosition],eax
	mov	[pos.caretPosition],eax
	cmp	[selection_line],0
	je	ignore
	mov	eax,[selection_line_number]
	mov	[pos.selectionLine],eax
	mov	eax,[selection_position]
	inc	eax
	mov	[pos.selectionPosition],eax
	jmp	ignore
aem_findfirst:
	mov	esi,[lparam]
	mov	eax,[wparam]
	call	find_first
	jnc	show_found_text
	jmp	ignore
aem_findnext:
	call	find_next
	jc	ignore
    show_found_text:
	mov	eax,[caret_position]
	xchg	eax,[selection_position]
	mov	[caret_position],eax
	call	update_positions
	call	let_caret_appear
	mov	eax,[caret_position]
	xchg	eax,[selection_position]
	mov	[caret_position],eax
	mov	[return_value],TRUE
	jmp	moved_selection
aem_canfindnext:
	cmp	[search_data],0
	je	ignore
	mov	[return_value],TRUE
	jmp	ignore
aem_getwordatcaret:
	cmp	[wparam],0
	je	ignore
	call	get_word_edges
	mov	eax,ebx
	add	eax,[wparam]
	dec	eax
	cmp	eax,ecx
	jae	word_buffer_length_ok
	mov	ecx,eax
    word_buffer_length_ok:
	sub	ecx,ebx
	push	[caret_position]
	mov	[caret_position],ebx
	push	ecx
	call	get_caret_segment
	pop	ebx
	mov	edi,[lparam]
	or	ebx,ebx
	jz	word_copied
    copy_word:
	mov	ecx,SEGMENT_DATA_LENGTH
	sub	ecx,edx
	cmp	ecx,ebx
	jbe	word_part_length_ok
	mov	ecx,ebx
    word_part_length_ok:
	sub	ebx,ecx
	add	[return_value],ecx
	mov	eax,[esi]
	lea	esi,[esi+SEGMENT_HEADER_LENGTH+edx]
	rep	movsb
	or	ebx,ebx
	jz	word_copied
	xor	edx,edx
	mov	esi,eax
	btr	esi,0
	jc	copy_word
    word_copied:
	xor	al,al
	stosb
	pop	[caret_position]
	jmp	ignore
moved_caret:
	test	[kbstate+VK_SHIFT],80h
	jnz	moved_selection
	mov	[selection_line],0
moved_selection:
	mov	[notification],AEN_POSCHANGE
	jmp	update_all
moved_window:
	call	update_positions
	jmp	refresh
text_modified:
	mov	[notification],AEN_TEXTCHANGE
	mov	eax,[peak_line_length]
	xor	edx,edx
	mov	ebx,SEGMENT_DATA_LENGTH
	div	ebx
	inc	eax
	mul	ebx
	shl	eax,1
	cmp	eax,[line_buffer_size]
	je	update_all
	mov	[line_buffer_size],eax
	invoke	VirtualAlloc,0,[line_buffer_size],MEM_COMMIT,PAGE_READWRITE
	or	eax,eax
	jz	memory_shortage
	xchg	[line_buffer],eax
	invoke	VirtualFree,eax,0,MEM_RELEASE
    update_all:
	call	update_positions
	call	let_caret_appear
    refresh:
	cmp	[screen_base],0
	je	wm_size
	mov	eax,[screen_size]
	shl	eax,1
	xor	[screen_offset],eax
	call	update_screen
	mov	esi,[screen_base]
	mov	eax,[screen_size]
	lea	edi,[esi+eax*2]
	mov	[rect.top],0
	mov	edx,[font_height]
	mov	[rect.bottom],edx
	mov	ecx,[screen_height]
    refresh_screen:
	push	ecx
	mov	ebx,[screen_size]
	mov	edx,[font_width]
	xor	eax,eax
	mov	[rect.left],eax
	mov	[rect.right],eax
	mov	ecx,[screen_width]
    refresh_line:
	mov	al,[esi]
	mov	ah,[esi+ebx]
	cmp	al,[edi]
	jne	refresh_changed
	cmp	ah,[edi+ebx]
	jne	refresh_changed
	inc	esi
	inc	edi
	add	[rect.left],edx
	add	[rect.right],edx
	loop	refresh_line
	jmp	refresh_next_line
    refresh_changed:
	mov	al,[esi]
	mov	ah,[esi+ebx]
	inc	esi
	add	[rect.right],edx
	cmp	al,[edi]
	jne	changed_more
	cmp	ah,[edi+ebx]
	jne	changed_more
	inc	edi
	jmp	invalidate
    changed_more:
	inc	edi
	loop	refresh_changed
    invalidate:
	push	ecx edx
	lea	eax,[rect]
	invoke	InvalidateRect,[hwnd],eax,FALSE
	pop	edx ecx
	mov	eax,[rect.right]
	mov	[rect.left],eax
	jecxz	refresh_next_line
	loop	refresh_line
    refresh_next_line:
	mov	eax,[font_height]
	add	[rect.top],eax
	add	[rect.bottom],eax
	pop	ecx
	dec	ecx
	jnz	refresh_screen
	jmp	done
ignore:
	mov	dl,[last_operation]
	mov	[current_operation],dl
	cmp	[was_selection],0
	jne	done
	mov	[selection_line],0
done:
	cmp	[focus],0
	je	caret_ok
	call	update_caret_position
	invoke	ShowCaret,[hwnd]
    caret_ok:
	lea	esi,[editor_data]
	mov	edi,[editor_memory]
	add	edi,8
	mov	ecx,editor_data_size shr 2
	rep	movsd
	cmp	[notification],0
	je	notification_ok
	invoke	GetWindowLong,[hwnd],GWL_HWNDPARENT
	mov	edi,eax
	invoke	GetWindowLong,[hwnd],GWL_ID
	movzx	ebx,[notification]
	shl	ebx,16
	or	eax,ebx
	invoke	SendMessage,edi,WM_COMMAND,eax,[hwnd]
    notification_ok:
	cmp	[redraw_now],0
	je	redraw_ok
	invoke	UpdateWindow,[hwnd]
    redraw_ok:
	mov	eax,[return_value]
finish_wndproc:
	pop	edi esi ebx
	return
not_enough_memory:
	lea	esp,[editor_memory-10h]
	mov	[notification],AEN_OUTOFMEMORY
	or	[return_value],-1
	cmp	[clipboard_opened],0
	je	ignore
	invoke	CloseClipboard
	mov	[clipboard_opened],0
	jmp	ignore
get_memory:
	invoke	VirtualAlloc,0,ecx,MEM_COMMIT,PAGE_READWRITE
	ret
release_memory:
	invoke	VirtualFree,eax,0,MEM_RELEASE
	ret
update_positions:
	lea	eax,[rect]
	invoke	GetClientRect,[hwnd],eax
	mov	eax,[rect.right]
	sub	eax,[rect.left]
	cdq
	div	[font_width]
	mov	[window_width],eax
	add	edx,-1
	adc	eax,0
	mov	[screen_width],eax
	mov	eax,[rect.bottom]
	sub	eax,[rect.top]
	cdq
	div	[font_height]
	mov	[window_height],eax
	add	edx,-1
	adc	eax,0
	mov	[screen_height],eax
	call	update_window
    setup_vscroll:
	mov	ecx,[lines_count]
	mov	[sc.cbSize],sizeof.SCROLLINFO
	mov	[sc.fMask],SIF_DISABLENOSCROLL+SIF_RANGE+SIF_PAGE+SIF_POS
	mov	[sc.nMin],1
	mov	[sc.nMax],ecx
	mov	eax,[window_height]
	mov	[sc.nPage],eax
	mov	edx,[window_line_number]
	mov	[sc.nPos],edx
	test	[editor_style],WS_VSCROLL
	jz	setup_hscroll
	lea	eax,[sc]
	invoke	SetScrollInfo,[hwnd],SB_VERT,eax,TRUE
    setup_hscroll:
	mov	ecx,[peak_line_length]
	mov	[sc.nMin],0
	mov	[sc.nMax],ecx
	mov	eax,[window_width]
	mov	[sc.nPage],eax
	mov	edx,[window_position]
	mov	[sc.nPos],edx
	test	[editor_style],WS_HSCROLL
	jz	setup_caret
	lea	eax,[sc]
	invoke	SetScrollInfo,[hwnd],SB_HORZ,eax,TRUE
    setup_caret:
	mov	eax,[font_width]
	mov	edx,[caret_position]
	sub	edx,[window_position]
	imul	eax,edx
	mov	[caret_x],eax
	mov	eax,[font_height]
	mov	edx,[caret_line_number]
	sub	edx,[window_line_number]
	imul	eax,edx
	mov	[caret_y],eax
	ret
create_caret:
	xor	eax,eax
	test	[editor_mode],AEMODE_OVERWRITE
	jnz	block_caret
	test	[editor_style],AES_CONSOLECARET
	jnz	console_caret
	invoke	CreateCaret,[hwnd],NULL,0,[font_height]
	jmp	update_caret_position
    block_caret:
	invoke	CreateCaret,[hwnd],NULL,[font_width],[font_height]
	jmp	update_caret_position
    console_caret:
	invoke	CreateCaret,[hwnd],NULL,[font_width],2
update_caret_position:
	mov	eax,[caret_y]
	test	[editor_mode],AEMODE_OVERWRITE
	jnz	set_position
	test	[editor_style],AES_CONSOLECARET
	jz	set_position
	add	eax,[font_height]
	sub	eax,2
    set_position:
	invoke	SetCaretPos,[caret_x],eax
	ret
update_screen:
	mov	edi,[screen_base]
	or	edi,edi
	jz	screen_prepared
	add	edi,[screen_offset]
	mov	ebx,[screen_size]
	add	ebx,edi
	push	ebx
	mov	ecx,[screen_height]
	mov	esi,[window_line]
    prepare_screen:
	push	ecx
	test	byte [esi],1
	jnz	prepare_long_line
	push	esi
	add	esi,SEGMENT_HEADER_LENGTH
	mov	ecx,SEGMENT_DATA_LENGTH
	call	prepare_line
	pop	esi
	mov	esi,[esi]
	jmp	prepare_next_line
    prepare_long_line:
	push	edi
	mov	edi,[line_buffer]
	xor	eax,eax
    combine_long_line_segments:
	add	esi,SEGMENT_HEADER_LENGTH
	mov	ecx,SEGMENT_DATA_LENGTH
	rep	movsb
	add	eax,SEGMENT_DATA_LENGTH
	mov	esi,[esi-SEGMENT_LENGTH]
	btr	esi,0
	jc	combine_long_line_segments
	mov	ecx,eax
	mov	eax,esi
	mov	esi,edi
	sub	esi,ecx
	pop	edi
	push	eax
	call	prepare_line
	pop	esi
    prepare_next_line:
	pop	ecx
	dec	ecx
	jz	prepare_selection
	or	esi,esi
	jnz	prepare_screen
    prepare_empty_lines:
	imul	ecx,[screen_width]
	xor	al,al
	mov	edx,ecx
	rep	stosb
	xchg	edi,ebx
	mov	ecx,edx
	rep	stosb
    prepare_selection:
	pop	ebx
	test	[editor_style],ES_NOHIDESEL
	jnz	hideselection_ok
	cmp	[focus],0
	je	screen_prepared
    hideselection_ok:
	cmp	[selection_line],0
	je	screen_prepared
	mov	eax,[window_line_number]
	mov	esi,[selection_line_number]
	mov	edi,[caret_line_number]
	sub	esi,eax
	sub	edi,eax
	mov	ecx,[window_position]
	mov	eax,[selection_position]
	mov	edx,[caret_position]
	sub	eax,ecx
	sub	edx,ecx
	cmp	esi,edi
	jle	selection_boundaries_ok
	xchg	esi,edi
	xchg	eax,edx
    selection_boundaries_ok:
	mov	ecx,[screen_height]
	cmp	edi,0
	jl	screen_prepared
	cmp	esi,ecx
	jge	screen_prepared
	cmp	esi,edi
	je	prepare_vsel
	test	[editor_mode],AEMODE_VERTICALSEL
	jz	prepare_hsel
    prepare_vsel:
	cmp	eax,edx
	jle	vselection_boundaries_ok
	xchg	eax,edx
    vselection_boundaries_ok:
	cmp	esi,0
	jge	vselection_start_ok
	xor	esi,esi
    vselection_start_ok:
	inc	edi
	cmp	edi,ecx
	jle	vselection_end_ok
	mov	edi,ecx
    vselection_end_ok:
	mov	ecx,[screen_width]
	cmp	edx,0
	jl	screen_prepared
	cmp	eax,ecx
	jge	screen_prepared
	cmp	eax,0
	jge	vselection_line_start_ok
	xor	eax,eax
    vselection_line_start_ok:
	cmp	edx,ecx
	jle	vselection_line_end_ok
	mov	edx,ecx
    vselection_line_end_ok:
	mov	ecx,edi
	sub	ecx,esi
	imul	esi,[screen_width]
	add	ebx,esi
    prepare_vselection_line:
	push	eax ecx
	mov	edi,ebx
	mov	ecx,edx
	sub	ecx,eax
	lea	edi,[ebx+eax]
	mov	al,80h
	rep	stosb
	add	ebx,[screen_width]
	pop	ecx eax
	loop	prepare_vselection_line
	jmp	screen_prepared
    prepare_hsel:
	cmp	esi,0
	jge	hselection_start_ok
	xor	esi,esi
	xor	eax,eax
    hselection_start_ok:
	cmp	edi,ecx
	jl	hselection_end_ok
	mov	edi,ecx
	xor	edx,edx
    hselection_end_ok:
	inc	esi
	mov	ecx,edi
	sub	ecx,esi
	imul	ecx,[screen_width]
	imul	esi,[screen_width]
	lea	edi,[ebx+esi]
	neg	eax
	add	eax,[screen_width]
	cmp	eax,0
	jle	hselection_start_line_ok
	sub	edi,eax
	add	ecx,eax
	sub	eax,[screen_width]
	jle	hselection_start_line_ok
	add	edi,eax
	sub	ecx,eax
    hselection_start_line_ok:
	cmp	edx,0
	jle	hselection_end_line_ok
	add	ecx,edx
	sub	edx,[screen_width]
	jle	hselection_end_line_ok
	sub	ecx,edx
    hselection_end_line_ok:
	mov	al,80h
	rep	stosb
    screen_prepared:
	ret
    prepare_line:
	push	edi ecx
	mov	ecx,[esp]
	mov	edi,[line_buffer]
	add	edi,ecx
	shr	ecx,2
	xor	eax,eax
	rep	stosd
	mov	ecx,[esp]
	sub	edi,ecx
	invoke	syntax_proc,esi,ecx,edi
	mov	edx,edi
	pop	eax edi
	push	esi edx
	mov	edx,[window_position]
	lea	esi,[esi+edx]
	sub	eax,edx
	jnc	line_position_ok
	xor	eax,eax
	jmp	line_length_ok
    line_position_ok:
	cmp	eax,[screen_width]
	jbe	line_length_ok
	mov	eax,[screen_width]
    line_length_ok:
	mov	ecx,eax
	rep	movsb
	pop	esi
	add	esi,edx
	mov	ecx,eax
	xchg	edi,ebx
	rep	movsb
	xchg	edi,ebx
	pop	esi
	cmp	eax,[screen_width]
	jb	after_end_of_line
	ret
    after_end_of_line:
	mov	ecx,[screen_width]
	sub	ecx,eax
	xor	al,al
	mov	edx,ecx
	rep	stosb
	xchg	edi,ebx
	mov	ecx,edx
	rep	stosb
	xchg	edi,ebx
	ret

include '..\memory.inc'
include '..\navigate.inc'
include '..\edit.inc'
include '..\blocks.inc'
include '..\search.inc'
include '..\undo.inc'

endp

proc SyntaxProc, lpLine,uChars,lpColors
	return
endp
