module LCD(
	input CLOCK_50,
	output LCD_ON, LCD_BLON, LCD_EN, LCD_RS, LCD_RW,
	inout [7:0] LCD_DATA
);

	reg [8:0] data;
	reg on, blon, en, rw;
	reg [5:0] state;
	reg [2:0] index;
	reg flag;
	reg [19:0] count_lcd;
	reg [19:0] countend;
	reg mode, r_l;
	reg blink_flag;
	reg [23:0] blink_cnt;

	assign LCD_ON = on;
	assign LCD_BLON = blon;
	assign LCD_EN = en;
	assign LCD_RS = data[8];	// Lấy bit cao nhất làm RS
	assign LCD_RW = rw;
	assign LCD_DATA = (!rw) ? data[7:0] : 8'hzz; // Nếu RW=0 thì ghi, RW=1 thì nhả bus

	initial begin
		on <= 1'b1; // Bật LCD 
		blon <= 1'b0; //Tắt đèn nền
		en <= 1'b0;
		rw <= 1'b0;
		data <= 9'b0;
		index <= 3'b0;
		flag <= 1'b1;
		count_lcd <= 20'd0;
		countend <= 20'hFFFFF;
		state <= 6'h00;
		blink_flag <= 1'b1; //LCD bắt đầu ở trạng thái "sáng"
		blink_cnt <= 24'd0;	//Đặt lại bộ đếm blink, chuẩn bị đếm thời gian để chớp tắt.
	end

	// Counter delay LCD
	always @(posedge CLOCK_50) begin
		if (flag) begin
			if (count_lcd < countend)
				count_lcd <= count_lcd + 1;
			else
				count_lcd <= 0;
		end
	end

	// Blink LCD ON/OFF sau khi hiện đủ nội dung
	always @(posedge CLOCK_50) begin
		if (state >= 6'h20) begin
			if (blink_cnt < 24'd25000000) // 0.5s với CLOCK_50 = 50MHz
				blink_cnt <= blink_cnt + 1;
			else begin
				blink_cnt <= 0;
				blink_flag <= ~blink_flag; // Đảo trạng thái ON/OFF
			end
		end
	end

	// Điều khiển LCD_EN
	always @(posedge CLOCK_50) begin
		if(state < 6'h29) begin
			case(index)
				3'h0: begin
					if(count_lcd == countend) begin
						flag <= 0;
						state <= state + 1;
						index <= index + 1;
					end
				end
				3'h1: index <= index + 1;
				3'h2: begin
					en <= 1;
					flag <= 1;
					countend <= 20'h10;
					index <= index + 1;
				end
				3'h3: begin
					if(count_lcd == countend) begin
						en <= 0;
						flag <= 1;
						countend <= 20'h40000;
						index <= 0;
					end
				end
				default: index <= 0;
			endcase
		end else begin
			on <= blink_flag; // Blink LCD sau khi hiện xong
		end
	end

	// Nội dung từng state LCD
	always @(posedge CLOCK_50) begin
		case(state)
			// Initialize LCD
			6'h00: data <= 9'h030;
			6'h01: data <= 9'h030;
			6'h02: data <= 9'h030;
			6'h03: data <= 9'h038;
			6'h04: data <= 9'h00C;
			6'h05: data <= 9'h001;
			6'h06: data <= 9'h006;

			// Set Address
			6'h07: data <= 9'h080;

        // Data Row 1 "LE MINH TRI"
        6'h08: data <= 9'h14C; // 'L'
        6'h09: data <= 9'h145; // 'E'
        6'h0A: data <= 9'h120; // ' '
        6'h0B: data <= 9'h14D; // 'M'
        6'h0C: data <= 9'h149; // 'I'
        6'h0D: data <= 9'h14E; // 'N'
        6'h0E: data <= 9'h148; // 'H'
        6'h0F: data <= 9'h120; // ' '
        6'h10: data <= 9'h154; // 'T'
        6'h11: data <= 9'h152; // 'R'
        6'h12: data <= 9'h149; // 'I'
        6'h13: data <= 9'h120; // ' '
        6'h14: data <= 9'h120; // ' '
        6'h15: data <= 9'h120; // ' '
        6'h16: data <= 9'h120; // ' '
        6'h17: data <= 9'h120; // ' '

            // Address
            6'h18: data <= 9'h0C0;

            // Data
            6'h19: data <= 9'h120; // ' '
				6'h1A: data <= 9'h14D; // 'M'
            6'h1B: data <= 9'h153; // 'S'
            6'h1C: data <= 9'h153; // 'S'
            6'h1D: data <= 9'h156; // 'V'
            6'h1E: data <= 9'h13A; // ':'
            6'h1F: data <= 9'h120; // ' '
            6'h20: data <= 9'h132; // '2'
            6'h21: data <= 9'h132; // '2'
            6'h22: data <= 9'h136; // '6'
            6'h23: data <= 9'h138; // '8'
            6'h24: data <= 9'h130; // '0'
            6'h25: data <= 9'h135; // '5'
            6'h26: data <= 9'h135; // '5s'
            6'h27: data <= 9'h131; // '1'
            6'h28: data <= 9'h120; // 
			default: data <= 9'h120; // Space
		endcase
	end

endmodule