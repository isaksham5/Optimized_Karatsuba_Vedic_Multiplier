module CLA8 (
    input  [7:0] A, B,
    input        Cin,
    output [7:0] S,
    output       GG, GP
);
 
wire [1:0] GG4, GP4;
wire c4;
 
CLA4 blk0 (A[3:0], B[3:0], Cin, S[3:0], GG4[0], GP4[0]);
CLA4 blk1 (A[7:4], B[7:4], c4,  S[7:4], GG4[1], GP4[1]);
 
// c4 = GG0 + GP0.Cin
wire t0;
and a0 (t0, GP4[0], Cin);
or  o0 (c4, GG4[0], t0);
 
// GG = GG1 + GP1.GG0 + GP1.GP0.Cin
// GP = GP1.GP0
wire tg0, tg1;
and ag0 (tg0, GP4[1], GG4[0]);
and ag1 (tg1, GP4[1], GP4[0], Cin);
or  ogg (GG,  GG4[1], tg0, tg1);
and agp (GP,  GP4[1], GP4[0]);
 
endmodule
