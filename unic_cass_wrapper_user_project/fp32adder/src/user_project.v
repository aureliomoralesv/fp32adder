module user_project(
    `ifdef USE_POWER_PINS
    inout VPWR,    // Common digital supply
    inout VGND,    // Common digital ground
    `endif
    input  wire clk_i,
    input  wire rst_ni,
    input  wire [16:0] ui_PAD2CORE,
    output wire [16:0] uo_CORE2PAD
);
    assign uo_CORE2PAD[16:5] = 12'hFFF; // Tie off unused outputs
    wire [16:2] dummy_read = ui_PAD2CORE[16:2];

    add_float add_float_inst(
    `ifdef USE_POWER_PINS
    .VPWR   (VPWR),
    .VGND   (VGND),
    `endif
    .clk   (clk_i),
    .reset (rst_ni),
    .go    (ui_PAD2CORE[0]),
    .inpab (ui_PAD2CORE[1]),
    .shift (uo_CORE2PAD[0]),
    .out_c (uo_CORE2PAD[1]),
    .over  (uo_CORE2PAD[2]),
    .under (uo_CORE2PAD[3]),
    .done  (uo_CORE2PAD[4])
    );

endmodule
