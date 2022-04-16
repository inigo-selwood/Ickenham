module Divider(
    clock,
    start,

    dividend,
    divisor,

    quotient,
    remainder,

    fault,
    ready
);

parameter WIDTH = 4;

input clock;
input start;

input signed [WIDTH - 1:0] dividend;
input signed [WIDTH - 1:0] divisor;

output reg signed [WIDTH - 1:0] quotient;
output reg signed [WIDTH - 1:0] remainder;

output reg fault;
output reg ready;

`ifdef COCOTB_SIM
    initial begin
        $dumpfile("divider.vcd");
        $dumpvars(0, Divider);
    end
`endif

reg [$clog2(WIDTH):0] iteration;

reg [WIDTH - 1:0] divisor_;

reg [WIDTH - 1:0] quotient_[1:0];
reg [WIDTH:0] accumulator[1:0];

reg dividendSign;
reg divisorSign;

// The actual arithmetic process; subtracts the divisor and shifts the result
// about in the accumulator
always @* begin
    if(accumulator[0] >= {1'b0, divisor_}) begin
        accumulator[1] = accumulator[0] - divisor_;
        {accumulator[1], quotient_[1]} =
                {accumulator[1][WIDTH - 1:0], quotient_[0], 1'b1};
    end
    else
        {accumulator[1], quotient_[1]} = {accumulator[0], quotient_[0]} << 1;
end

always @(posedge clock) begin
    if(start) begin

        // Flag division by zero
        if(divisor == 0) begin
            ready <= 1;
            fault <= 1;
        end

        // Zero divided by anything is just... zero
        else if(dividend == 0) begin
            ready <= 1;
            quotient <= 0;
            remainder <= 0;
        end

        // Division by 1/-1 is quick to solve
        else if(divisor == 1) begin
            quotient <= dividend;
            remainder <= 0;
            ready <= 1;
        end
        else if(divisor == {WIDTH{1'b1}}) begin
            quotient <= ~dividend + 1;
            remainder <= 0;
            ready <= 1;
        end

        // Similarly, division of a value _by_ a value (ignoring sign) can be 
        // worked out fast
        else if(dividend == divisor) begin
            quotient <= 1;
            remainder <= 0;
            ready <= 1;
        end
        else if(dividend == ~divisor + 1) begin
            quotient <= {WIDTH{1'b1}};
            remainder <= 0;
            ready <= 1;
        end

        // With a bit more effort, we can preempt divisions where the
        // denominator is larger than the numerator -- they'll always be zero
        else if(divisor[WIDTH - 1] == 0 
                && dividend[WIDTH - 1] == 0 
                && divisor > dividend) begin
            ready <= 1;
            quotient <= 0;
            remainder <= dividend;
        end
        else if(divisor[WIDTH - 1] == 0 
                && dividend[WIDTH - 1] 
                && divisor > (~dividend + 1)) begin
            ready <= 1;
            quotient <= 0;
            remainder <= divisor + dividend;
        end
        else if(divisor[WIDTH - 1] 
                && dividend[WIDTH - 1] == 0 
                && (~divisor + 1) > dividend) begin
            ready <= 1;
            quotient <= 0;
            remainder <= dividend + divisor;
        end
        else if(divisor[WIDTH - 1] 
                && dividend[WIDTH - 1] 
                && divisor < dividend) begin
            ready <= 1;
            quotient <= 0;
            remainder <= dividend;
        end

        // 2100
        // Otherwise, we start the tedious O(WIDTH) process
        else begin
            ready <= 0;
            fault <= 0;

            // Load the divisor into its register, and overlap the dividend
            // between the accumulator and quotient registers. In both cases,
            // if the values are signed, make them positive
            divisor_ <= divisor[WIDTH - 1] ? (~divisor + 1) : divisor;
            {accumulator[0][WIDTH:1], quotient_[0][0]} <= {(WIDTH + 1){1'b0}};
            {accumulator[0][0], quotient_[0][WIDTH - 1:1]} <=
                    dividend[WIDTH - 1] ? (~dividend + 1) : dividend;
            
            // Store the sign values for later use, since we've just removed 
            // that information from the registers
            dividendSign <= dividend[WIDTH - 1];
            divisorSign <= divisor[WIDTH - 1];

            iteration <= 0;
        end
    end

    // If an operation isn't being started, but is already underway, we can
    // either increment state or finish it
    else if(ready == 0) begin

        // The division is finished after WIDTH cycles -- so evaluate the 
        // quotient and remainder
        if(iteration == WIDTH - 1) begin
            ready <= 1;

            // The quotient will be positive if the signs of the inputs
            // matched, and negative otherwise
            if(dividendSign != divisorSign)
                quotient <= ~quotient_[1] + 1;
            else
                quotient <= quotient_[1];
            
            // If the remainder is positive, it doesn't need alteration
            if(accumulator[1][WIDTH:1] == 0)
                remainder <= 0;
            
            // When the operation has finished, the remainder can be found in
            // the upper 32 bits of the accumulator.
            //
            // For signed inputs, the remainder needs some adjustment:
            // - The sign of the remainder has to match the sign of the divisor
            // - If the quotient is negative, the remainder needs to be 
            //   subtracted from the divisor to form the result
            else begin
                case({divisorSign, divisorSign == dividendSign})
                2'b00:
                    remainder <= divisor_ - accumulator[1][WIDTH:1];
                2'b01:
                    remainder <= accumulator[1][WIDTH:1];
                2'b10:
                    remainder <= ~(divisor_ - accumulator[1][WIDTH:1]) + 1;
                2'b11:
                    remainder <= ~accumulator[1][WIDTH:1] + 1;
                endcase
            end
        end

        // Otherwise, swap the accumulator and quotient buffers around
        else begin
            accumulator[0] <= accumulator[1];
            quotient_[0] <= quotient_[1];

            iteration <= iteration + 1;
        end
    end
end

endmodule
