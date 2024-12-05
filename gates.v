`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/03 17:23:48
// Design Name: 
// Module Name: stopwatch
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module gates
 (
    input wire clk,
    input wire rst,
    input wire hold,
	 input wire speed,
   
    output wire [8:0] led_out1,
    output wire [8:0] led_out2
);



// Define CNT_MAX as a parameter, not reg
parameter CNT_MAX_FAST = 5_999_999;
parameter CNT_MAX_SLOW = 11_999_999;

// Use a wire to select the appropriate CNT_MAX value based on speed
wire [24:0] CNT_MAX = (speed) ? CNT_MAX_SLOW : CNT_MAX_FAST;


reg [3:0] show1; // 代表个位数
reg [3:0] show2; // 代表十位数

reg [24:0] cnt;
reg flag;

always @(posedge clk or posedge rst or posedge hold)
    if (rst)
        cnt <= 0;
    else if (hold)
        cnt <= cnt;
    else if(cnt == CNT_MAX)
        cnt <= 0;
    else    
        cnt <= cnt+1;
        
always @(posedge clk or posedge rst)
    if (rst)
        flag <= 0;
    else if(cnt == CNT_MAX-1)
        flag <= 1;
    else 
        flag <= 0;
        
always @(posedge clk or posedge rst)
    if (rst) begin
        show1 <= 4'b0000;
        show2 <= 4'b0000;
    end
    else if (flag) begin
        // show1 (个位数)的逻辑
        if (show1 == 4'b1001)
            show1 <= 4'b0000;
        else
            show1 <= show1 + 1;

        // show2 (十位数)的逻辑
        if (show1 == 4'b1001) begin
            if (show2 == 4'b0110) begin
                show2 <= 4'b0000;
                show1 <= 4'b0000; // 重置show1和show2
            end    
            else
                show2 <= show2 + 1;
        end
    end
 

        
segment7 inst1
(
    .trans_in(show1),
    .led_out(led_out1)
);        
 
segment7 inst2
(
    .trans_in(show2),
    .led_out(led_out2)
);        
     
        
endmodule


module segment7
(
    input wire[3:0] trans_in,
    output wire [8:0] led_out
);

reg [8:0]seg[9:0];
initial begin
    seg[4'b0000] = 9'h3f;
    seg[4'b0001] = 9'h06;
    seg[4'b0010] = 9'h5b;
    seg[4'b0011] = 9'h4f;
    seg[4'b0100] = 9'h66;
    seg[4'b0101] = 9'h6d;
    seg[4'b0110] = 9'h7d;
    seg[4'b0111] = 9'h07;
    seg[4'b1000] = 9'h7f;
    seg[4'b1001] = 9'h6f;
end

assign led_out = seg[trans_in];
endmodule