# Jump

<p style="text-align: right">
    <a href="../instruction_set.md">Index</a>
</p>

### Unconditional

Jump to `address` (or `base + offset`). Optionally store the address being jumped from in `target`

All four expressions have the same encoding, with zero values in the `target` or `offset` fields when not being used:

31:28 | 27:24 | 19:15    | 14:10 | 9:5       | 4:0
------|-------|----------|-------|-----------|---
`1`   | `0`   | `0`      | `x`   | `address` | `0`
`1`   | `0`   | `0`      | `x`   | `base`    | `offset`
`1`   | `0`   | `target` | `x`   | `address` | `x`
`1`   | `0`   | `target` | `x`   | `base`    | `offset`

```
jump(address)
jump(base + offset)
target := jump(address)
target := jump(base + offset)
```

### Conditional

Jump to `address` (or `base + offset`) if `test` is non-zero. Optionally store the address being jumped from in `target`

All four expressions have the same encoding, with zero values in the `target` or `offset` fields when not being used:

31:28 | 27:24 | 19:15    | 14:10  | 9:5       | 4:0
------|-------|----------|--------|-----------|---
`1`   | `1`   | `0`      | `test` | `address` | `0`
`1`   | `1`   | `0`      | `test` | `base`    | `offset`
`1`   | `1`   | `target` | `test` | `address` | `x`
`1`   | `1`   | `target` | `test` | `base`    | `offset`

```
jump(address) if test
jump(base + offset) if test
target := jump(address) if test
target := jump(base + offset) if test
```
