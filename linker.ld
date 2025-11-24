ENTRY(start)                      /* The initial assembly label (e.g., in pm_entry.asm) */
PHDRS {
    code PT_LOAD;
    data PT_LOAD;
}
SECTIONS {
    . = 0x100000;                 /* Set the kernel load address to 1MB */

    .text : {                     /* Code section */
        *(.multiboot)             /* If using a standard bootloader */
        *(.text)
        . = ALIGN(0x1000);        /* Align the next section to a page boundary */
    } : code
    
    .rodata : {                   /* Read-only data */
        *(.rodata)
        . = ALIGN(0x1000);
    } : data
    
    .data : {                     /* Initialized data */
        *(.data)
        . = ALIGN(0x1000);
    } : data
    
    .bss : {                      /* Uninitialized data (set to zero by the loader/kernel) */
        *(.bss)
        . = ALIGN(0x1000);
    } : data
}