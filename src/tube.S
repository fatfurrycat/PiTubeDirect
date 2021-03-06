#include "rpi-base.h"
#include "tube-defs.h"
     
#define instrREG r7
.text

.global arm_irq_handler
.global arm_fiq_handler

.global arm_fiq_handler_flag1


// =================================================
// ISR CODE
// =================================================
CACHELINE_ALIGN = 5

.align CACHELINE_ALIGN

// Default handlers for FIQ/IRQ do nothing

arm_fiq_handler:
arm_irq_handler:
        subs    pc, lr, #4

// ARM FIQ handler 
arm_fiq_handler_flag1:

      ldr      r12, =MBOX0_READ        // Read the GPU mailbox
      push     {r0-r7,r14}
      ldr      r0, [r12]               // Get Mailbox data 

      BL       tube_io_handler
      ldr      r10,=tube_irq
      pop      {r0-r7,r14}
      ldr      r10,[r10]
      tst      r10, #FAST6502_BIT      // see if we should signal the 6502 Core 
      tstne    r10,#RESET_BIT+NMI_BIT+IRQ_BIT
      orrne    instrREG, instrREG, #1024
        
       
      subs    pc, lr, #4
        
