module karatsuba_4x4_struct(
    input [3:0] A, B,
    output [7:0] P
);

// ----------------
// Split inputs
// ----------------
wire [1:0] A1 = A[3:2];
wire [1:0] A0 = A[1:0];
wire [1:0] B1 = B[3:2];
wire [1:0] B0 = B[1:0];

// ----------------
// Z2 and Z0 using 2-bit Karatsuba
// ----------------
wire [3:0] Z2, Z0;

karatsuba_2x2_struct m1(A1, B1, Z2);
karatsuba_2x2_struct m2(A0, B0, Z0);

// ----------------
// Compute (A1 + A0) and (B1 + B0)
// ----------------
wire [3:0] sumA, sumB;

assign sumA = A1 + A0;  // can go up to 3 bits
assign sumB = B1 + B0;

// ----------------
// Multiply sums
// ----------------
wire [7:0] Z1_temp;

Vedic_4x4 m3(sumA, sumB, Z1_temp[7:0]);

// NOTE: upper bits handling needed for full correctness

// ----------------
// Compute Z1
// ----------------
wire [7:0] Z1;

assign Z1 = Z1_temp - Z2 - Z0;

// ----------------
// Final Assembly
// ----------------
assign P = (Z2 << 4) + (Z1 << 2) + Z0;

endmodule