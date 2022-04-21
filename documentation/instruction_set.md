# Instruction Set

### Section Pages

1. [System](instruction_types/system.md)
2. [Jump](instruction_types/jump.md)
3. [Memory](instruction_types/memory.md)
4. [Integer](instruction_types/integer.md)
5. [Bitwise](instruction_types/bitwise.md)
6. [Number (Floating Point)](instruction_types/number.md)

## Overview

### Reading Encoding Tables

Each instruction comes with a brief explanation, a table showing how the instruction should be encoded, and an example written in [micro](micro.md).

An encoding table will typically look like this:

31:28       | 27:24 | 15:19       | 10:14       | 5:9         | 0:4
------------|-------|-------------|-------------|-------------|---
`type-code` | `uid` | `register0` | `register1` | `register2` | `register3`

The first row of the table shows the bit range.

All literals shown should be presumed hexadecimal. A value of `x` indicates that the field is unused, and its contents won't influence the operation of the instruction.

### Register Conventions

- `register0` will always be the target (if any) of an instruction
- `register2` and `register3` are used for operands and addresses
- `register1` is a multi-purpose register, which can either be a second target, or another operand. 

More detail on registers available [here](registers.md)

### Immediate Values

The bits `23:20` (not shown in the encoding tables) are used to indicate that an immediate value should be used in place of a corresponding register. These value(s) are presumed to be the next words in memory following the instruction, arranged in ascending order of register number. The bits and their corresponding registers are:

Bit | Register
----|---
23  | 0
22  | 1
21  | 2
20  | 3

Only certain register fields for certain instructions can be replaced with immediate values. The rules are simple to infer:

- Any `target` field has to be a register
- Conditions for jump instructions can't immediate -- a constant condition implies an unconditional jump
- Arithmetic with two immediate values isn't permitted. That would represent a constant, which could be evaluated at compile-time
- Instructions which reference an address in memory can't have both an immediate `base` and `offset`, since again, that represents a knowable constant at compile time
