mov ax, 0x0

mov ds, ax
mov es, ax
mov ss, ax
mov fs, ax
mov gs, ax

; Set the Stack Segment (SS) to 0
mov ss, ax

; Set the Stack Pointer (SP) to a high address within that segment
; 0x7C00 is the start of the code, so 0x7C00 - 0x0004 is a safe place for a stack.
mov sp, 0x7C00
; Clear AX, BX, CX, and DX registers
xor ax, ax
xor bx, bx
xor cx, cx
xor dx, dx
; Clear SI and DI registers
mov ah, 0x0e      ; AH = TeleType Output function
mov al, 'b'       ; AL = The character to print
mov al, 'o'       ; AL = The character to print 
mov al, 'o'       ; AL = The character to print
mov al, 't'       ; AL = The character to print
mov al, 'l'       ; AL = The character to print
mov bh, 0x00      ; BH = Display page number (often 0)
int 0x10          ; Call the Video

mov eax, cr0      ; Read current value of CR0 into EAX
or eax, 0x1       ; Set the PE bit (bit 0)
mov cr0, eax      ; Write the new value back to CR0

; --- A20 Gate Enable ---
a20_wait_output:
    in al, 0x64       ; Read status from port 0x64 (status register)
    test al, 0x2      ; Check if the input buffer is full (bit 1)
    jnz a20_wait_output ; If it is full, wait (we want it empty)

a20_wait_input:
    in al, 0x64       ; Read status from port 0x64 (status register)
    test al, 0x1      ; Check if the output buffer is full (bit 0)
    jz a20_wait_input ; If it is empty, wait (we want it full to read)

    in al, 0x60       ; Read the data from port 0x60 (output buffer)
    jmp a20_wait_output ; Loop back to wait for the output buffer to be empty again
                        ; This clears any pending data in the output buffer

; Send the "Write to P2" command (command to write to controller output port)
a20_send_command:
    in al, 0x64
    test al, 0x2
    jnz a20_send_command
    mov al, 0xD1      ; Command: write output port (P2)
    out 0x64, al

; Send the actual data to enable A20 (bit 1 of output port)
a20_send_data:
    in al, 0x64
    test al, 0x2
    jnz a20_send_data
    mov al, 0xDF      ; Data: 0xDF (11011111) enables A20 (bit 1 is set)
    out 0x60, al
; --- A20 Gate Enabled ---