# FPGA LCD Display Controller

A Verilog project to control an alphanumeric LCD (16x2) using an FPGA board (DE2-115). The display shows a student name and ID number, with a blinking backlight effect every 0.5s after data is displayed.

## 👨‍💻 Author
**Le Minh Tri**  
MSSV: 22680551

https://github.com/minhtrile2004

## 📷 Demo


## 🛠️ Tools
- Quartus II (for synthesis & uploading)
- ModelSim (optional simulation)
- FPGA board: **DE2-115** (Cyclone IV)

## 📁 Files
- `LCD.v`: Main Verilog module controlling the LCD in 4-bit mode.

## 💡 Features
- LCD initialization
- ASCII character display (2 rows)
- Dynamic blinking effect (2Hz)
- Data: `LE MINH TRI` and `MSSV: 22680551`

## 📦 Usage
1. Open the project in **Quartus II**.
2. Compile and assign the top module to `LCD`.
3. Pin assignment:
   - `CLOCK_50` → Clock 50MHz
   - `LCD_DATA`, `LCD_EN`, `LCD_RS`, `LCD_RW`, `LCD_ON`, `LCD_BLON` → Connect to LCD module
4. Upload via USB Blaster to FPGA board.

## 📝 License
MIT License
