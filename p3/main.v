module main(
  input clock,
  input switch1,
  input switch2,
  input switch3,
  input switch4,
  output led1,
  output led2,
  output led3,
  output led4,
 
  output segment1a,
  output segment1b,
  output segment1c,
  output segment1d,
  output segment1e,
  output segment1f,
  output segment1g,
 
  output segment2a,
  output segment2b,
  output segment2c,
  output segment2d,
  output segment2e,
  output segment2f,
  output segment2g);

  reg rs1;
  reg rs2;
  reg rs3;
  reg rs4;

  reg rl1;
  reg rl2;
  reg rl3;
  reg rl4;

  wire wire1;
  wire wire2;
  wire wire3;
  wire wire4;

  Debounce a(.clock(clock),
             .in(switch1),
             .out(wire1));
 
  Debounce b(.clock(clock),
             .in(switch2),
             .out(wire2));

  Debounce c(.clock(clock),
             .in(switch3),
             .out(wire3));
  
  Debounce d(.clock(clock),
             .in(switch4),
             .out(wire4));


  reg [3:0] s1 = 0;
  reg [3:0] s2 = 0;
  reg [6:0] out1;
  reg [6:0] out2;

  BinaryTo7Seg b1(.bcd(s1),
                  .seg(out1));

  BinaryTo7Seg b2(.bcd(s2),
                  .seg(out2));

  always @(posedge clock)
  begin
    rs1 <= wire1;
    rs2 <= wire2;
    rs3 <= wire3;
    rs4 <= wire4;
    
    if (wire1 == 1'b0 && rs1 == 1'b1) begin
      rl1 <= ~rl1;
      s1 <= s1 + 1; 
    end
  
    if (wire2 == 1'b0 && rs2 == 1'b1) begin
      rl2 <= ~rl2;
      s1 <= s1 - 1; 
    end

    if (wire3 == 1'b0 && rs3 == 1'b1) begin
      rl3 <= ~rl3; 
      s2 <= s2 + 1;
    end
    
    if (wire4 == 1'b0 && rs4 == 1'b1) begin
      rl4 <= ~rl4; 
      s2 <= s2 - 1;
    end
  end
  assign led1 = rl1;
  assign led2 = rl2;
  assign led3 = rl3;
  assign led4 = rl4;
  
  assign segment1a = out1[6];
  assign segment1b = out1[5];
  assign segment1c = out1[4];
  assign segment1d = out1[3];
  assign segment1e = out1[2];
  assign segment1f = out1[1];
  assign segment1g = out1[0];
  
  assign segment2a = out2[6];
  assign segment2b = out2[5];
  assign segment2c = out2[4];
  assign segment2d = out2[3];
  assign segment2e = out2[2];
  assign segment2f = out2[1];
  assign segment2g = out2[0];

endmodule
