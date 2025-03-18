module paddle
  #(parameter GAME_WIDTH=40,
    parameter GAME_HEIGHT=30,
    parameter PADDLE_X=0,
    parameter PADDLE_HEIGHT=6)
  (input clock,
   input game_active,
   input [5:0] icolcount,
   input [5:0] irowcount,
   input iup,
   input idown,
   output odrawpaddle,
   output [5:0] opaddley);

  parameter speed = 1250000;

  reg [31:0] rpadcount = 0;
  wire wpadcount;

  reg [5:0] pady = GAME_HEIGHT / 2 - 1;
  reg draw;

  assign wpadcount = iup ^ idown;

  always @(posedge clock) begin
    if(~game_active) begin
      rpadcount <= 0;
      pady <= GAME_HEIGHT / 2 - 1;
    end else begin
      if (wpadcount == 1'b1) begin
        if (rpadcount < speed) begin
          rpadcount <= rpadcount + 1;
        end else begin
          rpadcount <= 0;

          if(iup == 1'b1 && pady > 0) begin
            pady <= pady - 1;
          end else if (idown == 1'b1 && pady < (GAME_HEIGHT - PADDLE_HEIGHT)) begin
            pady <= pady + 1;
          end
        end         
      end
    end
  end

  always @(posedge clock) begin
    if(icolcount == PADDLE_X &&
       irowcount >= pady &&
       irowcount <= pady + PADDLE_HEIGHT)
      draw <= 1'b1;
    else
      draw <= 1'b0;
  end

  assign odrawpaddle = draw;
  assign opaddley = pady;
endmodule
