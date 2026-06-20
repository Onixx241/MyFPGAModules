module ProjectTop
(
    input i_Clk,
    input i_Switch_1,
    input i_Switch_2,
    output o_LED_1,
    output o_LED_2,
    output o_LED_3,
    output o_LED_4
);

wire w_FIFO_Write;
wire w_FIFO_Read;

wire [3:0] w_QueuePos;

//button switch to represent wrDV and rd DV

FIFO #(.WIDTH = 8, .DEPTH = 4) FIFO_INST
(
    .i_Wr_Clk(i_Clk),
    .i_Wr_Dv(w_FIFO_Write), 
    .i_Wr_Data(255), //keep writing 255 to each address

    .i_Rd_Clk(i_Clk),
    .i_Rd_Dv(w_FIFO_Read),
    .o_queuePos(w_QueuePos)
    
);


LED LED_INST
(
    .i_QueuePos(w_QueuePos),
    .o_LED_1(o_LED_1),
    .o_LED_2(o_LED_2),
    .o_LED_3(o_LED_3),
    .o_LED_4(o_LED_4)
    
);

assign w_FIFO_Write = i_Switch_1;
assign w_FIFO_Read = i_Switch_2;


endmodule
