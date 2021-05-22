`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/22 18:38:17
// Design Name: 
// Module Name: vga_top
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


module vga_display(
    // input clk is 100MHz
    input   wire        clk,
    input   wire        rstn,
    output  wire        hsync,
    output  wire        vsync,
    output  wire [11:0] rgb
    );

    reg [31:0] buffer [8:0];

    wire        displaying;
    wire [9:0]  x, y;

    vga_sync sync(
        .clk(clk),
        .rst(~rstn),
        .hsync(hsync),
        .vsync(vsync),
        .displaying(displaying),
        .x(x),
        .y(y)
    );
    reg [11:0] rgb_reg;
    wire [11:0] rgb_next;
    always @(posedge clk) begin
        if (~rstn) begin
            rgb_reg <= 12'h000;
        end else begin
            rgb_reg <= rgb_next;
        end
    end

    assign rgb_next = 12'hf0f;
    assign rgb      = displaying ? rgb_reg : 12'h000;

endmodule
