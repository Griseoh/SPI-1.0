`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2025 08:30:23 PM
// Design Name: 
// Module Name: spitop
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


module spitop(clk, rst, p_dat, tx_en, rcvd_p_dat, tx_done);
    input clk, rst, tx_en;
    input [7:0]p_dat;
    output tx_done;
    output [7:0]rcvd_p_dat;
    
    wire sclk, mosi, ss;
    
    spimasterfsm spim(clk, rst, p_dat, tx_en, mosi, ss, sclk);
    spislavefsm spis(sclk, mosi, ss, rcvd_p_dat, tx_done);
     
endmodule
