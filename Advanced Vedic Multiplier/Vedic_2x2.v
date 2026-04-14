module VM2 (
    input  [1:0] A,
    input  [1:0] B,
    output [3:0] P
);
wire pp00, pp01, pp10, pp11;
wire carry1;

// Partial products

and G00 (pp00, A[0], B[0]);
and G01 (pp01, A[0], B[1]);
and G10 (pp10, A[1], B[0]);
and G11 (pp11, A[1], B[1]);

// Output assignments

assign P[0] = pp00;

half_adder a1(pp01,pp10,P[1],carry1);
half_adder a2(pp11, carry1, P[2], P[3]);

endmodule
