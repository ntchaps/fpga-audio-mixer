`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Nicholas Chapman
// 
// Create Date: 10/15/2026 03:58:08 PM
// Design Name: 
// Module Name: mixer_2ch.sv
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

module mixer_2ch #(
    parameter int GAIN_FRAC_BITS = 14   // compile-time constant, binary fractional places per gain
) ( 
    input  logic signed [15:0] in_a_l,      // input A left
    input  logic signed [15:0] in_a_r,      // input A right

    input  logic signed [15:0] in_b_l,      // input B left 
    input  logic signed [15:0] in_b_r,      // input B right

    input  logic signed [15:0] gain_a,      // gain A
    input  logic signed [15:0] gain_b,      // gain B

    output logic signed [15:0] out_l,       // Output left 
    output logic signed [15:0] out_r        // Output right 
);

    logic signed [31:0] product_a_l;        // declaration: in_a_l * gain_a 
    logic signed [31:0] product_a_r;        // declaration: in_a_r * gain_a 

    logic signed [31:0] product_b_l;        // declaration: in_b_l * gain_b
    logic signed [31:0] product_b_r;        // declaration: in_b_r * gain_b 

    logic signed [17:0] scaled_a_l;         // declaration: product_a_l scaled back to PCM units
    logic signed [17:0] scaled_a_r;         // declaration: product_a_r scaled back to PCM units

    logic signed [17:0] scaled_b_l;         // declaration: product_b_l scaled back to PCM units
    logic signed [17:0] scaled_b_r;         // declaration: product_b_r scaled back to PCM units

    logic signed [18:0] mixed_l;            // declaration: scaled_a_l + scaled_b_l
    logic signed [18:0] mixed_r;            // declaration: scaled_a_r + scaled_b_r

    // product_a_l = in_a_l * gain_a;          // assignment: input A left * gain A
    // product_a_r = in_a_r * gain_a;          // assignment: input A right * gain A

    // product_b_l = in_b_l * gain_b;          // assignment: input B left * gain B
    // product_b_r = in_b_r * gain_b;          // assignment: input B right * gain B


endmodule