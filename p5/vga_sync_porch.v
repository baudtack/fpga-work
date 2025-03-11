module vga_sync_porch #(parameter VIDEO_WIDTH = 3,
                        parameter TOTAL_COLS = 800,
                        parameter TOTAL_ROWS = 525,
                        parameter ACTIVE_COLS = 640,
                        parameter ACTIVE_ROWS = 480)
(input clock,
 input ihsync,
 input ivsync,
 input [VIDEO_WIDTH-1:0] iredv,
 input [VIDEO_WIDTH-1:0] igrnv,
 input [VIDEO_WIDTH-1:0] ibluv,
 output reg ohsync,
 output reg ovsync,
 output reg [VIDEO_WIDTH-1:0] oredv, 
 output reg [VIDEO_WIDTH-1:0] ogrnv,
 output reg [VIDEO_WIDTH-1:0] obluv
);

  parameter FRONT_PORCH_HORZ = 18;
  parameter BACK_PORCH_HORZ = 50;
  parameter FRONT_PORCH_VERT = 10;
  parameter BACK_PORCH_VERT = 33;

  wire w_hsync;
  wire w_vsync;

  wire [9:0] col;
  wire [9:0] row;

  reg [VIDEO_WIDTH-1:0] redv = 0;
  reg [VIDEO_WIDTH-1:0] grnv = 0;
  reg [VIDEO_WIDTH-1:0] bluv = 0;

  sync_to_count #(.TOTAL_COLS(TOTAL_COLS),
                  .TOTAL_ROWS(TOTAL_ROWS))
     stc (.clock(clock),
          .ihsync(ihsync),
          .ivsync(ivsync),
          .ohsync(w_hsync),
          .ovsync(w_vsync),
          .col(col),
          .row(row));

  always @(posedge clock) begin
    if((col < FRONT_PORCH_HORZ + ACTIVE_COLS) ||
       (col > TOTAL_COLS - BACK_PORCH_HORZ - 1))
      ohsync <= 1'b1;
    else 
      ohsync <= w_hsync;

    if((row < FRONT_PORCH_VERT + ACTIVE_ROWS) ||
       (row > TOTAL_ROWS - BACK_PORCH_VERT -1))
      ovsync <= 1'b1;
    else
      ovsync <= w_vsync;
  end
 
  always @(posedge clock) begin
    redv <= iredv;
    grnv <= igrnv;
    bluv <= ibluv;

    oredv <= redv;
    ogrnv <= grnv;
    obluv <= bluv;
  end

endmodule
