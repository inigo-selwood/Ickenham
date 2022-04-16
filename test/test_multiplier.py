import cocotb
from cocotb.triggers import Timer
from cocotb_test.simulator import run


def test_multiplier():
    run(verilog_sources=['../source/arithmetic/multiplier.v'],
        toplevel='Multiplier',
        module='test_multiplier')


@cocotb.test()
async def multiplier_test(device):

    for operand_0 in range(-8, 7):
        for operand_1 in range(-8, 7):

            device.operand0.value = operand_0
            device.operand1.value = operand_1

            await Timer(1)

            assert device.result.value == (operand_0 * operand_1) & 0xFF