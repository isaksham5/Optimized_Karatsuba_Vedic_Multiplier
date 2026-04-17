module black_cell(g1,p1,g0,p0,g,p);
input g0,p0,g1,p1;
output g,p;
grey_cell m1(g1,p1,g0,g);
and(p,p0,p1);
endmodule
