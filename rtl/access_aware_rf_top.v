module access_aware_rf_top(

    input clk,
    input rst,

    input we,
    input [4:0] waddr,
    input [31:0] wdata,

    input read_valid1,
    input read_valid2,

    input [4:0] raddr1,
    input [4:0] raddr2,

    output [31:0] rdata1,
    output [31:0] rdata2,

    output [3:0] bank_access,
    output [3:0] bank_enable

);

wire [1:0] r_bank1;
wire [1:0] r_bank2;
wire [1:0] w_bank;

wire bank_clk0;
wire bank_clk1;
wire bank_clk2;
wire bank_clk3;

wire [15:0] bank0_hits;
wire [15:0] bank1_hits;
wire [15:0] bank2_hits;
wire [15:0] bank3_hits;

wire [3:0] threshold0;
wire [3:0] threshold1;
wire [3:0] threshold2;
wire [3:0] threshold3;

assign r_bank1 = raddr1[4:3];
assign r_bank2 = raddr2[4:3];
assign w_bank  = waddr[4:3];

bank_access_generator access_gen(

    .raddr1(raddr1),
    .raddr2(raddr2),
    .waddr(waddr),

    .r_bank1(r_bank1),
    .r_bank2(r_bank2),
    .w_bank(w_bank),

    .read_valid1(read_valid1),
    .read_valid2(read_valid2),
    .write_valid(we),

    .bank_access(bank_access)

);

access_monitor_v2 monitor(

    .clk(clk),
    .rst(rst),

    .bank_access(bank_access),

    .bank_enable(bank_enable)

);
bank_statistics stats(

    .clk(clk),
    .rst(rst),

    .bank_access(bank_access),

    .bank0_hits(bank0_hits),
    .bank1_hits(bank1_hits),
    .bank2_hits(bank2_hits),
    .bank3_hits(bank3_hits)

);
adaptive_threshold threshold_gen(

    .bank0_hits(bank0_hits),
    .bank1_hits(bank1_hits),
    .bank2_hits(bank2_hits),
    .bank3_hits(bank3_hits),

    .threshold0(threshold0),
    .threshold1(threshold1),
    .threshold2(threshold2),
    .threshold3(threshold3)

);
clock_gating CG0(
    .clk(clk),
    .enable(bank_enable[0]),
    .gated_clk(bank_clk0)
);

clock_gating CG1(
    .clk(clk),
    .enable(bank_enable[1]),
    .gated_clk(bank_clk1)
);

clock_gating CG2(
    .clk(clk),
    .enable(bank_enable[2]),
    .gated_clk(bank_clk2)
);

clock_gating CG3(
    .clk(clk),
    .enable(bank_enable[3]),
    .gated_clk(bank_clk3)
);

banked_rf rf_inst(

    .bank_clk0(bank_clk0),
    .bank_clk1(bank_clk1),
    .bank_clk2(bank_clk2),
    .bank_clk3(bank_clk3),
    .we(we),

    .waddr(waddr),
    .wdata(wdata),

    .raddr1(raddr1),
    .raddr2(raddr2),

    .rdata1(rdata1),
    .rdata2(rdata2)

);

endmodule
