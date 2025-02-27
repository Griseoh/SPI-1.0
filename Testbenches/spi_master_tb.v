`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2025 05:04:51 PM
// Design Name: 
// Module Name: spimasterfsm_tb
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


module spimasterfsm_tb;
    reg clk, rst, tx_en;
    wire mosi, ss, sclk;
    reg [7:0]p_dat;
    
    spimasterfsm uut(clk, rst, p_dat, tx_en, mosi, ss, sclk);
    
    initial begin
        clk = 0;
        rst = 0;
        tx_en = 0;
        p_dat = 8'b01010101;
    end
    initial begin
        forever begin
            #5 clk = ~clk;
        end
    end
    initial begin 
        rst = 1;
        repeat(5)@(posedge clk); 
        rst = 0;
    end
    initial begin
        repeat(5)@(posedge clk);
        tx_en = 1;
    end
endmodule
