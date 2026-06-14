module multiplexer //2 to 1 multiplexer
(
    input i_Clk,
    input i_Switch_1, //select
    input i_Switch_2, //i_Data_1
    input i_Switch_3, //i_Data_2
    output o_Led_1
);


reg r_SelectState = 1'b0;
reg r_Switch_1 = 1'b0;

reg r_LED = 1'b0;


always @(posedge i_Clk)
begin

    if(r_SelectState == 1'b0 && i_Switch_1 == 1'b1)
    begin
        r_SelectState <= 1'b1;
    end
    else if(r_SelectState == 1'b1 && i_Switch_1 == 1'b1)
    begin
        r_SelectState <= ~r_SelectState;
    end


    if(r_SelectState == 1'b0)
    begin
        r_LED <= i_Switch_2;
    end
    else if(r_SelectState == 1'b1)
    begin
        r_LED <= i_Switch_3;
    end

end

assign o_Led_1 = r_LED;

endmodule
