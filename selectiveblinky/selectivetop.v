module selectivetop
(
    input i_Clk,
    input i_Switch_1,
    input i_Switch_2,
    output o_LED_1,
    output o_LED_2,
    output o_LED_3,
    output o_LED_4,
);

//we're instantiating 1 to 4 demux and a LSFR 

reg r_LFSR_Toggle = 1'b0;
wire w_LFSR_done;

LFSR_22 LFSR_Inst
(
    .i_Clk(i_Clk),
    .o_LFSR_Data(),
    .o_LFSR_Done(w_LFSR_done)
);

always @(posedge i_Clk)
begin
    if(w_LFSR_done)
        r_LFSR_Toggle <= !r_LFSR_Toggle;
end

Demux_1_To_4 Demux_Inst
(
    .i_Data(r_LFSR_Toggle),
    .i_Sel0(i_Switch_1),
    .i_Sel1(i_Switch_2),
    .o_Data0(o_LED_1),
    .o_Data1(o_LED_2),
    .o_Data2(o_LED_3),
    .o_Data3(o_LED_4)
);



endmodule
