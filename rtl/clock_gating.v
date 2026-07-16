module clock_gating(

    input  clk,
    input  enable,

    output gated_clk

);

reg enable_latch;

always @(clk or enable)
begin

    if(!clk)
        enable_latch = enable;

end

assign gated_clk = clk & enable_latch;

endmodule
