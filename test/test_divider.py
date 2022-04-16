from math import floor
import random 

import cocotb
from cocotb.triggers import Timer
from cocotb_test.simulator import run


def test_multiplier():
    run(verilog_sources=['../source/arithmetic/divider.v'],
        toplevel='Divider',
        module='test_divider')


async def cycle_clock(device):
    device.clock.value = 1
    await Timer(1)
    device.clock.value = 0
    await Timer(1)


@cocotb.test()
async def divider_test(device):

    for dividend in range(-8, 7):
        for divisor in range(-8, 7):

            if divisor == 0:
                continue

            device.dividend.value = dividend
            device.divisor.value = divisor

            device.start.value = 1
            await cycle_clock(device)
            device.start.value = 0

            cycle = 0
            while not device.ready.value:
                await cycle_clock(device)
                cycle += 1
                if cycle > 4:
                    assert False, 'cycle count exceeded'

            test_quotient = int(device.quotient.value)
            test_remainder = int(device.remainder.value)

            assert test_remainder == (dividend % divisor) & 0xF
            assert test_quotient == int(dividend / divisor) & 0xF

            assert not device.fault.value