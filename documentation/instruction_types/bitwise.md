# Bitwise Operations

<p style="text-align: right">
    <a href="../instruction_set.md">Index</a>
</p>

**Arithmetic:**

1. [AND](#and)
2. [OR](#or)
3. [Exclusive OR](#exclusive-or)
4. [NOT](#not)
5. [Shift-left](#shift-left)
6. [Shift-right (Logical)](#shift-right-logical)
6. [Shift-right (Arithmetic)](#shift-right-arithmetic)

**Comparison:**

1. [Equal](#equal)
2. [Not Equal](#not-equal)

---

### AND

Take the bitwise AND of `operand0` and `operand1`, storing the result in register `target`

31:28 | 27:24 | 19:15    | 14:10 | 9:5        | 4:0
------|-------|----------|-------|------------|---
`4`   | `0`   | `target` | `x`   | `operand0` | `operand1`

```
target := operand0 & operand1
```

### OR

Take the bitwise OR of `operand0` and `operand1`, storing the result in register `target`

31:28 | 27:24 | 19:15    | 14:10 | 9:5        | 4:0
------|-------|----------|-------|------------|---
`4`   | `1`   | `target` | `x`   | `operand0` | `operand1`

```
target := operand0 | operand1
```

### Exclusive OR

Take the bitwise exclusive-OR of `operand0` and `operand1`, storing the result in register `target`

31:28 | 27:24 | 19:15    | 14:10 | 9:5        | 4:0
------|-------|----------|-------|------------|---
`4`   | `2`   | `target` | `x`   | `operand0` | `operand1`

```
target := operand0 ^ operand1
```

### NOT

Take the bitwise NOT of `operand`, storing the result in register `target`

31:28 | 27:24 | 19:15    | 14:10 | 9:5       | 4:0
------|-------|----------|-------|-----------|---
`4`   | `3`   | `target` | `x`   | `operand` | `x`

```
target := ~operand
```

### Shift Left

Shift `base` left by `amount` bits, storing the result in register `target`

31:28 | 27:24 | 19:15    | 14:10 | 9:5    | 4:0
------|-------|----------|-------|--------|---
`4`   | `4`   | `target` | `x`   | `base` | `amount`

```
target := base << amount
```

### Shift Right (Logical)

Shift `base` right by `amount` bits, storing the result in register `target`

31:28 | 27:24 | 19:15    | 14:10 | 9:5    | 4:0
------|-------|----------|-------|--------|---
`4`   | `5`   | `target` | `x`   | `base` | `amount`

```
target := base >> amount
```

### Shift Right (Arithmetic)

Shift `base` right by `amount` bits, storing the result in register `target`. Preserves sign

31:28 | 27:24 | 19:15    | 14:10 | 9:5    | 4:0
------|-------|----------|-------|--------|---
`4`   | `6`   | `target` | `x`   | `base` | `amount`

```
target := base >>> amount
```

---

### Equal

Evaluate the equality of `operand0` and `operand1`, storing the result in register `target`

31:28 | 27:24 | 19:15    | 14:10 | 9:5        | 4:0
------|-------|----------|-------|------------|---
`4`   | `7`   | `target` | `x`   | `operand0` | `operand1`

```
target := operand0 == operand1
```

### Not Equal

Evaluate the inequality of `operand0` and `operand1`, storing the result in register `target`

31:28 | 27:24 | 19:15    | 14:10 | 9:5        | 4:0
------|-------|----------|-------|------------|---
`4`   | `8`   | `target` | `x`   | `operand0` | `operand1`

```
target := operand0 != operand1
```
