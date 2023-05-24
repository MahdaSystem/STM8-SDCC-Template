/**
  ******************************************************************************
  * @file    Project/main.c 
  * @author  MCD Application Team
  * @version V2.2.0
  * @date    30-September-2014
  * @brief   Main program body
   ******************************************************************************
  * @attention
  *
  * <h2><center>&copy; COPYRIGHT 2014 STMicroelectronics</center></h2>
  *
  * Licensed under MCD-ST Liberty SW License Agreement V2, (the "License");
  * You may not use this file except in compliance with the License.
  * You may obtain a copy of the License at:
  *
  *        http://www.st.com/software_license_agreement_liberty_v2
  *
  * Unless required by applicable law or agreed to in writing, software 
  * distributed under the License is distributed on an "AS IS" BASIS, 
  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  * See the License for the specific language governing permissions and
  * limitations under the License.
  *
  ******************************************************************************
  */ 


/* Includes ------------------------------------------------------------------*/
#include "stm8s.h"
#include "stm8s_it.h"    /* SDCC patch: required by SDCC for interrupts */

/* Private defines -----------------------------------------------------------*/
#define LED_GPIO  GPIOD
#define LED_PIN   GPIO_PIN_3

#define USE_HSE   0


/* Private function prototypes -----------------------------------------------*/
void clock_setup(void);
void GPIO_setup(void);

void delay_ms(uint32_t d);


/* Private functions ---------------------------------------------------------*/

void main(void)
{
  clock_setup();
  GPIO_setup();

  /* Infinite loop */
  while (1)
  {
    GPIO_WriteReverse(LED_GPIO, LED_PIN);
    delay_ms(1000);
  }
}

void clock_setup(void)
{
  CLK_DeInit();
  CLK_LSICmd(DISABLE);

#if (USE_HSE)
  CLK_HSECmd(ENABLE);
  CLK_HSICmd(DISABLE);
  while (CLK_GetFlagStatus(CLK_FLAG_HSERDY) == FALSE);
#else
  CLK_HSECmd(DISABLE);
  CLK_HSICmd(ENABLE);
  while (CLK_GetFlagStatus(CLK_FLAG_HSIRDY) == FALSE);
#endif

  CLK_ClockSwitchCmd(ENABLE);
  CLK_SYSCLKConfig(CLK_PRESCALER_CPUDIV1);

#if (USE_HSE)
  CLK_ClockSwitchConfig(CLK_SWITCHMODE_MANUAL, CLK_SOURCE_HSE,
                        DISABLE, CLK_CURRENTCLOCKSTATE_ENABLE);
#else
  CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);
  CLK_ClockSwitchConfig(CLK_SWITCHMODE_AUTO, CLK_SOURCE_HSI,
                        DISABLE, CLK_CURRENTCLOCKSTATE_ENABLE);
#endif

  CLK_PeripheralClockConfig(CLK_PERIPHERAL_I2C, DISABLE);
  CLK_PeripheralClockConfig(CLK_PERIPHERAL_SPI, DISABLE);
  CLK_PeripheralClockConfig(CLK_PERIPHERAL_ADC, DISABLE);
  CLK_PeripheralClockConfig(CLK_PERIPHERAL_AWU, DISABLE);
  CLK_PeripheralClockConfig(CLK_PERIPHERAL_UART1, DISABLE);
  CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER1, DISABLE);
  CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER5, DISABLE);
  CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER6, DISABLE);
}

void GPIO_setup(void)
{
  // LED Pins
  GPIO_Init(LED_GPIO, LED_PIN, GPIO_MODE_OUT_PP_LOW_SLOW);
}

void delay_ms(uint32_t d)
{
  uint32_t x = 0;
  uint32_t fCPU = 0;
  
  fCPU = CLK_GetClockFreq();
  x = fCPU / 1000;
  x /= 50;
  d *= x;

  while (d--)
    __asm__("nop");
}



#ifdef USE_FULL_ASSERT

/**
  * @brief  Reports the name of the source file and the source line number
  *   where the assert_param error has occurred.
  * @param file: pointer to the source file name
  * @param line: assert_param error line source number
  * @retval : None
  */
void assert_failed(u8* file, u32 line)
{ 
  /* User can add his own implementation to report the file name and line number,
     ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */

  /* Infinite loop */
  while (1)
  {
  }
}
#endif


/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
