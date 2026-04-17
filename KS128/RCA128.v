module RCA128 (
    input clk,
    input  [127:0] A, B,
    input cin,
    output [127:0] sum,
    output cout
);

wire [128:0] c;

buf b0(c[0],cin);

genvar i;
generate
    for (i = 0; i < 128; i = i + 1) begin : FA_CHAIN
        full_adder fa (
            A[i],
            B[i],
            c[i],
            sum[i],
            c[i+1]
        );
    end
endgenerate

buf b1(cout, c[128]);

endmodule
