`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2025 08:49:19 PM
// Design Name: 
// Module Name: spitop_tb
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


module spitop_tb;
    reg clk, rst, tx_en;
    reg [7:0]p_dat;
    wire tx_done;
    wire [7:0]rcvd_p_dat;
    
    spitop dut(clk, rst, p_dat, tx_en, rcvd_p_dat, tx_done);
    
    initial begin
        clk = 0;
        rst = 0;
        tx_en = 0;
        p_dat = 8'b01101001;
        forever begin
            #5 clk = ~clk;
        end
    end
    
    initial begin
        #50 rst = 1;
        repeat(5)@(posedge clk);
        rst = 0;
    end
    
    initial begin
        repeat(5)@(posedge clk);
        tx_en = 1;
    end
endmodule
