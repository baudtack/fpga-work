module main(
  input clock,
  input switch1,
  input switch2,
  input switch3,
  input switch4,
  output led1,
  output led2,
  output led3,
  output led4);

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

  always @(posedge clock)
  begin
    rs1 <= wire1;
    rs2 <= wire2;
    rs3 <= wire3;
    rs4 <= wire4;
    
    if (wire1 == 1'b0 && rs1 == 1'b1)
      rl1 <= ~rl1; 
  
    if (wire2 == 1'b0 && rs2 == 1'b1)
      rl2 <= ~rl2; 

    if (wire3 == 1'b0 && rs3 == 1'b1)
      rl3 <= ~rl3; 
    
    if (wire4 == 1'b0 && rs4 == 1'b1)
      rl4 <= ~rl4; 
  
  end
  assign led1 = rl1;
  assign led2 = rl2;
  assign led3 = rl3;
  assign led4 = rl4;
endmodule
