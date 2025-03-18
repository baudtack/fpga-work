module debounce
  (input clock,
    input in,
    output out);
  parameter c_DEBOUNCE_LIMIT = 250000;

  reg [17:0] count = 0;
  reg state = 1'b0;

  always @(posedge clock)
  begin
    if (in !== state && count < c_DEBOUNCE_LIMIT)
      count <= count + 1;
    else if (count == c_DEBOUNCE_LIMIT)
    begin
      state <= in;
      count <= 0;
    end
     else
       count <= 0;
  end

  assign out = state;
 endmodule
