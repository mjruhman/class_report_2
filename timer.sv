module timer (
    input  logic clk,
    input  logic clear,
    input  logic start,
    input  logic stop,
    output logic led,
    output logic [7:0] sseg,
    output logic [7:0] an
);

    typedef enum{initialize, pause, random, reset_ms, led_on, thousands, nines, fin} state_type;

    state_type current_state, next_state;

    logic [16:0] elapsed_ms, ms_count;
    logic [15:0] display_data;

    parameter N_rand = 14;
    logic [N_rand-1:0] random_ms, random_ms_scaled;


    prbs#(N_rand) lfsr(
        .clk(clk),
        .rst(clear),
        .rnd(random_ms)
    );

    seven_seg ss(
        .clk(clk),
        .clear(clear),
        .display_data(display_data),
        .sseg(sseg),
        .an(an)
    );


    always_ff @(posedge(clk), posedge(clear)) begin
        if (clear) begin
            current_state      <= initialize;
            elapsed_ms         <= 0;
            ms_count         <= 0;
            random_ms_scaled   <= 0;
        end else begin
            current_state <= next_state;

            if (current_state != fin) begin
                if (ms_count == 99999) begin
                    ms_count <= 0;
                    elapsed_ms <= elapsed_ms + 1;
                end else begin
                    ms_count <= ms_count + 1;
                end
            end

            case (current_state)
                random: begin
                    elapsed_ms <= 0;
                    //make it between 2 - 15 seconds
                    random_ms_scaled <= 14'd2000 + (random_ms % 14'd13001);
                end

                reset_ms:
                    elapsed_ms <= 0;

                default: ;
            endcase
        end
    end

    always_comb begin
    next_state = current_state;
    led = 1'b0;
    display_data = 16'hBBBB;

    case (current_state)
        initialize: begin
            display_data = 16'hBBCE;
            if (start)
                next_state = random;
        end

        random: begin
            next_state = pause;
        end

        pause: begin
            if (elapsed_ms == random_ms_scaled)
                next_state = reset_ms;
            else if (stop)
                next_state = nines;
        end

        reset_ms: begin
            next_state = led_on;
        end

        led_on: begin
            led = 1'b1;
            display_data[3:0] = elapsed_ms % 10;
            display_data[7:4] = (elapsed_ms / 10) % 10;
            display_data[11:8] = (elapsed_ms / 100) % 10;
            display_data[15:12] = (elapsed_ms / 1000) % 10;

            if (stop)
                next_state = fin;
            else if (elapsed_ms >= 1000)
                next_state = thousands;
        end

        nines: begin
            display_data = 16'h9999;
        end

        thousands: begin
            display_data = 16'h1000;
        end

        fin: begin
            display_data[3:0] = elapsed_ms % 10;
            display_data[7:4] = (elapsed_ms / 10) % 10;
            display_data[11:8] = (elapsed_ms / 100) % 10;
            display_data[15:12] = (elapsed_ms / 1000) % 10;
        end

        default: begin
            next_state = initialize;
        end
    endcase
end

endmodule
