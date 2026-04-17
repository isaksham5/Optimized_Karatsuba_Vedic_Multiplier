
module full_adder (
    input a, b, cin,
    output sum, cout
);

assign sum  = a ^ b ^ cin;
assign cout = (a & b) | (b & cin) | (a & cin);

endmodule

module RCA32 (
    input  [31:0] A, B,
    input  cin,
    output [31:0] sum,
    output cout
);

wire [32:0] c;
assign c[0] = cin;

genvar i;
generate
    for (i = 0; i < 32; i = i + 1) begin : FA_CHAIN
        full_adder fa (
            .a(A[i]),
            .b(B[i]),
            .cin(c[i]),
            .sum(sum[i]),
            .cout(c[i+1])
        );
    end
endgenerate

assign cout = c[32];

endmodule
