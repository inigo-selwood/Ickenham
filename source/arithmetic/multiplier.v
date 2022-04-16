module Multiplier(
    operand0,
    operand1,

    result,
);

parameter WIDTH = 4;

input signed [WIDTH - 1:0] operand0;
input signed [WIDTH - 1:0] operand1;

output signed [(2 * WIDTH) - 1:0] result;

`ifdef COCOTB_SIM
    initial begin
        $dumpfile("multiplier.vcd");
        $dumpvars(0, Multiplier);
    end
`endif

assign result = operand0 * operand1;

endmodule
