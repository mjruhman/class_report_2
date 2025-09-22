
module sseg_tb;

    logic clk;
    logic clear;
    logic [15:0] display_data;
    logic [7:0] sseg;
    logic [7:0] an;

    always #5 clk = ~clk;


    sseg #(.N(8)) dut ( 
        .clk(clk),
        .clear(clear),
        .display_data(display_data),
        .sseg(sseg),
        .an(an)
    );

    initial begin

        clk = 0;
        clear = 1;
        display_data = 16'h8320;

        #20;
        clear = 0;
        repeat (40) @(posedge clk);

        display_data = 16'hABCD;
        repeat (40) @(posedge clk);

        display_data = 16'h8888; 
        repeat (40) @(posedge clk);

        $finish;
    end



endmodule
