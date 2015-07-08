; ==== KEYBOARD.ASM - процедуры работы с клавиатурой ====

;  === Ждем нажатия клавиши ===
Pause proc
      mov ah,10h
      int 16h
      ret
Pause endp