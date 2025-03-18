module ball
    #(parameter GAME_WIDTH=40,
      parameter GAME_HEIGHT=30)

   (input clock,
    input game_active,
    input [5:0] icolcount,
    input [5:0] irowcount,
    output reg odrawball,
    output reg [5:0] oballx,
     output reg [5:0] obally);


  parameter speed = 1250000;

  reg [5:0]  ballxprev = 0;
  reg [5:0]  ballyprev = 0;
  reg [31:0] ballcount = 0;

  always @(posedge clock) begin
    if(~game_active) begin
      oballx <= GAME_WIDTH/2;
      obally <= GAME_HEIGHT/2;
      ballxprev <= GAME_WIDTH / 2 + 1;
      ballyprev <= GAME_HEIGHT / 2 - 1;
    end else begin
      if(ballcount < speed) begin
        ballcount <= ballcount + 1;
      end else begin
        ballcount <= 0;

        ballxprev <= oballx;
        ballyprev <= obally;

        if ((ballxprev < oballx && oballx == GAME_WIDTH - 1) 
          || (ballxprev > oballx && oballx != 0))
          oballx <= oballx - 1;   
        else
          oballx <= oballx + 1;
        
        if ((ballyprev < obally && obally == GAME_HEIGHT - 1) 
          || (ballyprev > obally && obally != 0))
          obally <= obally - 1;   
        else
          obally <= obally + 1;
      end
    end
  end

  always @(posedge clock) begin
    if (icolcount == oballx && irowcount == obally)
      odrawball <= 1'b1;
    else
      odrawball <= 1'b0;
  end

 endmodule
