`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/22 18:41:05
// Design Name: 
// Module Name: vga_sync
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


module vga_sync(
    input   wire        clk,
    input   wire        rst,
    output  reg         hsync,
    output  reg         vsync,
    output  wire        displaying,
    output  wire [9:0]  x,
    output  wire [9:0]  y
    );

    // Horizontal Timing (line)
    localparam H_DISPLAY        = 640;
    localparam H_FRONT_PORCH    = 16;
    localparam H_SYNC_PULSE     = 96;
    localparam H_BACK_PORCH     = 48;
    localparam H_SYNC_START     = H_DISPLAY + H_FRONT_PORCH;
    localparam H_SYNC_END       = H_DISPLAY + H_FRONT_PORCH + H_SYNC_PULSE - 1;
    localparam H_WHOLE_LINE     = H_DISPLAY + H_FRONT_PORCH + H_SYNC_PULSE + H_BACK_PORCH - 1;

    // Vertical Timing (frame)
    localparam V_DISPLAY        = 480;
    localparam V_FRONT_PORCH    = 10;
    localparam V_SYNC_PULSE     = 2;
    localparam V_BACK_PORCH     = 33;
    localparam V_SYNC_START     = V_DISPLAY + V_BACK_PORCH;
    localparam V_SYNC_END       = V_DISPLAY + V_BACK_PORCH + V_SYNC_PULSE - 1;
    localparam V_WHOLE_LINE     = V_DISPLAY + V_FRONT_PORCH + V_SYNC_PULSE + V_BACK_PORCH - 1;

        // pll 25MHz
    wire        clk_25MHz;
    reg  [1:0]  clk_count;
    wire [1:0]  clk_count_next;

    always @(posedge clk) begin
        if (rst) begin
            clk_count <= 1'b0;
        end else begin
            clk_count <= clk_count_next;
        end
    end

    assign clk_count_next = clk_count + 1;

    assign clk_25MHz = (clk_count == 2'b00);

    reg     [9:0]   h_count, v_count;
    wire    [9:0]   h_count_next, v_count_next;
    wire            hsync_next, vsync_next;

    always @(posedge clk) begin
        if (rst) begin
            h_count <= 10'h000;
            v_count <= 10'h000;
            hsync   <= 1'b0;
            vsync   <= 1'b0;
        end else begin
            h_count <= h_count_next;
            v_count <= v_count_next;
            hsync   <= hsync_next;
            vsync   <= vsync_next;
        end
    end

    assign h_count_next = (clk_25MHz) ? (h_count == H_WHOLE_LINE) ? 10'h000 : h_count + 10'h1 : h_count;
    assign v_count_next = (clk_25MHz && h_count == H_WHOLE_LINE) ? (v_count == V_WHOLE_LINE) ? 10'h000 : v_count + 10'h1 : v_count;

    // low active
    assign hsync_next   = (h_count >= H_SYNC_START) && (h_count <= H_SYNC_END);
    assign vsync_next   = (v_count >= V_SYNC_START) && (v_count <= V_SYNC_END);

    assign x            = h_count;
    assign y            = v_count;
    assign displaying   = (h_count < H_DISPLAY) && (v_count < V_DISPLAY);

endmodule
