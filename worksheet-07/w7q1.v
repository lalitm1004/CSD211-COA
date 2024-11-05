module full_adder(
    input A,
    input B,
    input Cin,
    output Sum,
    output Cout
);
    assign Sum = A ^ B ^ Cin;
    assign Cout = (A & B) | (B & Cin) | (A & Cin);
endmodule


module multiplier_4bit(
    input [3:0] A,
    input [3:0] B,
    output [7:0] Product
);
    wire [3:0] p0, p1, p2, p3;
    wire c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11;
    wire s1, s2, s3, s4, s5, s6;

    // Partial Products
    assign p0 = A & {4{B[0]}};
    assign p1 = A & {4{B[1]}};
    assign p2 = A & {4{B[2]}};
    assign p3 = A & {4{B[3]}};

    // First stage
    assign Product[0] = p0[0];
    full_adder fa1(.A(p0[1]), .B(p1[0]), .Cin(1'b0), .Sum(Product[1]), .Cout(c1));
    full_adder fa2(.A(p0[2]), .B(p1[1]), .Cin(c1), .Sum(s1), .Cout(c2));
    full_adder fa3(.A(p0[3]), .B(p1[2]), .Cin(c2), .Sum(s2), .Cout(c3));
    full_adder fa4(.A(1'b0), .B(p1[3]), .Cin(c3), .Sum(s3), .Cout(c4));

    // Second stage
    full_adder fa5(.A(s1), .B(p2[0]), .Cin(1'b0), .Sum(Product[2]), .Cout(c5));
    full_adder fa6(.A(s2), .B(p2[1]), .Cin(c5), .Sum(s4), .Cout(c6));
    full_adder fa7(.A(s3), .B(p2[2]), .Cin(c6), .Sum(s5), .Cout(c7));
    full_adder fa8(.A(c4), .B(p2[3]), .Cin(c7), .Sum(s6), .Cout(c8));

    // Third stage
    full_adder fa9(.A(s4), .B(p3[0]), .Cin(1'b0), .Sum(Product[3]), .Cout(c9));
    full_adder fa10(.A(s5), .B(p3[1]), .Cin(c9), .Sum(Product[4]), .Cout(c10));
    full_adder fa11(.A(s6), .B(p3[2]), .Cin(c10), .Sum(Product[5]), .Cout(c11));
    full_adder fa12(.A(c8), .B(p3[3]), .Cin(c11), .Sum(Product[6]), .Cout(Product[7]));
endmodule


module multiplier_4bit_tb;
    reg [3:0] A;
    reg [3:0] B;
    wire [7:0] Product;

    multiplier_4bit multiplier (
        .A(A),
        .B(B),
        .Product(Product)
    );

    initial begin
        A = 4'b1011;
        B = 4'b1110;
        #10;
        $display("A = %b | B = %b | Product = %b", A, B, Product);
        $finish;
    end
endmodule
