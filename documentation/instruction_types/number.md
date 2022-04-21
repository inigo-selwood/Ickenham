# Number (Floating Point) Operations

<p style="text-align: right">
    <a href="../instruction_set.md">Index</a>
</p>

**Arithmetic:**

1. [Add](#add)
2. [Subtract](#subtract)
3. [Multiply](#multiply)
4. [Divide](#divide)

**Comparison:**

1. [Less Than](#less-than)
2. [More Than](#more-than)
3. [Less Than or Equal To](#less-than-or-equal-to)
4. [More Than or Equal To](#more-than-or-equal-to)

**Conversion:**

1. [To Number](#cast-to-number)
2. [To Integer](#cast-to-integer)

---

### Add

Add `operand0` and `operand1`, storing result in register `target`

31:28 | 27:24 | 19:15    | 14:10 | 9:5        | 4:0
------|-------|----------|-------|------------|---
`5`   | `0`   | `target` | `x`   | `operand0` | `operand1`

```
target := operand0 .+ operand1
```

### Subtract

Subtract `operand1` from `operand0`, storing result in register `target`

31:28 | 27:24 | 19:15    | 14:10 | 9:5        | 4:0
------|-------|----------|-------|------------|---
`5`   | `1`   | `target` | `x`   | `operand0` | `operand1`

```
target := operand0 .- operand1
```

### Multiply

Multiply `operand0` by `operand1`, storing result in registers `target0` and `target1`

31:28 | 27:24 | 19:15    | 14:10 | 9:5        | 4:0
------|-------|----------|-------|------------|---
`5`   | `2`   | `target` | `x`   | `operand0` | `operand1`

```
lower, upper := operand0 .* operand1
```

### Divide

Divide `operand0` by `operand1`, storing the result in register `target`

31:28 | 27:24 | 19:15    | 14:10 | 9:5        | 4:0
------|-------|----------|-------|------------|---
`5`   | `3`   | `target` | `x`   | `operand0` | `operand1`

```
target := operand0 ./ operand1
```

---

### Less Than

Evaluate whether `operand0` is less than `operand1`, storing the result in register `target`

31:28 | 27:24 | 19:15    | 14:10 | 9:5        | 4:0
------|-------|----------|-------|------------|---
`5`   | `4`   | `target` | `x`   | `operand0` | `operand1`

```
target := operand0 .< operand1
```

### More Than

Evaluate whether `operand0` is more than `operand1`, storing the result in register `target`

31:28 | 27:24 | 19:15    | 14:10 | 9:5        | 4:0
------|-------|----------|-------|------------|---
`5`   | `5`   | `target` | `x`   | `operand0` | `operand1`

```
target := operand0 .> operand1
```

### Less Than or Equal To

Evaluate whether `operand0` is less than (or equal to) `operand1`, storing the result in register `target`

31:28 | 27:24 | 19:15    | 14:10 | 9:5        | 4:0
------|-------|----------|-------|------------|---
`5`   | `6`   | `target` | `x`   | `operand0` | `operand1`

```
target := operand0 .<= operand1
```

### More Than or Equal To

Evaluate whether `operand0` is more than (or equal to) `operand1`, storing the result in register `target`

31:28 | 27:24 | 19:15    | 14:10 | 9:5        | 4:0
------|-------|----------|-------|------------|---
`5`   | `7`   | `target` | `x`   | `operand0` | `operand1`

```
target := operand0 .>= operand1
```

---

### Cast to Number

Cast `integer` to a number, storing the result in register `target`

31:28 | 27:24 | 19:15    | 14:10 | 9:5       | 4:0
------|-------|----------|-------|-----------|---
`5`   | `8`   | `target` | `x`   | `integer` | `x`

```
target := number(integer)
```

### Cast to Integer

Cast `number` to an integer, storing the result in register `target`

31:28 | 27:24 | 19:15    | 14:10 | 9:5      | 4:0
------|-------|----------|-------|----------|---
`5`   | `9`   | `target` | `x`   | `number` | `x`

```
target := integer(number)
```
