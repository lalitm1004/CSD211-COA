module half_adder(
    input A,
    input B,
    output SUM,
    output CARRY
);
    assign SUM = A ^ B;
    assign CARRY = A & B;
endmodule

module half_adder_tb;
    reg A, B;
    wire SUM, CARRY;

    half_adder hf (
        .A(A),
        .B(B),
        .SUM(SUM),
        .CARRY(CARRY)
    );

    initial begin
        A = 1'b0; B = 1'b0; #10;
        $display("A = %b | B = %b | SUM = %b | CARRY = %b", A, B, SUM, CARRY);
        A = 1'b0; B = 1'b1; #10;
        $display("A = %b | B = %b | SUM = %b | CARRY = %b", A, B, SUM, CARRY);
        A = 1'b1; B = 1'b0; #10;
        $display("A = %b | B = %b | SUM = %b | CARRY = %b", A, B, SUM, CARRY);
        A = 1'b1; B = 1'b1; #10;
        $display("A = %b | B = %b | SUM = %b | CARRY = %b", A, B, SUM, CARRY);
        $finish;
    end
endmodule