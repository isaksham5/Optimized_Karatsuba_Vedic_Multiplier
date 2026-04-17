module RCA64 (
    input  [63:0] A, B,
    input cin,
    output [63:0] sum,
    output cout
);

wire [64:0] c;
buf b0(c[0],cin);

genvar i;
generate
    for (i = 0; i < 64; i = i + 1) begin : FA_CHAIN
        full_adder fa (
            .a(A[i]),
            .b(B[i]),
            .cin(c[i]),
            .sum(sum[i]),
            .cout(c[i+1])
        );
    end
endgenerate

assign cout = c[64];

endmodule
