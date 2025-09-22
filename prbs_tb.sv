`timescale 1ns/1ps

module prbs_tb;


    localparam N = 14;


    logic clk;
    logic rst;
    logic [N-1:0] rnd;


    always #5 clk = ~clk;


    prbs #(.N(N)) dut (
        .clk(clk),
        .rst(rst),
        .rnd(rnd)
    );

    initial begin
        
        clk = 0;
        rst = 1;

        
        #20;
        rst = 0;

        
        repeat (50) @(posedge clk);

        
        rst = 1;
        #10;
        rst = 0;

        repeat (30) @(posedge clk);

        $finish;
    end

    

endmodule
