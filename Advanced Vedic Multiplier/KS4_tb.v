module tb_KS4;

    reg  [3:0] A, B;
    reg        cin;
    wire [3:0] sum;
    wire       cout;

    wire [4:0] expected;
    assign expected = A + B + cin;

    KS4 uut (A, B, cin, sum, cout);

    integer errors = 0;
    integer tests  = 0;

    task check;
        input [3:0] a, b;
        input       c;
        begin
            A = a; B = b; cin = c;
            #10;
            tests = tests + 1;
            if ({cout, sum} !== expected) begin
                $display("FAIL: A=%0d B=%0d cin=%0b | got=%0b cout=%0b | expected=%0b",
                          a, b, c, sum, cout, expected);
                errors = errors + 1;
            end
        end
    endtask

    integer i, j, k;

    initial begin
        $display("=== KS4 Exhaustive Testbench ===");
        errors = 0; tests = 0;
        A = 0; B = 0; cin = 0;
        #10;

        // Full exhaustive sweep: all 4-bit A, B, cin combinations = 512 tests
        for (i = 0; i < 16; i = i + 1)
            for (j = 0; j < 16; j = j + 1)
                for (k = 0; k < 2; k = k + 1)
                    check(i, j, k);

        $display("==============================");
        $display("Total tests : %0d", tests);
        $display("Errors      : %0d", errors);
        if (errors == 0)
            $display("ALL TESTS PASSED ?");
        else
            $display("FAILURES DETECTED ?");
        $display("==============================");

        $finish;
    end

endmodule
