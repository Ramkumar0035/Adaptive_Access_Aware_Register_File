`timescale 1ns/1ps

module tb_access_aware_rf_top;

reg clk;
reg rst;

reg we;

reg read_valid1;
reg read_valid2;

reg [4:0] waddr;
reg [31:0] wdata;

reg [4:0] raddr1;
reg [4:0] raddr2;

wire [31:0] rdata1;
wire [31:0] rdata2;

wire [3:0] bank_access;
wire [3:0] bank_enable;

access_aware_rf_top dut(

    .clk(clk),
    .rst(rst),

    .we(we),

    .waddr(waddr),
    .wdata(wdata),

    .read_valid1(read_valid1),
    .read_valid2(read_valid2),

    .raddr1(raddr1),
    .raddr2(raddr2),

    .rdata1(rdata1),
    .rdata2(rdata2),

    .bank_access(bank_access),
    .bank_enable(bank_enable)

);
//////////////////////////////////////////////////
// GOLDEN REFERENCE MODEL
//////////////////////////////////////////////////

reg [31:0] golden_rf [0:31];

integer i;
integer error_count;
integer main_clk_count;

integer bank0_clk_count;
integer bank1_clk_count;
integer bank2_clk_count;
integer bank3_clk_count;

initial
begin

    error_count = 0;

    main_clk_count  = 0;

    bank0_clk_count = 0;
    bank1_clk_count = 0;
    bank2_clk_count = 0;
    bank3_clk_count = 0;

    for(i=0;i<32;i=i+1)
        golden_rf[i] = 0;
end
always @(posedge clk)
begin
    main_clk_count = main_clk_count + 1;
end

always @(posedge dut.bank_clk0)
begin
    bank0_clk_count = bank0_clk_count + 1;
end

always @(posedge dut.bank_clk1)
begin
    bank1_clk_count = bank1_clk_count + 1;
end

always @(posedge dut.bank_clk2)
begin
    bank2_clk_count = bank2_clk_count + 1;
end

always @(posedge dut.bank_clk3)
begin
    bank3_clk_count = bank3_clk_count + 1;
end

always @(posedge clk)
begin

    if(we && (waddr != 5'd0))
        golden_rf[waddr] <= wdata;

    golden_rf[0] <= 32'd0;

end

always @(posedge clk)
begin

    $display(
    "HITS: B0=%0d B1=%0d B2=%0d B3=%0d",
    dut.bank0_hits,
    dut.bank1_hits,
    dut.bank2_hits,
    dut.bank3_hits
    );

end
always @(posedge clk)
begin

    $display(
    "THRESHOLDS: B0=%0d B1=%0d B2=%0d B3=%0d",
    dut.threshold0,
    dut.threshold1,
    dut.threshold2,
    dut.threshold3
    );

end

//////////////////////////////////////////////////
// CLOCK
//////////////////////////////////////////////////

initial
begin
    clk = 0;
    forever #5 clk = ~clk;
end

//////////////////////////////////////////////////
// MONITOR
//////////////////////////////////////////////////

initial
begin
    $monitor(
        "time=%0t access=%b enable=%b c0=%0d c1=%0d c2=%0d c3=%0d",
        $time,
        bank_access,
        bank_enable,
        dut.monitor.counter0,
        dut.monitor.counter1,
        dut.monitor.counter2,
        dut.monitor.counter3
    );
end

//////////////////////////////////////////////////
// DEBUG PRINT
//////////////////////////////////////////////////

always @(posedge clk)
begin

    if(bank_access != 0)
    begin

        $display(
        "ACCESS=%b ENABLE=%b",
        bank_access,
        bank_enable
        );

    end

end

//////////////////////////////////////////////////
// OVERFLOW CHECKER
//////////////////////////////////////////////////

always @(posedge clk)
begin

    if(dut.monitor.counter0 > 4)
        $fatal("Counter0 Overflow");

    if(dut.monitor.counter1 > 4)
        $fatal("Counter1 Overflow");

    if(dut.monitor.counter2 > 4)
        $fatal("Counter2 Overflow");

    if(dut.monitor.counter3 > 4)
        $fatal("Counter3 Overflow");

end


//////////////////////////////////////////////////
// BANK ACCESS CHECKER
//////////////////////////////////////////////////

reg [3:0] expected_access;

always @(*)
begin

    expected_access = 4'b0000;

    if(read_valid1 && (raddr1 != 0))
        expected_access[raddr1[4:3]] = 1'b1;

    if(read_valid2 && (raddr2 != 0))
        expected_access[raddr2[4:3]] = 1'b1;

    if(we && (waddr != 0))
        expected_access[waddr[4:3]] = 1'b1;

end

always @(*)
begin

    if(^bank_access === 1'bx)
    begin
        // Ignore startup unknowns
    end

    else if(bank_access !== expected_access)
    begin

        $display("BANK ACCESS ERROR exp=%b got=%b",
                 expected_access,
                 bank_access);

        error_count = error_count + 1;

    end

end

//////////////////////////////////////////////////
// TEST SEQUENCE
//////////////////////////////////////////////////

initial
begin

    rst = 1;

    we = 0;

    read_valid1 = 0;
    read_valid2 = 0;

    waddr = 0;
    wdata = 0;

    raddr1 = 0;
    raddr2 = 0;

    #10;
    rst = 0;

    //////////////////////////////////////////////////
    // INITIAL DATA WRITES
    //////////////////////////////////////////////////

    we = 1;

    waddr = 5'd3;
    wdata = 32'd10;
    #10;

    waddr = 5'd10;
    wdata = 32'd20;
    #10;

    waddr = 5'd18;
    wdata = 32'd30;
    #10;

    waddr = 5'd29;
    wdata = 32'd40;
    #10;

    we = 0;

   

    //////////////////////////////////////////////////
    // CASE2
    //////////////////////////////////////////////////

    $display("CASE2");

    read_valid1 = 1;
    read_valid2 = 1;

    raddr1 = 5'd10;
    raddr2 = 5'd29;

    #10;

    read_valid1 = 0;
    read_valid2 = 0;

    #50;

    //////////////////////////////////////////////////
    // CASE3
    //////////////////////////////////////////////////

    $display("CASE3");

    read_valid1 = 1;
    read_valid2 = 1;

    raddr1 = 5'd3;
    raddr2 = 5'd18;

    #10;

    read_valid1 = 0;
    read_valid2 = 0;

    #50;

    

    //////////////////////////////////////////////////
    // CASE5 CONTINUOUS ACCESS
    //////////////////////////////////////////////////

    $display("CASE5");

    repeat(5)
    begin
        read_valid1 = 1;
        read_valid2 = 1;

        raddr1 = 5'd10;
        raddr2 = 5'd29;

        #10;
    end

    read_valid1 = 0;
    read_valid2 = 0;

    #50;

   

    //////////////////////////////////////////////////
    // CASE7 SAME BANK
    //////////////////////////////////////////////////

    $display("CASE7 SAME BANK");

    read_valid1 = 1;
    read_valid2 = 1;

    raddr1 = 5'd8;
    raddr2 = 5'd10;

    #10;

    read_valid1 = 0;
    read_valid2 = 0;

    #50;

    //////////////////////////////////////////////////
    // CASE8 WRITE ONLY
    //////////////////////////////////////////////////

    $display("CASE8 WRITE ONLY");

    we = 1;

    waddr = 5'd29;
    wdata = 32'd55;

    #10;

    we = 0;

    #50;

  

    //////////////////////////////////////////////////
    // CASE11 X0 TEST
    //////////////////////////////////////////////////

    $display("CASE11 X0 TEST");

    we = 1;
    waddr = 5'd0;
    wdata = 32'd999;

    #10;

    we = 0;

    read_valid1 = 1;
    raddr1 = 5'd0;

    #10;

    $display("X0 = %0d", rdata1);

    read_valid1 = 0;

    #50;

    //////////////////////////////////////////////////
    // CASE12 COUNTER RELOAD
    //////////////////////////////////////////////////

    $display("CASE12 COUNTER RELOAD");

    read_valid1 = 1;
    raddr1 = 5'd18;

    #10;

    read_valid1 = 0;

    #30;

    read_valid1 = 1;
    raddr1 = 5'd18;

    #10;

    read_valid1 = 0;

    #50;

    

    //////////////////////////////////////////////////
    // CASE14 READ AFTER WRITE
    //////////////////////////////////////////////////

    $display("CASE14 READ AFTER WRITE");

    read_valid2 = 1;
    raddr2 = 5'd29;

    #10;

    $display("R29 = %0d", rdata2);

    read_valid2 = 0;

    #20;

    //////////////////////////////////////////////////
    // CASE15 ALL BANKS ACTIVE
    //////////////////////////////////////////////////

    $display("CASE15 ALL BANKS ACTIVE");

    we = 1;
    waddr = 5'd29;

    read_valid1 = 1;
    raddr1 = 5'd10;

    read_valid2 = 1;
    raddr2 = 5'd18;

    #10;

    we = 0;
    read_valid1 = 0;
    read_valid2 = 0;

    #50;

//////////////////////////////////////////////////
// CASE16 READ + WRITE SAME REGISTER
//////////////////////////////////////////////////

$display("CASE16 READ WRITE SAME REGISTER");

we = 1;
waddr = 5'd18;
wdata = 32'd100;

read_valid1 = 1;
raddr1 = 5'd18;

#10;

we = 0;
read_valid1 = 0;

#10;

$display("R18 AFTER WRITE = %0d", rdata1);

#50;
//////////////////////////////////////////////////
// CASE17 MULTI BANK ACCESS
//////////////////////////////////////////////////

$display("CASE17 MULTI BANK ACCESS");

we = 1;
waddr = 5'd29;     // Bank3

read_valid1 = 1;
raddr1 = 5'd3;     // Bank0

read_valid2 = 1;
raddr2 = 5'd18;    // Bank2

#10;

we = 0;
read_valid1 = 0;
read_valid2 = 0;

#50;



    //////////////////////////////////////////////////
    // FINAL DATA CHECK
    //////////////////////////////////////////////////

    raddr1 = 5'd18;
    raddr2 = 5'd3;

    #10;

    $display("R18 = %0d", rdata1);
    $display("R3  = %0d", rdata2);

    $display("====================================");
$display("TOTAL ERRORS = %0d", error_count);
$display("====================================");

if(error_count == 0)
    $display("TEST PASSED");
else
    $display("TEST FAILED");

$display(" ");
$display("CLOCK STATISTICS");
$display("----------------------------");

$display("MAIN CLOCK  = %0d", main_clk_count);

$display("BANK0 CLOCK = %0d", bank0_clk_count);
$display("BANK1 CLOCK = %0d", bank1_clk_count);
$display("BANK2 CLOCK = %0d", bank2_clk_count);
$display("BANK3 CLOCK = %0d", bank3_clk_count);

    #20;
    $finish;

end

endmodule
