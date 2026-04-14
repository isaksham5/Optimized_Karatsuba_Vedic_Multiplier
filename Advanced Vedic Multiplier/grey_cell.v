module grey_cell(g1,p1,g0,g);
input g0,g1,p1;
output g;
wire w;
and(w,p1,g0);
or(g,w,g1);
endmodule

