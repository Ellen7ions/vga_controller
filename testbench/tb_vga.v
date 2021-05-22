`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/22 19:32:52
// Design Name: 
// Module Name: tb_vga
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


module tb_vga();
    reg clk, rstn;
    wire hsync, vsync;
    wire [11:0] rgb;

    vga_display vga(
        .clk(clk),
        .rstn(rstn),
        .hsync(hsync),
        .vsync(vsync),
        .rgb(rgb)
    );

    initial begin
        clk = 1'b1;
        forever begin
            #5 clk = ~clk;
        end
    end

    initial begin
        rstn        = 1'b0;
        #100 rstn   = 1'b1;
    end

endmodule
