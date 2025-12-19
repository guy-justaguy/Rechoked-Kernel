[BITS 64] 

--- MULTIBOOT HEADER (The GRUB Handshake) ---
MBOOT_PAGE_ALIGN    equ 1 << 0
MBOOT_MEM_INFO      equ 1 << 1
MBOOT_HEADER_MAGIC  equ 0x1BADB002
MBOOT_HEADER_FLAGS  equ MBOOT_PAGE_ALIGN | MBOOT_MEM_INFO
MBOOT_CHECKSUM      equ -(MBOOT_HEADER_MAGIC + MBOOT_HEADER_FLAGS)

section .multiboot
    align 4
    dd MBOOT_HEADER_MAGIC
    dd MBOOT_HEADER_FLAGS
    dd MBOOT_CHECKSUM

protected_mode_start:
    ; Load the 32-bit data selector (0x10 is often the offset for the Data Segment in GDT)
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; Set up the 32-bit stack pointer for the kernel
    mov esp, 0x90000 ; A temporary safe stack location 
       mov rsp, stack_top
    and rsp, -16
    ; *** Next step is to load the kernel binary from disk! ***
    ; 2. Set up the 64-bit Stack Pointer (RSP)
    ; Choose a high address (e.g., 1MB + 64KB) as a safe temporary stack
    mov rsp, 0x110000 

     mov cr0,eax

; Step 1: Prep CR4 for 64-bit features
mov rax, cr4        ; Get the CR4 bucket
or rax, 1 << 5      ; Set the PAE bit (Physical Address Extension)
mov cr4, rax        ; Pour it back. Now the CPU can handle 64-bit tables.

; Step 2: Enable Paging in CR0
mov rax, cr0        ; Get the CR0 bucket
or rax, 1 << 31     ; Set the PG bit (Paging)
mov cr0, rax        ; Pour it back. "Ching!" You are now in 64-bit mode.



    ; 3. Pass Multiboot info to C
    push ebx          ; Pointer to Multiboot info (The map!)
    push eax          ; The Magic Number (0x2BADB002)
 ; 4. Jump to the C++ Kernel Entry Point
jmp kernel_main ; Or call kernel_main if using OTHER syntax
5. The Eternal Hang (If kernel_main ever returns)
    cli
.hang:
    hlt
    jmp .hang

section .bss
align 16
stack_bottom:
    resb 16384        ; 16KB of raw stack space
stack_top:
long_mode_start:


