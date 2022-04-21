import cocotb
from cocotb.triggers import Timer
from cocotb_test.simulator import run


def test_adder():
    run(verilog_sources=['../source/arithmetic/adder.v'],
        toplevel='Adder',
        module='test_adder')


@cocotb.test()
async def adder_test(device):

    for operand_0 in range(-8, 7):
        for operand_1 in range(-8, 7):

            device.operand0.value = operand_0
            device.operand1.value = operand_1

            await Timer(1)

            result = operand_0 + operand_1
            overflow = result > 7 or result < -8

            assert device.result.value == result & 0xF
            assert device.overflow.value == overflow
