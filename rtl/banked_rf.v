module banked_rf(

    input bank_clk0,
    input bank_clk1,
    input bank_clk2,
    input bank_clk3,

    input we,

    input [4:0] waddr,
    input [31:0] wdata,

    input [4:0] raddr1,
    input [4:0] raddr2,

    output reg [31:0] rdata1,
    output reg [31:0] rdata2

);

////////////////////////////////////////////////////
// 4 Memory Banks
////////////////////////////////////////////////////

reg [31:0] bank0 [0:7];
reg [31:0] bank1 [0:7];
reg [31:0] bank2 [0:7];
reg [31:0] bank3 [0:7];

integer i;

initial
begin
    for(i=0;i<8;i=i+1)
    begin
        bank0[i] = 32'd0;
        bank1[i] = 32'd0;
        bank2[i] = 32'd0;
        bank3[i] = 32'd0;
    end
end

////////////////////////////////////////////////////
// Address Decode
////////////////////////////////////////////////////

wire [1:0] w_bank;
wire [2:0] w_reg;

wire [1:0] r_bank1;
wire [2:0] r_reg1;

wire [1:0] r_bank2;
wire [2:0] r_reg2;

assign w_bank  = waddr[4:3];
assign w_reg   = waddr[2:0];

assign r_bank1 = raddr1[4:3];
assign r_reg1  = raddr1[2:0];

assign r_bank2 = raddr2[4:3];
assign r_reg2  = raddr2[2:0];

////////////////////////////////////////////////////
// Bank0 Write
////////////////////////////////////////////////////

always @(posedge bank_clk0)
begin
    if(we && (waddr != 5'd0) && (w_bank == 2'b00))
        bank0[w_reg] <= wdata;
end

////////////////////////////////////////////////////
// Bank1 Write
////////////////////////////////////////////////////

always @(posedge bank_clk1)
begin
    if(we && (waddr != 5'd0) && (w_bank == 2'b01))
        bank1[w_reg] <= wdata;
end

////////////////////////////////////////////////////
// Bank2 Write
////////////////////////////////////////////////////

always @(posedge bank_clk2)
begin
    if(we && (waddr != 5'd0) && (w_bank == 2'b10))
        bank2[w_reg] <= wdata;
end

////////////////////////////////////////////////////
// Bank3 Write
////////////////////////////////////////////////////

always @(posedge bank_clk3)
begin
    if(we && (waddr != 5'd0) && (w_bank == 2'b11))
        bank3[w_reg] <= wdata;
end

////////////////////////////////////////////////////
// Read Port 1
////////////////////////////////////////////////////

always @(*)
begin

    if(raddr1 == 5'd0)
        rdata1 = 32'd0;

    else
    begin

        case(r_bank1)

            2'b00: rdata1 = bank0[r_reg1];
            2'b01: rdata1 = bank1[r_reg1];
            2'b10: rdata1 = bank2[r_reg1];
            2'b11: rdata1 = bank3[r_reg1];

            default: rdata1 = 32'd0;

        endcase

    end

end

////////////////////////////////////////////////////
// Read Port 2
////////////////////////////////////////////////////

always @(*)
begin

    if(raddr2 == 5'd0)
        rdata2 = 32'd0;

    else
    begin

        case(r_bank2)

            2'b00: rdata2 = bank0[r_reg2];
            2'b01: rdata2 = bank1[r_reg2];
            2'b10: rdata2 = bank2[r_reg2];
            2'b11: rdata2 = bank3[r_reg2];

            default: rdata2 = 32'd0;

        endcase

    end

end

endmodule