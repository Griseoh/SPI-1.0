`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2025 03:37:06 PM
// Design Name: 
// Module Name: spimasterfsm
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module spimasterfsm(clk, rst, p_dat, tx_en, mosi, cs, sclk);
    input clk, rst, tx_en;
    input [7:0]p_dat;
    output reg mosi, cs;
    output sclk;
    
    parameter IDLE = 0, START = 1, TX_DAT = 2, TX_END = 3;
    reg [1:0] curr_state, next_state;
    reg spi_sclk= 0;
    reg [2:0]count = 0;
    reg [3:0]bit_cnt = 0;
    //Serial Clock Generation
    always @(posedge clk)begin
        case(next_state)
            IDLE : begin
                spi_sclk <= 0;
            end
            START : begin
                if(count < 3'b011 || count == 3'b111)
                    spi_sclk <= 1'b1;
                else
                    spi_sclk <= 1'b0;
            end
            TX_DAT : begin
                if(count < 3'b011 || count == 3'b111)
                    spi_sclk <= 1'b1;
                else
                    spi_sclk <= 1'b0;
            end
            TX_END : begin
                if(count < 3'b011)
                    spi_sclk <= 1'b1;
                else
                    spi_sclk <= 1'b0;
            end
            default : begin
                spi_sclk <= 1'b0;
            end
        endcase
    end
    //Reset Handler
    always @(posedge clk)begin  
        if(rst)
            curr_state <= IDLE;
        else
            curr_state <= next_state;
    end
    //Next State Logic
    always @(*)begin
        case(curr_state)
            IDLE:begin
                mosi = 1'b0;
                cs = 1'b1;
                if(tx_en)
                    next_state = START;
                else
                    next_state = IDLE;
            end
            START:begin
                cs = 1'b0;
                if(count == 3'b111)                     //1 clock pulse for transaction start
                    next_state = TX_DAT;
                else 
                    next_state = START;
            end
            TX_DAT:begin
                mosi = p_dat[7 - bit_cnt];
                if(bit_cnt != 8)
                    next_state = TX_DAT;
                else begin
                    next_state = TX_END;
                    mosi = 1'b0;
                end
            end
            TX_END:begin
                cs = 1'b1;
                mosi = 1'b0;
                if(count == 3'b111)                     //1 clock pulse for transaction end
                    next_state = IDLE;
                else
                    next_state = TX_END;
            end
            default:begin
                next_state = IDLE;
            end
        endcase
    end
    //Counter Update Logic
    always @(posedge clk)begin
        case(curr_state)
            IDLE:begin
                count <= 0;
                bit_cnt <= 0;
            end
            START:begin
                count <= count + 1;
            end
            TX_DAT:begin
                if(bit_cnt != 8)begin
                    if(count < 3'b111)begin
                        count <= count + 1;
                    end
                    else begin
                        count <= 0;
                        bit_cnt <= bit_cnt + 1;
                    end
                end
            end
            TX_END:begin
                count <= count + 1;
                bit_cnt <= 0;
            end
            default:begin
                count <= 0;
                bit_cnt <= 0;
            end
        endcase     
    end
    
    assign sclk = spi_sclk;
    
endmodule
