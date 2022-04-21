/* The leading zero counter has applications in fast division, single-precision
floating point normalization, and data compression (among others).

This is a synchronous and parameterized implementation, which will prove more
efficient than a lookup table for widths larger than 3 bits

The classic algorithm only works with operands that are a power of 2 bits wide.
To resolve this, we split the operand up into sections which are that size.
See the generate block for more details.
*/
module LeadingZeroCounter(
    operand,
    result
);

parameter WIDTH = 7;

// Evaluates the number of wires needed to fully connect the block layers
function automatic int countWires();
    int layers = $clog2(WIDTH);
    int result = 0;
    int index;

    for(index = 0; index < layers; index = index + 1)
        result = result + (2 + index) * (1 << (layers - index - 1));

    return result;
endfunction

// Finds the index at which a given block's result should start
function automatic int blockWireIndex(int layerIndex, int blockIndex);
    int layers = $clog2(WIDTH);
    int result = countWires() - 1;
    int index;

    for(index = 0; index < layerIndex; index = index + 1)
        result = result - (2 + index) * (1 << (layers - index - 1));

    for(index = 0; index < blockIndex; index = index + 1)
        result = result - (2 + index);

    return result;
endfunction

input [WIDTH - 1:0] operand;
output [$clog2(WIDTH):0] result;

// `ifdef COCOTB_SIM
//     initial begin
//         $dumpfile("leading_zero_counter.vcd");
//         $dumpvars(0, LeadingZeroCounter);
//     end
// `endif

genvar layerIndex;
genvar blockIndex;

generate

    // Base cases: operands are small enough that we can just return the
    // result directly, without the need to instantiate a compressor or
    // aggregator
    if(WIDTH == 1)
        assign result = ~operand;
    else if(WIDTH == 2) begin
        assign result = {
            ~(operand[1] | operand[0]),
            ~operand[1] & operand[0]
        };
    end

    /* If the operand width is a power of 2, we can solve it with a compression
    stage and an inverted aggregator tree. We call it inverted because the
    first level of the tree is the widest.

    It's harder to read than a simple lookup table, but uses fewer logic
    elements -- especially at higher operand width values.
    */
    else if((WIDTH & (WIDTH - 1)) == 0) begin

        localparam wireCount = countWires();

        // We have to wire together the ports of each aggregator block. The
        // input values come from a compressor, and the output is our result
        wire [wireCount - 1:0] wires;
        LeadingZeroCompressor #(.WIDTH(WIDTH)) compressor(
            .operand(operand),
            .result(wires[wireCount - 1:wireCount - WIDTH])
        );
        assign result = wires[$clog2(WIDTH):0];

        // Here we generate a block for each pair on the previous level
        for(layerIndex = 1;
                layerIndex < $clog2(WIDTH);
                layerIndex = layerIndex + 1) begin

            for(blockIndex = 0;
                    blockIndex < (1 << ($clog2(WIDTH) - layerIndex - 1));
                    blockIndex = blockIndex + 1) begin

                localparam left = blockWireIndex(layerIndex - 1,
                        blockIndex * 2);
                localparam right = blockWireIndex(layerIndex - 1,
                        blockIndex * 2 + 1);
                localparam out = blockWireIndex(layerIndex, blockIndex);

                LeadingZeroAggregator #(.WIDTH(layerIndex + 1)) aggregator(
                    .leftPair(wires[left:left - layerIndex]),
                    .rightPair(wires[right:right - layerIndex]),
                    .result(wires[out:out - (layerIndex + 1)])
                );
            end
        end
    end

    // Otherwise, the width is not a power of 2. We split it into its largest
    // power of 2 factor (right), and a remainder (left)
    else begin
        localparam rightWidth = 1 << ($clog2(WIDTH) - 1);
        localparam leftWidth = WIDTH - rightWidth;

        wire [$clog2(leftWidth):0] leftResult;
        wire [$clog2(rightWidth):0] rightResult;

        LeadingZeroCounter #(.WIDTH(leftWidth)) left(
            .operand(operand[WIDTH - 1:rightWidth]),
            .result(leftResult)
        );

        LeadingZeroCounter #(.WIDTH(rightWidth)) right(
            .operand(operand[rightWidth - 1:0]),
            .result(rightResult)
        );

        assign result = (leftResult == leftWidth) ?
                (leftResult + rightResult) :
                leftResult;
    end

endgenerate

endmodule
