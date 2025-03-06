module main #(parameter VIDEO_WIDTH = 3,
              parameter TOTAL_COLS = 800,
              parameter TOTAL_ROWS = 525,
              parameter ACTIVE_COLS = 640,
              parameter ACTIVE_ROWS = 480)

  (input clock,
   output vgahsync,
   output vgavsync,
   output vgared0,
   output vgared1,
   output vgared2,
   output vgagreen0,
   output vgagreen1,
   output vgagreen2,
   output vgablue0,
   output vgablue1,
   output vgablue2);

  wire [VIDEO_WIDTH-1:0] w_red_tp, w_red_vsp;
  wire [VIDEO_WIDTH-1:0] w_green_tp, w_green_vsp;
  wire [VIDEO_WIDTH-1:0] w_blue_tp, w_blue_vsp;


  vga_sync_pulses #(.TOTAL_COLS(TOTAL_COLS),
                    .TOTAL_ROWS(TOTAL_ROWS),
                    .ACTIVE_COLS(ACTIVE_COLS),
                    .ACTIVE_ROWS(ACTIVE_ROWS))
  vspi
    (.clock(clock),
     .hsync(w_hsync),
     .vsync(w_vsync),
     .col(),
     .row());

  pattern_gen #(.VIDEO_WIDTH(VIDEO_WIDTH),
                .TOTAL_COLS(TOTAL_COLS),
                .TOTAL_ROWS(TOTAL_ROWS),
                .ACTIVE_COLS(ACTIVE_COLS),
                .ACTIVE_ROWS(ACTIVE_ROWS))
     pg
      (.clock(clock),
       .hsync(w_hsync),
       .vsync(w_vsync),
       .ohsync(w_hsync_tp),
       .ovsync(w_vsync_tp),
       .redv(w_red_tp),
       .grnv(w_green_tp),
       .bluv(w_blue_tp));


  vga_sync_porch #(.VIDEO_WIDTH(VIDEO_WIDTH),
                   .TOTAL_COLS(TOTAL_COLS),
                   .TOTAL_ROWS(TOTAL_ROWS),
                   .ACTIVE_COLS(ACTIVE_COLS),
                   .ACTIVE_ROWS(ACTIVE_ROWS))

        vsp
         (.clock(clock),
          .ihsync(w_hsync_tp),
          .ivsync(w_vsync_tp),
          .iredv(w_red_tp),
          .igrnv(w_green_tp),
          .ibluv(w_blue_tp),
          .hsync(w_hsync_vsp),
          .vsync(w_vsync_vsp),
          .oredv(w_red_vsp),
          .ogrnv(w_green_vsp),
          .obluv(w_blue_vsp));


  assign vgahsync = w_hsync_vsp;
  assign vgavsync = w_vsync_vsp;

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
