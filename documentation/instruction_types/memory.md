# Memory

<p style="text-align: right">
    <a href="../instruction_set.md">Index</a>
</p>

### Load

Load value at `address` into register `target`

Both expressions have the same encoding, with zero `offset` when the field is unused:

31:28 | 27:24 | 19:15    | 14:10 | 9:5       | 4:0
------|-------|----------|-------|-----------|---
`2`   | `0`   | `target` | `x`   | `address` | `0`
`2`   | `0`   | `target` | `x`   | `base`    | `offset`

```
target := load(address)
target := load(base + offset)
```

### Store

Store `value` at `address`

Both expressions have the same encoding, with zero `offset` when the field is unused:

31:28 | 27:24 | 19:15   | 14:10 | 9:5       | 4:0
------|-------|---------|-------|-----------|---
`2`   | `1`   | `value` | `x`   | `address` | `0`
`2`   | `1`   | `value` | `x`   | `base`    | `offset`

```
store(value, address)
store(value, base + offset)
```