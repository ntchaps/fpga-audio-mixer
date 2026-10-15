`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Nicholas Chapman
// 
// Create Date: 10/15/2026 03:58:08 PM
// Design Name: 
// Module Name: tb_mixer_2ch
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

`timescale 1ns / 1ps

module tb_mixer_2ch;

    localparam logic signed [15:0] GAIN_ZERO  = 16'sd0;
    localparam logic signed [15:0] GAIN_HALF  = 16'sh2000; // 0.5
    localparam logic signed [15:0] GAIN_UNITY = 16'sh4000; // 1.0
    localparam logic signed [15:0] GAIN_1P5   = 16'sh6000; // 1.5

    logic signed [15:0] in_a_l;
    logic signed [15:0] in_a_r;
    logic signed [15:0] in_b_l;
    logic signed [15:0] in_b_r;

    logic signed [15:0] gain_a;
    logic signed [15:0] gain_b;

    logic signed [15:0] out_l;
    logic signed [15:0] out_r;

    mixer_2ch dut (
        .in_a_l(in_a_l),
        .in_a_r(in_a_r),
        .in_b_l(in_b_l),
        .in_b_r(in_b_r),
        .gain_a(gain_a),
        .gain_b(gain_b),
        .out_l(out_l),
        .out_r(out_r)
    );

    task automatic check_case(
        input string case_name,

        input logic signed [15:0] next_a_l,
        input logic signed [15:0] next_a_r,
        input logic signed [15:0] next_b_l,
        input logic signed [15:0] next_b_r,

        input logic signed [15:0] next_gain_a,
        input logic signed [15:0] next_gain_b,

        input logic signed [15:0] expected_l,
        input logic signed [15:0] expected_r
    );
        begin
            in_a_l = next_a_l;
            in_a_r = next_a_r;
            in_b_l = next_b_l;
            in_b_r = next_b_r;
            gain_a = next_gain_a;
            gain_b = next_gain_b;

            #1;

            if ((out_l !== expected_l) || (out_r !== expected_r)) begin
                $error("FAIL: %s", case_name);
                $error("Expected L=%0d R=%0d, got L=%0d R=%0d",
                       expected_l, expected_r, out_l, out_r);
                $fatal(1);
            end

            $display("PASS: %s", case_name);
        end
    endtask

    initial begin
        check_case(
            "source A at unity gain",
            16'sd12345, -16'sd12345,
            16'sd2000,   16'sd2000,
            GAIN_UNITY, GAIN_ZERO,
            16'sd12345, -16'sd12345
        );

        check_case(
            "half gain A plus unity gain B",
            16'sd12000, -16'sd12000,
            16'sd2000,   16'sd8000,
            GAIN_HALF, GAIN_UNITY,
            16'sd8000,   16'sd2000
        );

        check_case(
            "positive saturation",
            16'sd30000, 16'sd25000,
            16'sd30000, 16'sd25000,
            GAIN_UNITY, GAIN_UNITY,
            16'sh7fff, 16'sh7fff
        );

        check_case(
            "negative saturation",
            -16'sd30000, -16'sd25000,
            -16'sd30000, -16'sd25000,
            GAIN_UNITY, GAIN_UNITY,
            16'sh8000, 16'sh8000
        );

        check_case(
            "gain above unity without clipping",
            16'sd20000, -16'sd20000,
            16'sd0,     16'sd0,
            GAIN_1P5, GAIN_ZERO,
            16'sd30000, -16'sd30000
        );

        $display("All mixer tests passed.");
        $finish;
    end

endmodule
