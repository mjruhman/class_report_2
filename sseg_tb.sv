`timescale 1ns/1ps

module tb_sseg;

    // DUT signals
    logic clk;
    logic clear;
    logic [15:0] display_data;
    logic [7:0] sseg;
    logic [7:0] an;

    // Clock generation: 100 MHz (10 ns period)
    always #5 clk = ~clk;

    // Instantiate DUT
    sseg #(.N(8)) dut ( // use smaller N for faster sim
        .clk(clk),
        .clear(clear),
        .display_data(display_data),
        .sseg(sseg),
        .an(an)
    );

    // Test procedure
    initial begin
        // Initialize signals
        clk = 0;
        clear = 1;
        display_data = 16'h1234;

        // Apply reset
        #20;
        clear = 0;

        // Wait and observe digit cycling
        repeat (40) @(posedge clk);

        // Change display_data
        display_data = 16'h90AF;  // digits: F A 0 9
        repeat (40) @(posedge clk);

        // Another pattern
        display_data = 16'h8888;  // all 8’s
        repeat (40) @(posedge clk);

        // End simulation
        $display("Test completed");
        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("Time=%0t | clear=%b | display_data=%h | an=%b | sseg=%h",
                 $time, clear, display_data, an, sseg);
    end

endmodule
