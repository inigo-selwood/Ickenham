# Signed Integer Operations

<p style="text-align: right">
    <a href="../instruction_set.md">Index</a>
</p>

**Arithmetic:**

1. [Add](#add)
2. [Subtract](#subtract)
3. [Multiply](#multiply)
4. [Divide](#divide)
5. [Remainder](#remainder)
6. [Full Divide](#full-divide)

**Comparison:**

1. [Less Than](#less-than)
2. [More Than](#more-than)
3. [Less Than or Equal To](#less-than-or-equal-to)
4. [More Than or Equal To](#more-than-or-equal-to)

---

### Add

Add `operand0` and `operand1`, storing result in register `target`

31:28 | 27:24 | 19:15    | 14:10 | 9:5        | 4:0
------|-------|----------|-------|------------|---
`3`   | `0`   | `target` | `x`   | `operand0` | `operand1`

```
target := operand0 + operand1
```

### Subtract

Subtract `operand1` from `operand0`, storing result in register `target`

31:28 | 27:24 | 19:15    | 14:10 | 9:5        | 4:0
------|-------|----------|-------|------------|---
`3`   | `1`   | `target` | `x`   | `operand0` | `operand1`

```
target := operand0 - operand1
```

### Multiply

Multiply `operand0` by `operand1`. Multiplication of two 32-bit values produces a 64-bit result, the respective halves of which are stored in `lower` and `upper`

31:28 | 27:24 | 19:15     | 14:10     | 9:5        | 4:0
------|-------|-----------|-----------|------------|---
`4`   | `2`   | `target0` | `target1` | `operand0` | `operand1`

```
lower, upper := operand0 * operand1
```

### Divide

Divide `operand0` by `operand1`, storing the result in register `target`

31:28 | 27:24 | 19:15    | 14:10 | 9:5        | 4:0
------|-------|----------|-------|------------|---
`3`   | `3`   | `target` | `0`   | `operand0` | `operand1`

```
target := operand0 / operand1
```

### Remainder

Find remainder of division of `operand0` by `operand1`, storing result in register `target`

31:28 | 27:24 | 19:15 | 14:10    | 9:5        | 4:0
------|-------|-------|----------|------------|---
`3`   | `3`   | `0`   | `target` | `operand0` | `operand1`

```
target := operand0 % operand1
```

### Full Divide

Store results of division of `operand0` by `operand1` in registers `quotient` and `remainder`

31:28 | 27:24 | 19:15      | 14:10       | 9:5        | 4:0
------|-------|------------|-------------|------------|---
`3`   | `3`   | `quotient` | `remainder` | `operand0` | `operand1`

```
quotient, remainder := operand0 /% operand1
```

---

### Less Than

Evaluate whether `operand0` is less than `operand1`, storing the result in register `target`

31:28 | 27:24 | 19:15    | 14:10 | 9:5        | 4:0
------|-------|----------|-------|------------|---
`3`   | `4`   | `target` | `x`   | `operand0` | `operand1`

```
target := operand0 < operand1
```

### More Than

Evaluate whether `operand0` is more than `operand1`, storing the result in register `target`

31:28 | 27:24 | 19:15    | 14:10 | 9:5        | 4:0
------|-------|----------|-------|------------|---
`3`   | `5`   | `target` | `x`   | `operand0` | `operand1`

```
target := operand0 > operand1
```

### Less Than or Equal To

Evaluate whether `operand0` is less than (or equal to) `operand1`, storing the result in register `target`

31:28 | 27:24 | 19:15    | 14:10 | 9:5        | 4:0
------|-------|----------|-------|------------|---
`3`   | `6`   | `target` | `x`   | `operand0` | `operand1`

```
target := operand0 <= operand1
```

### More Than or Equal To

Evaluate whether `operand0` is more than (or equal to) `operand1`, storing the result in register `target`

31:28 | 27:24 | 19:15    | 14:10 | 9:5        | 4:0
------|-------|----------|-------|------------|---
`3`   | `7`   | `target` | `x`   | `operand0` | `operand1`

```
target := operand0 >= operand1
```
