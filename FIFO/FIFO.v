module FIFO #(parameter WIDTH = 8, DEPTH = 4)
(
    input i_Wr_Clk,
    input i_Wr_Dv,
    input [$clog2(WIDTH) - 1: 0] i_Wr_Data,

    input i_Rd_Clk,
    input i_Rd_Dv,


    output [$clog2(WIDTH) - 1: 0] o_Rd_Data,
    output o_AF_Flag,
    output o_AE_Flag,//implement ae and af later
    output o_Full_Flag,
    output o_Empty_Flag,
    output o_queuePos
);

reg [WIDTH - 1:0] datablock[DEPTH - 1:0]; //width of 8 bits and depth of 4 addresses , maybe this'll synthesize into a bunch of flipflops?
reg [DEPTH - 1: 0] queuePos = DEPTH - 1;


always @(posedge i_Wr_Clk)
begin

    if(queuePos == 0)
    begin
        o_Full_Flag <= 1'b1;
    end

    if(i_Wr_Dv && o_Full_Flag != 1'b1) //if the data is valid 
    begin
        datablock[queuePos] <= i_Wr_Data; //put data at current address
        queuePos <= queuePos - 1;
    end

end

always @(posedge i_Rd_Clk)
begin

    if(queuePos == (DEPTH - 1))
    begin
        o_Empty_Flag <= 1'b1;
    end

    if(i_Rd_Dv && o_Empty_Flag != 1'b1)
    begin
        i_Rd_Data <= datablock[queuePos];
        datablock[queuePos] <= 1'b0;
        queuePos <= queuePos + 1;
    end

end

assign o_queuePos = queuePos;

endmodule
