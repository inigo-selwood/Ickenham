module Adder(
    operand0,
    operand1,

    result,
    overflow,
);

parameter WIDTH = 4;

input signed [WIDTH - 1:0] operand0;
input signed [WIDTH - 1:0] operand1;

output signed [WIDTH - 1:0] result;
output overflow;

`ifdef COCOTB_SIM
    initial begin
        $dumpfile("adder.vcd");
        $dumpvars(0, Adder);
    end
`endif

wire signOperand0 = operand0[WIDTH - 1];
wire signOperand1 = operand1[WIDTH - 1];
wire signResult = result[WIDTH - 1];

assign result = operand0 + operand1;

assign overflow = signOperand0 == signOperand1 && signOperand0 != signResult;



endmodule
