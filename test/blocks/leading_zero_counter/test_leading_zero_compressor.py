from math import floor
import random

import cocotb
from cocotb.triggers import Timer
from cocotb_test.simulator import run


def test_compressor():
    run(verilog_sources=['../source/blocks/leading_zero_counter/compressor.v'],
        toplevel='LeadingZeroCompressor',
        module='test_leading_zero_compressor')


@cocotb.test()
async def compressor_test(device):

    test_cases = [
        (0b0000, 0b1010),
        (0b0001, 0b1001),
        (0b0010, 0b1000),
        (0b0011, 0b1000),

        (0b0100, 0b0110),
        (0b0101, 0b0101),
        (0b0110, 0b0100),
        (0b0111, 0b0100),

        (0b1000, 0b0010),
        (0b1001, 0b0001),
        (0b1010, 0b0000),
        (0b1011, 0b0000),

        (0b1100, 0b0010),
        (0b1101, 0b0001),
        (0b1110, 0b0000),
        (0b1111, 0b0000),
    ]

    for case in test_cases:
        operand, result = case
        device.operand.value = operand

        await Timer(1)
        assert device.result.value == result, f'{operand}'
