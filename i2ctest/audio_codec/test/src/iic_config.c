#include "xparameters.h"
#include "xiic.h"
#include "xil_printf.h"
#define IIC_DEVICE_ID	   XPAR_IIC_0_DEVICE_ID

XIic Iic;

int main(void)
{
    XIic_Config *Config;
	int Status;

	/* Initialise the IIC driver so that it's ready to use */

	// Look up the configuration in the config table
	Config = XIic_LookupConfig(IIC_DEVICE_ID);
	if(NULL == Config) {
		return XST_FAILURE;
	}

	// Initialise the IIC driver configuration
	Status = XIic_CfgInitialize(&Iic, Config, Config->BaseAddress);
	if(Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Perform a self-test to ensure that the hardware was built correctly.
	 */
	Status = XIicPs_SelfTest(&Iic);
	if (Status != XST_SUCCESS) {
		xil_printf("IIC FAILED \r\n");
		return XST_FAILURE;

	}
	xil_printf("IIC Passed\r\n");


	//Set the IIC serial clock rate.
	Status = XIicPs_SetSClk(&Iic, IIC_SCLK_RATE);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}
}