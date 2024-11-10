#include "xparameters.h"
#include "xiicps.h"
#include "xil_printf.h"
#include "main.h"
#include <xstatus.h>
#define XIICPS_BASEADDRESS	XPAR_XIICPS_0_BASEADDR
XIicPs Iic;

void AudioWriteToReg(uint8_t u8RegAddr, uint16_t u16Data){
    unsigned char u8TxData[2];
    int status = XST_FAILURE;
	u8TxData[0] = u8RegAddr << 1;
	u8TxData[0] = u8TxData[0] | ((u16Data >> 8) & 0b1);

	u8TxData[1] = u16Data & 0xFF;

	status = XIicPs_MasterSendPolled(&Iic, u8TxData, 2, IIC_SLAVE_ADDR);
	while(XIicPs_BusIsBusy(&Iic));
        if (status != XST_SUCCESS) {
		xil_printf("IIC Master Polled Example Test Failed\r\n");
	} 
    xil_printf("Yippee (Write)!\r\n");
}

void AudioReadReg(uint8_t u8RegAddr){
    uint8_t data = 0;
    uint8_t real_reg;
    int status = XST_FAILURE;
    real_reg = u8RegAddr << 1;
    XIicPs_SetOptions(&Iic, XIICPS_REP_START_OPTION);
    status = XIicPs_MasterSendPolled(&Iic, &real_reg, 1, IIC_SLAVE_ADDR);
    usleep(250000);
	XIicPs_ClearOptions(&Iic, XIICPS_REP_START_OPTION);
    status = XIicPs_MasterRecvPolled(&Iic, &data, 1, IIC_SLAVE_ADDR);
    if (status != XST_SUCCESS) {
		xil_printf("IIC FAILED \r\n");
	} else {
	    xil_printf("Yippee (Recv)\r\n");
    }
    xil_printf("%d\r\n", data);
}

int audioSetup(void){
	XIicPs_Config *Config;
	int Status;

	/* Initialise the IIC driver so that it's ready to use */

	// Look up the configuration in the config table
	Config = XIicPs_LookupConfig(XIICPS_BASEADDRESS);
	if(NULL == Config) {
		return XST_FAILURE;
	}

	// Initialise the IIC driver configuration
	Status = XIicPs_CfgInitialize(&Iic, Config, Config->BaseAddress);
	if(Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*u8RegAddr
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
    AudioWriteToReg(R15_SOFTWARE_RESET, 				0b000000000); //Perform Reset
	usleep(75000);
	AudioWriteToReg(R6_POWER_MANAGEMENT, 				0b000110000); //Power Up
	AudioWriteToReg(R0_LEFT_CHANNEL_ADC_INPUT_VOLUME, 	0b000101100); //Default Volume
	AudioWriteToReg(R1_RIGHT_CHANNEL_ADC_INPUT_VOLUME, 	0b000101100); //Default Volume
	AudioWriteToReg(R2_LEFT_CHANNEL_DAC_VOLUME, 		0b101111001);
	AudioWriteToReg(R3_RIGHT_CHANNEL_DAC_VOLUME, 		0b101111001);
	AudioWriteToReg(R4_ANALOG_AUDIO_PATH, 				0b000000000); //Allow Mixed DAC, Mute MIC
	AudioWriteToReg(R5_DIGITAL_AUDIO_PATH, 				0b000000000); //48 kHz Sampling Rate emphasis, no high pass
	AudioWriteToReg(R7_DIGITAL_AUDIO_I_F, 				0b000001010); //I2S Mode, set-up 32 bits
	AudioWriteToReg(R8_SAMPLING_RATE, 					0b000000000);
	usleep(75000);
	AudioWriteToReg(R9_ACTIVE, 							0b000000001); //Activate digital core
	AudioWriteToReg(R6_POWER_MANAGEMENT, 				0b000100000); //Output Power Up
    AudioReadReg(R6_POWER_MANAGEMENT);
    return XST_SUCCESS;
}

int main(void){
    int Status;
    Status = audioSetup();
    if (Status != XST_SUCCESS) {
		xil_printf("IIC Master Polled Example Test Failed\r\n");
		return XST_FAILURE;
	} 
    xil_printf("Yippee!\r\n");
	return XST_SUCCESS;
}