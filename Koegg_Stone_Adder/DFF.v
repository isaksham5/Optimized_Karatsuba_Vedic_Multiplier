module dff #(parameter N = 1)(
    input clk,
    input [N-1:0] d,
    output reg [N-1:0] q
);
    always @(posedge clk)
        q <= d;
endmodule
