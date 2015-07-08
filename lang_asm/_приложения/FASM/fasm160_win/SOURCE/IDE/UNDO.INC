
; Assembly Editor core
; Copyright (c) 2001-2004, Tomasz Grysztar.
; All rights reserved.

store_status_for_undo:
	pusha
	cmp	[was_selection],0
	jne	selection_status_ok
	mov	[selection_line],0
    selection_status_ok:
	call	allocate_segment
	jc	not_enough_memory
	mov	[eax],dword 0
	mov	edi,eax
	xchg	eax,[undo_data]
	push	eax edi
	call	allocate_segment
	pop	edi
	jnc	store_editor_status
	or	eax,-1
	stosd
	inc	[released_segments]
	jmp	not_enough_memory
    store_editor_status:
	mov	[eax],dword 0
	mov	[eax+4],dword 0
	stosd
	pop	eax
	stosd
	lea	esi,[editor_data]
	mov	ecx,editor_status_size shr 2
	rep	movsd
	popa
	clc
	ret

store_segment_for_undo:
	pusha
	or	esi,esi
	jz	segment_for_undo_ok
	mov	esi,[undo_data]
	or	esi,esi
	jz	segment_for_undo_ok
	mov	ebx,[esi]
	mov	eax,[esp+4]
	call	get_free_slot_in_undo_data
	push	edi
	call	allocate_segment
	pop	edi
	jc	memory_shortage
	mov	ebx,eax
	stosd
	mov	eax,[esp+4]
	stosd
	mov	esi,eax
	mov	edi,ebx
	mov	ecx,SEGMENT_LENGTH shr 2
	rep	movsd
    segment_for_undo_ok:
	popa
	ret
    get_free_slot_in_undo_data:
	mov	esi,[undo_data]
	mov	esi,[esi]
	mov	ecx,[esi+4]
	lea	edi,[esi+8+ecx*8]
	inc	ecx
	cmp	ecx,SEGMENT_DATA_LENGTH/8
	jbe	slot_ok
	push	esi
	call	allocate_segment
	jc	memory_shortage
	mov	esi,eax
	mov	ebx,[undo_data]
	mov	[ebx],esi
	pop	dword [esi]
	mov	ecx,1
	lea	edi,[esi+8]
    slot_ok:
	mov	[esi+4],ecx
	ret

store_free_segment_for_undo:
	pusha
	xor	edx,edx
	mov	[eax],edx
	mov	esi,[undo_data]
	or	esi,esi
	jz	segment_for_undo_ok
	call	get_free_slot_in_undo_data
	xor	eax,eax
	stosd
	mov	eax,[esp+1Ch]
	stosd
	popa
	ret

undo_changes:
	mov	esi,[undo_data]
	or	esi,esi
	jz	undo_ok
	or	ebx,-1
	xchg	ebx,[esi]
	inc	[released_segments]
	add	esi,4
	lodsd
	mov	[undo_data],eax
	lea	edi,[editor_data]
	mov	ecx,editor_status_size shr 2
	rep	movsd
    segments_block:
	or	ebx,ebx
	jz	undo_ok
	mov	esi,ebx
	or	ebx,-1
	xchg	ebx,[esi]
	inc	[released_segments]
	add	esi,4
	lodsd
	mov	ecx,eax
	jecxz	undo_ok
	lea	esi,[esi+ecx*8]
    restore_segments:
	sub	esi,8
	push	esi ecx
	mov	edi,[esi+4]
	mov	esi,[esi]
	or	esi,esi
	jnz	restore_data
	or	eax,-1
	stosd
	jmp	restore_next
    restore_data:
	mov	ecx,SEGMENT_LENGTH shr 2
	rep	movsd
	or	dword [esi-SEGMENT_LENGTH],-1
    restore_next:
	inc	[released_segments]
	pop	ecx esi
	loop	restore_segments
	jmp	segments_block
    undo_ok:
	ret

clear_undo_data:
	mov	esi,[undo_data]
	or	esi,esi
	jz	undo_data_ok
	or	ebx,-1
	xchg	ebx,[esi]
	inc	[released_segments]
	add	esi,4
	lodsd
	mov	[undo_data],eax
    release_segments_block:
	or	ebx,ebx
	jz	clear_undo_data
	mov	esi,ebx
	or	ebx,-1
	xchg	ebx,[esi]
	inc	[released_segments]
	add	esi,4
	lodsd
	mov	ecx,eax
	jecxz	clear_undo_data
	lea	esi,[esi+ecx*8]
    release_segments:
	sub	esi,8
	mov	eax,[esi]
	or	eax,eax
	jz	release_next
	or	dword [eax],-1
	inc	[released_segments]
    release_next:
	loop	release_segments
	jmp	release_segments_block
    undo_data_ok:
	ret
