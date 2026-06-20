module LED
(
    input [3:0] i_QueuePos,
    output o_LED_1,
    output o_LED_2,
    output o_LED_3,
    output o_LED_4
);

// Display queue position as binary on LEDs (LEDs represent the queue position value)
assign o_LED_1 = i_QueuePos[0];
assign o_LED_2 = i_QueuePos[1];
assign o_LED_3 = i_QueuePos[2];
assign o_LED_4 = i_QueuePos[3];

endmodule
