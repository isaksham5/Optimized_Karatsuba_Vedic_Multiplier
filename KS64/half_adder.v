module half_adder (
input A, B,
output Sum, Cout
);
assign Sum = A ^ B;   
assign Cout = A &B ;    
endmodule