// Verilog 2001 code
`timescale 1ns / 1ps

module tb03;

    // Constants
    parameter MAX_INPUT = 60;
    // TIMEOUT is not strictly needed in Verilog unless using a watchdog, 
    // but the 20ns period is reflected in the clock toggle.

    // Signals
    reg		clk      = 1'b0;
    reg		reset    = 1'b1;
    reg		go       = 1'b1;
    reg		inpab    = 1'b0;
    wire	shift;
    wire	out_c;
    wire	over;
    wire	under;
    wire	done;
    reg		sim_done = 1'b0;
    
    reg [31:0]  val_a = 32'b00111111000000000000000000000000; //+1.000x2^(-1)
    reg [31:0]  val_b = 32'b10111110111000000000000000000000; //-1.110x2^(-2)
//val_a+val_b = reg_c = 32'b00111101100000000000000000000000  = +1.000x2^(-4)

    // Instantiate Unit Under Test (UUT)
    add_float U_FSM_D (
        .clk(clk),
        .reset(reset),
        .go(go),
        .inpab(inpab),
        .shift(shift),
        .out_c(out_c),
        .over(over),
        .under(under),
        .done(done)
    );

    // Clock Generation
    always begin
        if (sim_done == 1'b0)
            #10 clk = ~clk;
        else
            #10; // Keep time moving or stop clk
    end

    // Stimulus Process
    integer i;
    initial begin
        // Reset circuit
        reset = 1'b1;
        go    = 1'b1;
        #100;
        reset = 1'b0;
        
        // Wait for two rising edges
        @(posedge clk);
        @(posedge clk);

        @(posedge clk);
        go = 1'b0;
        @(posedge clk);
		
        // Loop through val_a (MSB to LSB)
        for (i = 31; i >= 0; i = i - 1) begin
            #5 inpab = val_a[i];
            @(posedge clk);
        end
		
        // Loop through val_b (MSB to LSB)
        for (i = 31; i >= 0; i = i - 1) begin
            #5 inpab = val_b[i];
            @(posedge clk);
        end
		
        // Wait for MAX_INPUT-1 cycles
        repeat (MAX_INPUT - 1) begin
            @(posedge clk);
        end

        $display("SIMULATION FINISHED!!!");
        sim_done = 1'b1;
        
        // Stop simulation
        #20;
        $finish;
    end

endmodule
