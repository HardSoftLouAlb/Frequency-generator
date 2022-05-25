#define soc_cv_av

#define DEBUG

#include <stdio.h>
#include <unistd.h>
#include <stdint.h>
#include <fcntl.h>
#include <sys/mman.h>
#include "hwlib.h"
#include "soc_cv_av/socal/socal.h"
#include "soc_cv_av/socal/hps.h"
#include "soc_cv_av/socal/alt_gpio.h"
#include "hps_0.h"






#define HW_REGS_BASE ( ALT_STM_OFST )
#define HW_REGS_SPAN ( 0x04000000 ) //64 MB with 32 bit adress space this is 256 MB
#define HW_REGS_MASK ( HW_REGS_SPAN - 1 )


//setting for the HPS2FPGA AXI Bridge
#define ALT_AXI_FPGASLVS_OFST (0xC0000000) // axi_master
#define HW_FPGA_AXI_SPAN (0x40000000) // Bridge span 1GB
#define HW_FPGA_AXI_MASK ( HW_FPGA_AXI_SPAN - 1 )



#include <stdlib.h>

int main(int argc, char *argv[]) {
   int i;
    for (i = 0; i < argc; i++)
        printf("argv[%d] = %s\n", i, argv[i]);

   int x = atoi(argv[1]);
   //pointer to the different address spaces

   void *virtual_base;
   int fd;


   uint8_t *h2p_lw_reg1_addr;
   uint8_t *h2p_lw_reg2_addr;




   // map the address space for the LED registers into user space so we can interact with them.
   // we'll actually map in the entire CSR span of the HPS since we want to access various registers within that span

   if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) {
      printf( "ERROR: could not open \"/dev/mem\"...\n" );
      return( 1 );
   }

   //lightweight HPS-to-FPGA bridge
   virtual_base = mmap( NULL, HW_REGS_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, HW_REGS_BASE );

   if( virtual_base == MAP_FAILED ) {
      printf( "ERROR: mmap() failed...\n" );
      close( fd );
      return( 1 );
   }






   h2p_lw_reg1_addr=virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + PIO_REG1_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
   h2p_lw_reg2_addr=virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + PIO_REG2_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
 
   for(i=0;i<1000;i++) {
        *(uint32_t *)h2p_lw_reg1_addr = x;
        printf( "h2p_lw_reg0_out_addr %d\n", *h2p_lw_reg1_addr);
        *(uint32_t *)h2p_lw_reg2_addr = 1;
        printf( "h2p_lw_reg1_out_addr %d\n", * h2p_lw_reg2_addr);
   }

/*
      int i;
      for( i=0;i<=255;i++){

      *(uint32_t *)h2p_lw_reg1_addr = i;
      printf( "h2p_lw_reg0_out_addr %d\n", *h2p_lw_reg1_addr);
      *(uint32_t *)h2p_lw_reg2_addr = 1;
      printf( "h2p_lw_reg1_out_addr %d\n", * h2p_lw_reg2_addr);
   
      sleep(1);
   }
   */
   


   if( munmap( virtual_base, HW_REGS_SPAN ) != 0 ) {
      printf( "ERROR: munmap() failed...\n" );
      close( fd );
      return( 1 );
   }

   close( fd );

   return( 0 );
}
