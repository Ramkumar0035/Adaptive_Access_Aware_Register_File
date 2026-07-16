module access_monitor_v2(

    input clk,
    input rst,

    input [3:0] bank_access,

    output [3:0] bank_enable

);

parameter integer THRESHOLD = 4;

reg [3:0] counter0;
reg [3:0] counter1;
reg [3:0] counter2;
reg [3:0] counter3;
reg [31:0] bank0_hits;
reg [31:0] bank1_hits;
reg [31:0] bank2_hits;
reg [31:0] bank3_hits;
always @(posedge clk or posedge rst)
begin

    if(rst)
begin

    counter0 <= 0;
    counter1 <= 0;
    counter2 <= 0;
    counter3 <= 0;

    bank0_hits <= 0;
    bank1_hits <= 0;
    bank2_hits <= 0;
    bank3_hits <= 0;

end

    else
    begin

        if(bank_access[0])
            counter0 <= THRESHOLD;
        else if(counter0 > 0)
            counter0 <= counter0 - 1;

        if(bank_access[1])
            counter1 <= THRESHOLD;
        else if(counter1 > 0)
            counter1 <= counter1 - 1;

        if(bank_access[2])
            counter2 <= THRESHOLD;
        else if(counter2 > 0)
            counter2 <= counter2 - 1;

        if(bank_access[3])
            counter3 <= THRESHOLD;
        else if(counter3 > 0)
            counter3 <= counter3 - 1;

    end
if(bank_access[0])
    bank0_hits <= bank0_hits + 1;

if(bank_access[1])
    bank1_hits <= bank1_hits + 1;

if(bank_access[2])
    bank2_hits <= bank2_hits + 1;

if(bank_access[3])
    bank3_hits <= bank3_hits + 1;

end

assign bank_enable[0] = (counter0 != 0);
assign bank_enable[1] = (counter1 != 0);
assign bank_enable[2] = (counter2 != 0);
assign bank_enable[3] = (counter3 != 0);


//--------------------------------------------------
// Assertions
//--------------------------------------------------

always @(posedge clk)
begin

    if(counter0 > THRESHOLD)
        $error("Counter0 Overflow");

    if(counter1 > THRESHOLD)
        $error("Counter1 Overflow");

    if(counter2 > THRESHOLD)
        $error("Counter2 Overflow");

    if(counter3 > THRESHOLD)
        $error("Counter3 Overflow");

end

endmodule
