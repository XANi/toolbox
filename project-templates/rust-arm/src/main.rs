
#![deny(unsafe_code)]
#![no_std]
#![no_main]

use panic_halt as _;

use nb::block;

use stm32f1xx_hal::{
    prelude::*,
    pac,
    timer::Timer,
};
//use cortex_m_semihosting::hprintln;
use cortex_m_rt::entry;
use embedded_hal::digital::v2::OutputPin;

#[entry]
fn main() -> ! {
    // Access to peripherals common to Cortex M CPUs
    let core_peripherals = cortex_m::Peripherals::take().unwrap();
    // Access to peripherals that are device specific
    let device_peripherals = pac::Peripherals::take().unwrap();

    // RCC is responsible for reset and clock signal configuration
    // https://wiki.st.com/stm32mpu/wiki/RCC_internal_peripheral
    let mut rcc = device_peripherals.RCC.constrain();

    // FLASH is responsible for flash config (timing etc.)
    let mut flash = device_peripherals.FLASH.constrain();

    // freeze the RCC config. This is used so other functions have a base
    // to calculate say interrupt interval on timer
    // this is basically "continue working on internal RC clock that you used on boot"
    let clocks = rcc.cfgr.freeze(&mut flash.acr);

    // Get the GPIOC peripheral
    let mut gpioc = device_peripherals.GPIOC.split(&mut rcc.apb2);

    // Extract the PC13 (on Blue Pill that's a pin with LED)
    let mut led = gpioc.pc13.into_push_pull_output(&mut gpioc.crh);

    // Initialize timer based on the system clock, and calculate how much it would need to run with 6 Hz
    // then start running
    let mut timer = Timer::syst(core_peripherals.SYST, &clocks).start_count_down(6.hz());

    // we're not using interrupts here, just busy wait for simplicity
    loop {
        // wait for our timer to "tick"
        block!(timer.wait()).unwrap();
        // set a led
        led.set_high().unwrap();
        // wait again
        block!(timer.wait()).unwrap();
        // unset a led
        led.set_low().unwrap();
        // we're not using XOR because that requires read-modify-write loop but just setting/resetting value have hardware optimization on STM32
    }
}
