module bank_access_generator(

    input [4:0] raddr1,
    input [4:0] raddr2,
    input [4:0] waddr,

    input [1:0] r_bank1,
    input [1:0] r_bank2,
    input [1:0] w_bank,

    input read_valid1,
    input read_valid2,
    input write_valid,

    output reg [3:0] bank_access

);

always @(*)
begin

    bank_access = 4'b0000;

    //--------------------------------
    // Read Port 1
    //--------------------------------
    if(read_valid1 && (raddr1 != 5'd0))
        bank_access[r_bank1] = 1'b1;

    //--------------------------------
    // Read Port 2
    //--------------------------------
    if(read_valid2 && (raddr2 != 5'd0))
        bank_access[r_bank2] = 1'b1;

    //--------------------------------
    // Write Port
    //--------------------------------
    if(write_valid && (waddr != 5'd0))
        bank_access[w_bank] = 1'b1;

end

endmodule