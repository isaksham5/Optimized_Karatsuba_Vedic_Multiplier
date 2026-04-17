module FA (
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    wire w1, w2, w3;
    
    // sum = a XOR b XOR cin
    xor(w1, a, b);
    xor(sum, w1, cin);
    
    // cout = (a AND b) OR ((a XOR b) AND cin)
    and(w2, a, b);
    and(w3, w1, cin);
    or(cout, w2, w3);
    
endmodule