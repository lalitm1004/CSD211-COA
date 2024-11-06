module full_adder(
    input A,
    input B,
    input CARRYIN,
    output SUM,
    output CARRYOUT
);
    assign SUM = A ^ B ^ CARRYIN;
    assign CARRYOUT = (A & B) | ((A ^ B) & CARRYIN);
endmodule

module full_adder_tb;
    reg A, B, CARRYIN;
    wire SUM, CARRYOUT;

    full_adder fa (
        .A(A),
        .B(B),
        .CARRYIN(CARRYIN),
        .SUM(SUM),
        .CARRYOUT(CARRYOUT)
    );

    initial begin
        A = 1'b0; B = 1'b0; CARRYIN = 1'b0; #10;
        $display("A = %b | B = %b | Cin = %b | Sum = %b | Cout = %b", A, B, CARRYIN, SUM, CARRYOUT);
        A = 1'b0; B = 1'b0; CARRYIN = 1'b1; #10;
        $display("A = %b | B = %b | Cin = %b | Sum = %b | Cout = %b", A, B, CARRYIN, SUM, CARRYOUT);
        A = 1'b0; B = 1'b1; CARRYIN = 1'b0; #10;
        $display("A = %b | B = %b | Cin = %b | Sum = %b | Cout = %b", A, B, CARRYIN, SUM, CARRYOUT);
        A = 1'b0; B = 1'b1; CARRYIN = 1'b1; #10;
        $display("A = %b | B = %b | Cin = %b | Sum = %b | Cout = %b", A, B, CARRYIN, SUM, CARRYOUT);
        A = 1'b1; B = 1'b0; CARRYIN = 1'b0; #10;
        $display("A = %b | B = %b | Cin = %b | Sum = %b | Cout = %b", A, B, CARRYIN, SUM, CARRYOUT);
        A = 1'b1; B = 1'b0; CARRYIN = 1'b1; #10;
        $display("A = %b | B = %b | Cin = %b | Sum = %b | Cout = %b", A, B, CARRYIN, SUM, CARRYOUT);
        A = 1'b1; B = 1'b1; CARRYIN = 1'b0; #10;
        $display("A = %b | B = %b | Cin = %b | Sum = %b | Cout = %b", A, B, CARRYIN, SUM, CARRYOUT);
        A = 1'b1; B = 1'b1; CARRYIN = 1'b1; #10;
        $display("A = %b | B = %b | Cin = %b | Sum = %b | Cout = %b", A, B, CARRYIN, SUM, CARRYOUT);
        $finish;
    end
endmodule