module led_toggle(
  input clock,
  input switch1,
  output led1);
  
  reg rled = 1'b0;
  reg rswitch = 1'b0;
  wire wswitch;

  Debounce deb
  (.clock(clock),
   .in(switch1),
   .out(wswitch));


  always @(posedge clock)
  begin
    rswitch <= wswitch;

    if(wswitch == 1'b0 && rswitch == 1'b1)
    begin
      rled <= ~rled;
    end
  end

  assign led1 = rled;

endmodule
