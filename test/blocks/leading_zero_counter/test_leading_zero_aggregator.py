from math import floor
import random

import cocotb
from cocotb.triggers import Timer
from cocotb_test.simulator import run


def test_aggregator():
    run(verilog_sources=['../source/blocks/leading_zero_counter/aggregator.v'],
        toplevel='LeadingZeroAggregator',
        module='test_leading_zero_aggregator')


@cocotb.test()
async def aggregator_test(device):

    test_cases = [
        (0b00, 0b00, 0b000),
        (0b00, 0b01, 0b000),
        (0b00, 0b10, 0b000),
        (0b00, 0b11, 0b000),

        (0b01, 0b00, 0b001),
        (0b01, 0b01, 0b001),
        (0b01, 0b10, 0b001),
        (0b01, 0b11, 0b001),

        (0b10, 0b00, 0b010),
        (0b10, 0b01, 0b011),
        (0b10, 0b10, 0b100),
        (0b10, 0b11, 0b100),

        (0b11, 0b00, 0b010),
        (0b11, 0b01, 0b011),
        (0b11, 0b10, 0b100),
        (0b11, 0b11, 0b100),
    ]

    for case in test_cases:
        left_value, right_value, result = case
        device.leftPair.value = left_value
        device.rightPair.value = right_value

        await Timer(1)
        assert device.result.value == result, f'{left_value}, {right_value}'
