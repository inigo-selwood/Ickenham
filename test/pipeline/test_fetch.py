from itertools import cycle
import cocotb
from cocotb.triggers import Timer
from cocotb_test.simulator import run


def test_fetch():
    run(verilog_sources=['../source/pipeline/fetch.v'],
        toplevel='FetchStage',
        module='test_fetch')


async def cycle_clock(device):
    device.clock.value = 1
    await Timer(1)
    device.clock.value = 0
    await Timer(1)


async def cycle_until_ready(device, max_cycles=4):
    cycle = 0
    while device.ready.value == 0:
        await cycle_clock(device)
        if cycle > max_cycles:
            assert False, 'cycle limit exceeded'
        cycle = cycle + 1
    

async def start(device):
        device.start.value = 1
        await cycle_clock(device)
        device.start.value = 0


async def reset(device, enable_memory=True):
    if enable_memory:
        device.memoryReady.value = 1
    
    device.reset.value = 1
    await cycle_clock(device)
    device.reset.value = 0
    device.data.value = 0


@cocotb.test()
async def await_memory_test(device):
    await reset(device, False)
    assert device.ready.value == 0

    device.memoryReady.value = 1
    await cycle_clock(device)
    assert device.ready.value == 1
    assert device.address.value == 0
    assert device.load.value == 0


@cocotb.test()
async def await_start_test(device):
    await reset(device)
    assert device.ready.value == 1

    device.start.value = 1
    await cycle_clock(device)
    assert device.ready.value == 0


@cocotb.test()
async def increment_address_test(device):
    await reset(device)

    for address in range(2):
        await start(device)
        assert device.address.value == address
        await cycle_until_ready(device)


@cocotb.test()
async def fetch_immediate_test(device):
    await reset(device)

    # Instruction with 4 immediate operands
    instruction = 0b1111 << 20
    device.data.value = instruction
    await start(device)
    await cycle_clock(device)

    for immediate in range(4):
        assert device.ready.value == 0
        device.data.value = immediate
        await cycle_clock(device)
    
    await cycle_until_ready(device)

    assert device.instruction.value == instruction
    assert device.immediate0.value == 0
    assert device.immediate1.value == 1
    assert device.immediate2.value == 2
    assert device.immediate3.value == 3


@cocotb.test()
async def fetch_some_immediate_test(device):
    await reset(device)

    # Instruction with 4 immediate operands
    instruction = 0b0101 << 20
    device.data.value = instruction
    await start(device)
    await cycle_clock(device)

    for immediate in range(2):
        assert device.ready.value == 0
        device.data.value = immediate
        await cycle_clock(device)
    
    await cycle_until_ready(device)

    assert device.instruction.value == instruction
    assert device.immediate1.value == 0
    assert device.immediate3.value == 1


@cocotb.test()
async def latch_address_test(device):
    await reset(device)

    device.addressIn.value = 2
    device.latch.value = 1
    await cycle_clock(device)

    assert device.address.value == 2