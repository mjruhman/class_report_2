`timescale 1ns/1ps

module tb_prbs;

    // Parameters
    localparam N = 14;

    // DUT signals
    logic clk;
    logic rst;
    logic [N-1:0] rnd;

    // Clock generation: 100 MHz
    always #5 clk = ~clk;

    // Instantiate DUT
    prbs #(.N(N)) dut (
        .clk(clk),
        .rst(rst),
        .rnd(rnd)
    );

    // Test procedure
    initial begin
        // Initialize
        clk = 0;
        rst = 1;

        // Apply reset
        #20;
        rst = 0;

        // Let it run for a while
        repeat (50) @(posedge clk);

        // Apply another reset mid-way
        rst = 1;
        #10;
        rst = 0;

        repeat (30) @(posedge clk);

        $display("PRBS test completed.");
        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("Time=%0t | rst=%b | rnd=%h",
                 $time, rst, rnd);
    end

endmodule
