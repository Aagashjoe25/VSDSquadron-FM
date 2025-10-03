module top(
	output wire led_red,
	output wire led_green,
	output wire led_blue,
	input wire blink_enable,
	input wire clk_12Mhz
);
	// clock divider circuit to generate 1hz from 12Mhz
	reg [23:0] counter=0;
	reg clk_1hz=0;

	always @(posedge clk_12Mhz) begin
		if(counter==5999999) begin
			counter<=0;
			clk_1hz<= ~clk_1hz;
		end
	       	else counter<= counter+1;
	end
        
        wire pwm_blue;
	assign pwm_blue= (blink_enable==1)? clk_1hz:1;
	// using inbuilt rgb driver primitive's pwm signal for blinking
	SB_RGBA_DRV rgb_driver(
	       .RGBLEDEN(1),
       	       .RGB0PWM (0),       //red
	       .RGB1PWM (0),       //green
               .RGB2PWM (pwm_blue), //blue
               .CURREN  (1),
	       .RGB0    (led_red),
	       .RGB1    (led_green),
	       .RGB2    (led_blue)
       );

       // set the brightness ranging from 1 to 63
       defparam rgb_driver.RGB0_CURRENT = "0b000001";
       defparam rgb_driver.RGB1_CURRENT = "0b000001";
       defparam rgb_driver.RGB2_CURRENT = "0b000001";
endmodule	
