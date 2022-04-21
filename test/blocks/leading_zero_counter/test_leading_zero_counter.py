from math import floor
import random

import cocotb
from cocotb.triggers import Timer
from cocotb_test.simulator import run


_sources = [
    '../source/blocks/leading_zero_counter/counter.v',
    '../source/blocks/leading_zero_counter/compressor.v',
    '../source/blocks/leading_zero_counter/aggregator.v'
]


def test_counter():
    run(verilog_sources=_sources,
        toplevel='LeadingZeroCounter',
        module='test_leading_zero_counter')


@cocotb.test()
async def counter_test(device):

    for value in range(2 ** 7 - 1):
        copy = value

        leading_zeroes = 0
        while not copy >> 6 and leading_zeroes < 7:
            leading_zeroes += 1
            copy = copy << 1

        device.operand.value = value
        await Timer(1)
        assert device.result.value == leading_zeroes
