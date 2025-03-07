module pattern_gen
  #(parameter VIDEO_WIDTH = 3,
    parameter TOTAL_COLS = 800,
    parameter TOTAL_ROWS = 525,
    parameter ACTIVE_COLS = 640,
    parameter ACTIVE_ROWS = 480)
  (input clock,
   input ihsync,
   input ivsync,
   output reg ohsync = 0,
   output reg ovsync = 0,
   output reg [VIDEO_WIDTH-1:0] redv,
   output reg [VIDEO_WIDTH-1:0] grnv,
   output reg [VIDEO_WIDTH-1:0] bluv);

  wire wvsync;
  wire whsync;

  wire [VIDEO_WIDTH-1:0] red;
  wire [VIDEO_WIDTH-1:0] grn;
  wire [VIDEO_WIDTH-1:0] blu;


  wire [9:0] colcount;
  wire [9:0] rowcount;

  sync_to_count #(.TOTAL_COLS(TOTAL_COLS),
                  .TOTAL_ROWS(TOTAL_ROWS))
  sync (.clock(clock),
        .ihsync(ihsync),
        .ivsync(ivsync),
        .ohsync(whsync),
        .ovsync(wvsync),
        .col(colcount),
        .row(rowcount));


  always @(posedge clock) begin
    ohsync <= whsync;
    ovsync <= wvsync;
  end


  always @(posedge clock) begin
    redv <= (colcount < ACTIVE_COLS && rowcount < ACTIVE_ROWS) ? {VIDEO_WIDTH{1'b1}} : 0;
    grnv <= (colcount < ACTIVE_COLS && rowcount < ACTIVE_ROWS) ? {VIDEO_WIDTH{1'b1}} : 0;
    bluv <= (colcount < ACTIVE_COLS && rowcount < ACTIVE_ROWS) ? {VIDEO_WIDTH{1'b1}} : 0;
  end
endmodule
