module VM4(
    input  [3:0] x, y,
    output [7:0] prod
);
    wire [3:0] p0, p1, p2, p3;
    VM2 v1(x[1:0], y[1:0], p0);
    VM2 v2(x[1:0], y[3:2], p1);
    VM2 v3(x[3:2], y[1:0], p2);
    VM2 v4(x[3:2], y[3:2], p3);

    wire [3:0] p12, p012;
    wire c12, c012, cout;

    KS4 a0(p1, p2,                1'b0, p12,  c12);
    assign prod[1:0] = p0[1:0];

    KS4 a1(p12, {2'b0, p0[3:2]}, 1'b0, p012, c012);
    assign prod[3:2] = p012[1:0];

    wire s, c;
    half_adder HA1(c12, c012, s, c);

    KS4 a2(p3, {c, s, p012[3:2]}, 1'b0, prod[7:4], cout);
	
endmodule