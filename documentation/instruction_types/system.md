# System

<p style="text-align: right">
    <a href="../instruction_set.md">Index</a>
</p>

### Skip

Do nothing

31:28 | 27:24 | 19:15 | 14:10 | 9:5  | 4:0
------|-------|-------|-------|------|---
`0`   | `0`   | `0`   | `0`   | `0`  | `0`

```
skip()
```

### Reset

Soft-reset the CPU. Clears all registers, and enters privileged mode. Jumps to address `32'd0`

31:28 | 27:24 | 19:15 | 14:10 | 9:5  | 4:0
------|-------|-------|-------|------|---
`0`   | `1`   | `x`   | `x`   | `x`  | `x`

```
reset()
```
