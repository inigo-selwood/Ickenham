/* Aggregation is the second stage of the leading zero counter. Pairs of
zero counts are aggregated (joined) until just one value remains.
*/
module LeadingZeroAggregator(
    leftPair,
    rightPair,

    result
);

parameter WIDTH = 2;

input [WIDTH - 1:0] leftPair;
input [WIDTH - 1:0] rightPair;

output [WIDTH:0] result;

// MSB (most-significant bit)
wire leftMSB = leftPair[WIDTH - 1];
wire rightMSB = rightPair[WIDTH - 1];

/* Encode the output

Left     | Right    | Result
---------|----------|---
`1x...x` | `1x...x` | `10...0`
`0x...x` | `x...x`  | `{0, leftPair}`
`1x...x` | `x...x`  | `{01, rightPair[1:]}`
*/
assign result = (leftMSB & rightMSB)
        ? {1'b1, {(WIDTH){1'b0}}}
        : (leftMSB
            ? {2'b01, rightPair[WIDTH - 2:0]}
            : {1'b0, leftPair});

endmodule
