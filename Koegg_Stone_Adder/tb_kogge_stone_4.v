`timescale 1ns/1ps

module tb_kogge_stone_4;

reg [3:0] x, y;
reg clk;
wire [3:0] sum;
wire cout;

// Instantiate DUT
Kogge_Stone_4 uut (
    .x(x),
    .y(y),
    .clk(clk),
    .sum(sum),
    .cout(cout)
);

// Clock generation
always #5 clk = ~clk;

// Pipeline registers to track inputs
reg [3:0] x_d [0:3];
reg [3:0] y_d [0:3];

integer i;

// Stimulus
initial begin
    clk = 0;
    x = 0;
    y = 0;

    // Apply inputs
    #10;

    for (i = 0; i < 15; i = i + 1) begin
        @(posedge clk);
        x = $random % 16;
        y = $random % 16;
    end

    // Wait for pipeline flush
    repeat(5) @(posedge clk);

    $finish;
end

// Pipeline input tracking
integer k;
always @(posedge clk) begin
    x_d[0] <= x;
    y_d[0] <= y;

    for (k = 1; k < 4; k = k + 1) begin
        x_d[k] <= x_d[k-1];
        y_d[k] <= y_d[k-1];
    end
end

// Output checking
always @(posedge clk) begin
    // Wait until pipeline fills
    if ($time > 30) begin
        if ({cout, sum} !== (x_d[3] + y_d[3])) begin
            $display("? ERROR: x=%b y=%b -> got=%b expected=%b",
                     x_d[3], y_d[3], {cout, sum}, x_d[3] + y_d[3]);
        end else begin
            $display("? PASS: x=%b y=%b -> result=%b",
                     x_d[3], y_d[3], {cout, sum});
        end
    end
end

endmodule
