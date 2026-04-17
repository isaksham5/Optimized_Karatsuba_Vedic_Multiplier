module initialize(x,y,g,p);
input x,y;
output g,p;

xor(p,x,y);//p=x^y
and(g,x,y);//g=x*y

endmodule