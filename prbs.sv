module prbs#(parameter N=14)(
    input logic clk,
    input logic rst,
    output logic rnd
    );
    
    parameter START = {{(N-1){1'b0}}, 1'b1};
    
    logic [N-1:0]count;
    logic [N-1:0]ncount;
    
    logic feedback;
    
    // Shift Register
    always_ff @(posedge(clk), posedge(rst))
        if(rst)
            count <= START;
        else
            count <= ncount;
    
    assign feedback = count[13]^count[4]^count[2]^count[0];
    assign ncount = {count[13:0], feedback};
    
    assign rnd = count[13:0];
      
endmodule
