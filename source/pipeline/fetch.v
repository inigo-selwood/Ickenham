module FetchStage(
    clock,
    start,
    reset,

    data,
    address,
    load,
    memoryReady,

    addressIn,
    latch,

    instruction,
    immediate0,
    immediate1,
    immediate2,
    immediate3,

    ready,
);

input clock;
input start;
input reset;

input [31:0] data;
output reg [31:0] address;
output reg load;
input memoryReady;

input [31:0] addressIn;
input latch;

output reg [31:0] instruction;
output reg [31:0] immediate0;
output reg [31:0] immediate1;
output reg [31:0] immediate2;
output reg [31:0] immediate3;

output reg ready;

reg [2:0] state;
reg [4:0] mask;

`ifdef COCOTB_SIM
    initial begin
        $dumpfile("fetch_stage.vcd");
        $dumpvars(0, FetchStage);
    end
`endif

localparam STATE_READY        = 3'd0;
localparam STATE_AWAIT_MEMORY = 3'd1;
localparam STATE_PROCESS      = 3'd2;

always @(posedge clock) begin

    // Reset or latch in a new address value
    if(reset || latch) begin
        load <= 0;
        if(latch)
            address <= addressIn;
        else
            address <= 0;

        // Wait for the memory device to be ready for a new read cycle
        if(memoryReady) begin
            ready <= 1;
            state <= STATE_READY;
        end
        else begin
            ready <= 0;
            state <= STATE_AWAIT_MEMORY;
        end
    end
    
    // Start fetch
    else if(start && ready) begin
        load <= 1;
        ready <= 0;
        mask <= 5'h1F;
        state <= STATE_PROCESS;
    end
    
    else begin
        case(state)
        
        // Wait until memory ready before exiting reset
        STATE_AWAIT_MEMORY: begin
            if(memoryReady) begin
                state <= STATE_READY;
                ready <= 1;
            end
        end

        // Wait for fetch to complete
        STATE_PROCESS: begin
            if(memoryReady) begin

                // Increment the address after the last successful read
                address <= address + 1;

                // First cycle: set instruction. Break if no immediate values
                // required
                // To do: This section is a bit ugly -- Look for a way of 
                // moving break logic outside the conditional expressions
                if(mask == 5'h1F) begin
                    instruction <= data;
                    mask <= 5'h0F;

                    if(data[23:20] == 0) begin
                        load <= 0;
                        ready <= 1;
                        state <= STATE_READY;
                    end
                end

                // First immediate argument, break if it was the last
                else if(mask[3] & instruction[23]) begin
                    immediate0 <= data;
                    mask <= 5'h07;

                    if((instruction[23:20] & 4'h7) == 0) begin
                        load <= 0;
                        ready <= 1;
                        state <= STATE_READY;
                    end
                end

                // Second immediate argument, break if it was the last
                else if(mask[2] & instruction[22]) begin
                    immediate1 <= data;
                    mask <= 5'h03;

                    if((instruction[23:20] & 4'h3) == 0) begin
                        load <= 0;
                        ready <= 1;
                        state <= STATE_READY;
                    end
                end

                // Third immediate argument, break if it was the last
                else if(mask[1] & instruction[21]) begin
                    immediate2 <= data;
                    mask <= 5'h01;

                    if((instruction[23:20] & 4'h1) == 0) begin
                        load <= 0;
                        ready <= 1;
                        state <= STATE_READY;
                    end
                end

                // Fourth immediate argument, break if it was the last
                else if(mask[0] & instruction[20]) begin
                    immediate3 <= data;
                    mask <= 5'h00;

                    load <= 0;
                    ready <= 1;
                    state <= STATE_READY;
                end
            end
        end

        endcase
    end
end

endmodule