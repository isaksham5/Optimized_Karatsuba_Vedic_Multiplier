/*module karatsuba_2x2(
    input [1:0] a,
    input [1:0] b,
    output [3:0] product
);

    wire p0, p1, p2;
    wire sum1, sum2;
    wire carry;

    // p0 = a[0] * b[0]
    and and0(p0, a[0], b[0]);
    
    // p2 = a[1] * b[1]
    and and2(p2, a[1], b[1]);
    
    // p1 = (a[0] + a[1]) * (b[0] + b[1])
    xor xor_a(sum1, a[0], a[1]);
    xor xor_b(sum2, b[0], b[1]);
    and and1(p1, sum1, sum2);
    
    // Product computation
    assign product[0] = p0;
    
    xor xor_p1(product[1], p0, p1);
    xor xor_p2(product[1], product[1], p2);
    
    and and_carry(carry, p1, p2);
    xor xor_p3(product[2], p1, p2);
    or or_p3(product[2], product[2], carry);
    
    assign product[3] = p2 & carry;

endmodule
*/
//=======================================================================

module karatsuba_2x2_struct(
    input [1:0] A, B,
    output [3:0] prod
);

// -------------------
// | Step 1: Z2 & Z0 |
// -------------------
wire[1:0] z2, z0;
assign z2[0] = A[1] & B[1];
assign z0[0] = A[0] & B[0];

// ----------------
// Step 2: (A1+A0) and (B1+B0)
// ----------------
wire sA, cA, sB, cB;

HA ha1(A[1], A[0], sA, cA);  // sumA = cA sA
HA ha2(B[1], B[0], sB, cB);  // sumB = cB sB


// ----------------
// Step 3: Multiply (sumA * sumB)
// (2-bit × 2-bit multiplier structurally)
// ----------------

wire [3:0] P;
vedic_2x2 vm1({cA, sA},{cB, sB},P);
// ----------------
// Step 4: z1 = z1_temp - z2 - z0
// ----------------

// First subtract z2
wire [2:0] temp1;
wire b1;
//max value of P for 11 and 11 is 10*10=0100, hence no more than 3 bits are needed for temp1

// temp1 = P - z2

FA fa1(P[0], ~z2[0], 1'b1, temp1[0], b1); 
FA fa2(P[1], 1'b1, b1, temp1[1], temp1[2]); 

// Then subtract z0
wire [1:0] z1;
wire b3;

FA fa3(temp1[0], ~z0[0], 1'b1, z1[0], b3);
FA fa4(temp1[1], 1'b1, b3, z1[1], temp1[2]);

// ----------------
// Step 5: Final Assembly
// P = (z2<<2) + (z1<<1) + z0
// ----------------

// Add (z1 << 1) + z0

assign prod[0] = z0[0];
assign prod[1] = z1[0];

HA ha5(z2[0], z1[1], prod[2], prod[3]); // prod[2] = c5, prod[3] = s5


endmodule