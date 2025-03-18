module main #(parameter VIDEO_WIDTH = 3,
              parameter TOTAL_COLS = 800,
              parameter TOTAL_ROWS = 525,
              parameter ACTIVE_COLS = 640,
              parameter ACTIVE_ROWS = 480)

  (input clock,
   input switch1,
   input switch2,
   input switch3,
   input switch4,
   output vga_hsync,
   output vga_vsync,
   output vgared0,
   output vgared1,
   output vgared2,
   output vgagreen0,
   output vgagreen1,
   output vgagreen2,
   output vgablue0,
   output vgablue1,
   output vgablue2);


  parameter idle = 2'b00;
  parameter running = 2'b01;
  parameter p1score = 2'b10;
  parameter p2score = 2'b11;

  parameter PADDLE_HEIGHT = 6;
  parameter SCORE_LIMIT = 3;
  parameter GAME_WIDTH = 40;

  reg [1:0] state = idle;

  wire [VIDEO_WIDTH-1:0] w_red, w_red_vsp;
  wire [VIDEO_WIDTH-1:0] w_green, w_green_vsp;
  wire [VIDEO_WIDTH-1:0] w_blue, w_blue_vsp;

  reg [9:0] col, row;

  reg [5:0] ballx, bally, 
            coldiv, rowdiv,
            p1y, p2y;
  
  reg [4:0] p1points, p2points;

  reg drawball, drawp1, drawp2;
  reg gameactive;
  reg dsw1, dsw2, dsw3, dsw4;

  wire w_hsync,     w_vsync,
       w_hsync_ball,  w_vsync_ball,
       w_hsync_vsp, w_vsync_vsp;
  
  vga_sync_pulses #(.TOTAL_COLS(TOTAL_COLS),
                    .TOTAL_ROWS(TOTAL_ROWS),
                    .ACTIVE_COLS(ACTIVE_COLS),
                    .ACTIVE_ROWS(ACTIVE_ROWS))
  vspi
    (.clock(clock),
     .ohsync(w_hsync),
     .ovsync(w_vsync),
     .col(col),
     .row(row));

  // Drop 4 LSBs, which effectively divides by 16
  assign coldiv = col[9:4];
  assign rowdiv = row[9:4]; 

/*  pattern_gen #(.VIDEO_WIDTH(VIDEO_WIDTH),
                .TOTAL_COLS(TOTAL_COLS),
                .TOTAL_ROWS(TOTAL_ROWS),
                .ACTIVE_COLS(ACTIVE_COLS),
                .ACTIVE_ROWS(ACTIVE_ROWS))
     pg
      (.clock(clock),
       .ihsync(w_hsync),
       .ivsync(w_vsync),
       .ohsync(w_hsync_tp),
       .ovsync(w_vsync_tp),
       .redv(w_red_tp),
       .grnv(w_green_tp),
       .bluv(w_blue_tp)); */

  ball  b
   (.clock(clock),
    .game_active(gameactive),
    .icolcount(coldiv),
    .irowcount(rowdiv),
    .odrawball(drawball),
    .oballx(ballx),
    .obally(bally));


  debounce d1
    (.clock(clock),
     .in(switch1),
     .out(dsw1));

  debounce d2
     (.clock(clock),
      .in(switch2),
      .out(dsw2));

  paddle #(.PADDLE_X(1),
           .PADDLE_HEIGHT(PADDLE_HEIGHT)) 
    p1
    (.clock(clock),
     .game_active(gameactive),
     .icolcount(coldiv),
     .irowcount(rowdiv),
     .iup(dsw1),
     .idown(dsw2),
     .odrawpaddle(drawp1),
     .opaddley(p1y));

  debounce d3
     (.clock(clock),
      .in(switch3),
      .out(dsw3));

  debounce d4
      (.clock(clock),
       .in(switch4),
       .out(dsw4));

  paddle #(.PADDLE_X(38),
           .PADDLE_HEIGHT(PADDLE_HEIGHT))
    p2
    (.clock(clock),
     .game_active(gameactive),
     .icolcount(coldiv),
     .irowcount(rowdiv),
     .iup(dsw3),
     .idown(dsw4),
     .odrawpaddle(drawp2),
     .opaddley(p2y));


    assign w_red = drawball | drawp1 | drawp2 ? 4'b1111 : 4'b0000;
    assign w_green = drawball | drawp1 | drawp2 ? 4'b1111 : 4'b0000;
    assign w_blue = drawball | drawp1 | drawp2 ? 4'b1111 : 4'b0000;


  vga_sync_porch #(.VIDEO_WIDTH(VIDEO_WIDTH),
                   .TOTAL_COLS(TOTAL_COLS),
                   .TOTAL_ROWS(TOTAL_ROWS),
                   .ACTIVE_COLS(ACTIVE_COLS),
                   .ACTIVE_ROWS(ACTIVE_ROWS))

        vsp
         (.clock(clock),
          .ihsync(w_hsync),
          .ivsync(w_vsync),
          .iredv(w_red),
          .igrnv(w_green),
          .ibluv(w_blue),
          .ohsync(w_hsync_vsp),
          .ovsync(w_vsync_vsp),
          .oredv(w_red_vsp),
          .ogrnv(w_green_vsp),
          .obluv(w_blue_vsp));


  
 always @(posedge clock) begin
   case (state)
     idle:
       begin
         if(dsw1 == 1'b1 && dsw2 == 1'b1 && dsw3 == 1'b1 && dsw4 == 1'b1) begin
           state <= running;
         end
       end
     running:
       begin
         if(ballx == 0 &&
            (bally < p1y ||
             bally > p1y + PADDLE_HEIGHT))
           state <= p2score;
         else if (ballx == GAME_WIDTH - 1 && 
                  (bally < p2y ||
                   bally > p2y + PADDLE_HEIGHT))
           state <= p1score; 
       end
     p1score:
       begin
         if(p1points == SCORE_LIMIT - 1) begin
           //p1 win
           p1points <= 0;
         end else begin
           p1points <= p1points + 1;
         end
         state <= idle;
       end
     p2score:
       begin
        if (p2points == SCORE_LIMIT - 1) begin
          //p2 win
          p2points <= 0;
        end else begin
          p2points <= p2points + 1;
        end
        state <= idle;
      end
   endcase
 end

  assign gameactive = (state == running) ? 1'b1 : 1'b0;

  assign vga_hsync = w_hsync_vsp;
  assign vga_vsync = w_vsync_vsp;

  assign vgared0 = w_red_vsp[0];
  assign vgared1 = w_red_vsp[1];
  assign vgared2 = w_red_vsp[2];

  assign vgagreen0 = w_green_vsp[0];
  assign vgagreen1 = w_green_vsp[1];
  assign vgagreen2 = w_green_vsp[2];

  assign vgablue0 = w_blue_vsp[0];
  assign vgablue1 = w_blue_vsp[1];
  assign vgablue2 = w_blue_vsp[2];

          //still need to finsih this off?
          //probably should rewrite a lot of this to be clearer
          //

endmodule
