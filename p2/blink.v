module led_toggle(
  input clock,
  input switch1,
  output led1);
  
  reg rled = 1'b0;
  reg rswitch = 1'b0;

  always @(posedge clock)
  begin
    rswitch <= switch1;

    if(switch1 == 1'b0 && rswitch == 1'b1)
    begin
      rled <= ~rled;
    end
  end

  assign led1 = rled;

endmodule
