module RX #(parameter CLKS_PER_BIT = 217 )
(
    input i_Clk,

    input i_UART_RX,

    output reg [31:0] o_TX_Data,
    output reg o_BytesReceived // 4 bytes received
);

reg [2:0] r_ByteCounter = 0;
reg [$clog2(32): 0] r_BitCounter = 0;
reg [$clog2(217):0] r_ClkCounter = 0;

reg r_RX_FF1 = 1'b1;
reg r_RX_Cleaned_Bit = 1'b1;

localparam AWAITING = 0;
localparam BEGIN = 1;
localparam RECEIVING = 2;
localparam STOPPING = 3;

reg[2:0] STATE = 0;

always @(posedge i_Clk)
begin
    
    r_RX_FF1 <= i_UART_RX;
    r_RX_Cleaned_Bit <= r_RX_FF1;

    case (STATE)
        AWAITING:
        begin
            
            r_ClkCounter <= 0;
            r_BitCounter <= 0;

            if(r_ByteCounter == 4)
            begin

                r_ByteCounter <= 0;
                
                o_BytesReceived <= 1'b1;
                
            end
            else
            begin
                o_BytesReceived <= 1'b0;
            end

            if(r_RX_Cleaned_Bit == 1'b0)
            begin
                STATE <= BEGIN;
            end

        end 

        BEGIN:
        begin

            if(r_ClkCounter == CLKS_PER_BIT / 2)
            begin
                if(r_RX_Cleaned_Bit == 1'b0)
                    STATE <= RECEIVING;

                r_ClkCounter <= 0;
            end
            else
                r_ClkCounter <= r_ClkCounter + 1;

        end

        RECEIVING:
        begin

            if(r_ClkCounter == CLKS_PER_BIT)
            begin

                o_TX_Data[(r_ByteCounter * 8) + r_BitCounter] <= r_RX_Cleaned_Bit;
                
                if(r_BitCounter == 7)
                begin
                    r_ByteCounter <= r_ByteCounter + 1;
                    STATE <= STOPPING;
                end
                else
                begin
                    r_BitCounter <= r_BitCounter + 1;
                end

                r_ClkCounter <= 0;

            end
            else
                r_ClkCounter <= r_ClkCounter + 1;
        
        end

        STOPPING:
        begin

            if(r_ClkCounter == CLKS_PER_BIT)
            begin

                if(r_RX_Cleaned_Bit == 1'b1)
                    STATE <= AWAITING;
                
            end
            else
                r_ClkCounter <= r_ClkCounter + 1;
        
        end

        default: 
            STATE <= AWAITING;


    endcase

end


endmodule
