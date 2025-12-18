[BITS 32] 

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
       mov esp, stack_top
    and esp, -16
    ; *** Next step is to load the kernel binary from disk! ***
    ; 2. Set up the 32-bit Stack Pointer (ESP)
    ; Choose a high address (e.g., 1MB + 64KB) as a safe temporary stack
    mov esp, 0x110000 
    
    mov EAX, CR0 ; 3. Load the CR0 register to enable protected mode
    or EAX, 1    ; Set the PE (Protection Enable) bit 

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


