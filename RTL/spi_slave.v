`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2025 06:51:51 PM
// Design Name: 
// Module Name: spislavefsm
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


module spislavefsm(sclk, mosi, cs, rcvd_p_dat, tx_done);
    input sclk, mosi, cs;
    output [7:0]rcvd_p_dat;
    output reg tx_done;
    
    parameter IDLE = 0, SAMPLE = 1;
    reg state;
    reg [3:0]count =0;
    reg [7:0]mosi_p_dat =0;
    //Sampling at negedge of the sclk
    always @(negedge sclk)begin
        case(state)
            IDLE : begin
                tx_done <= 1'b0;
                if (cs == 1'b0)
                    state <= SAMPLE;
                else
                    state <= IDLE;
            end
            SAMPLE : begin
                if(count < 8)begin
                    count <= count + 1;
                    mosi_p_dat <= {mosi_p_dat[6:0], mosi};
                    state <= SAMPLE;
                end
                else begin
                    count <= 0;
                    state <= IDLE;
                    tx_done <= 1'b1;
                end
            end
            default: state <= IDLE;
        endcase
    end
    
    assign rcvd_p_dat = mosi_p_dat;
    
endmodule
