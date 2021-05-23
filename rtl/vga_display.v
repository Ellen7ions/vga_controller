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

    wire        displaying;
    wire [9:0]  x, y;
    wire        pixel_clk;

    vga_sync sync(
        .clk(clk),
        .rst(~rstn),
        .hsync(hsync),
        .vsync(vsync),
        .displaying(displaying),
        .x(x),
        .y(y),
        .pixel_clk(pixel_clk)
    );
    reg     [11:0] rgb_reg;
    wire    [11:0] rgb_next;

    reg     [18:0] pixel_cnt;
    wire    [18:0] pixel_cnt_next;
    wire    [31:0] one_pixel;

    // always @(posedge clk) begin
    //     if (~rstn) begin
    //         rgb_reg     <= 12'h000;
    //         pixel_cnt   <= 9'h000;
    //     end
    // end

    always @(posedge pixel_clk, negedge rstn) begin
        if (rstn == 1'b0) begin
            pixel_cnt   <= 19'hfffff; 
        end else begin
            pixel_cnt   <= pixel_cnt_next;
        end
    end

    img_buffer buffer(
        .clka(pixel_clk),       // input wire clka
        .ena(1'b1),             // input wire ena
        .wea(4'b0000),          // input wire [3 : 0] wea
        .addra(pixel_cnt), // input wire [17 : 0] addra
        .dina(32'h0000_0000),   // input wire [31 : 0] dina
        .douta(one_pixel)       // output wire [31 : 0] douta
    );

    localparam WIDTH        = 524;
    localparam HEIGHT       = 416;
    localparam TOTALSIZE    = 217984;

    wire           on_img;
    // 524x416
    assign on_img = (x >= 100 && x <= (100 + WIDTH - 1) && y >= 100 && y <= (100 + HEIGHT - 1));

    always @(posedge clk, negedge rstn)
        if (rstn == 1'b0)
            rgb_reg <= 12'h000;
        else
            rgb_reg <= rgb_next;
    
    // output
    assign rgb = (displaying) ? rgb_reg : 12'h000;

    assign rgb_next[11:8]   = on_img ? one_pixel[31:28] : 4'h0;
    assign rgb_next[7 :4]   = on_img ? one_pixel[23:20] : 4'h0;
    assign rgb_next[3 :0]   = on_img ? one_pixel[15:12] : 4'h0;
    assign pixel_cnt_next   = ~rstn ? 19'h00000 : on_img ? ((pixel_cnt == TOTALSIZE - 1) ? 19'h00000 : pixel_cnt + 19'h1) : pixel_cnt;

    // assign rgb              = ~rstn ? 0 : 12'hc2a;
endmodule
