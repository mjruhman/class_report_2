module sseg (
    input logic clk, 
    input logic clear,
    input logic [15:0] display_data,
    output logic [7:0]  sseg,
    output logic [7:0]  an
);

    parameter N = 18;
    logic [N-1:0] count;

    always_ff @(posedge(clk)) begin
        if (clear)
            count <= 0;
        else
            count <= count + 1;
    end

    logic [1:0] digit_sel;
    assign digit_sel = count[N-1 -: 2];

    // Digit selection from display data
    logic [3:0] digit_data;
    always_comb begin
        case (digit_sel)
            2'd0: digit_data = display_data[3:0];
            2'd1: digit_data = display_data[7:4];
            2'd2: digit_data = display_data[11:8];
            2'd3: digit_data = display_data[15:12];
            default: digit_data = 4'hF;
        endcase
    end

    localparam logic [7:0] SEG_LUT [0:15] = {
        8'hC0, // 0
        8'hF9, // 1
        8'hA4, // 2
        8'hB0, // 3
        8'h99, // 4
        8'h92, // 5
        8'h82, // 6
        8'hF8, // 7
        8'h80, // 8
        8'h90, // 9
        8'h88, // A
        8'hFF, // B (blank)
        8'h89, // H
        8'hFF, // D (blank)
        8'hCF, // I
        8'hFF  // F (blank)
    };

    always_comb begin
        sseg = SEG_LUT[digit_data];
        an = ~(8'b00000001 << digit_sel);
    end

endmodule
