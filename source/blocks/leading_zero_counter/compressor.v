/* Compression is the first stage in the leading zero counter. The operand is
split into pairs of 2, and the number of leading zeroes in each pair is
counted. These values are then aggregated to form a single result
*/
module LeadingZeroCompressor(
    operand,
    result
);

parameter WIDTH = 4;

input [WIDTH - 1:0] operand;
output [WIDTH - 1:0] result;

genvar index;
generate

    /* Assign a number of leading zeroes to each pair of 2 bits

    Pair Value | Output
    -----------|---
    `00`       | `2`
    `01`       | `1`
    `10`       | `0`
    `11`       | `0`
    */
    for(index = 0; (index + 1) < WIDTH; index = index + 2) begin
        assign result[index + 1:index] = {
            ~(operand[index + 1] | operand[index]),
            ~operand[index + 1] & operand[index]
        };
    end

endgenerate

endmodule
