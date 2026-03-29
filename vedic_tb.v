module tb_vedic_multiplier_4bit;
reg  [3:0] A, B;
wire [7:0] P;

vedic_multiplier_4bit uut (
        .A(A),
        .B(B),
        .P(P)
    );
integer i, j;
initial begin
$display("A\tB\t|\tP\t|\tExpected");

// Testing all 256 combinations
for (i = 0; i < 16; i = i + 1) begin
   for (j = 0; j < 16; j = j + 1) begin
       A = i;
       B = j;
       #5;

if (P !== (A * B)) begin
$display("ERROR: A=%d B=%d -> P=%d Expected=%d", A, B, P, A*B);
end else begin
$display("%d\t%d\t|\t%d\t|\t%d", A, B, P, A*B);
end
end
end
$display("TEST COMPLETED");
$finish;
end
endmodule
