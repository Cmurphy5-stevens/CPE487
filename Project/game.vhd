LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY game IS
    PORT (
        clk_in : IN STD_LOGIC; -- system clock
        VGA_red : OUT STD_LOGIC_VECTOR (3 DOWNTO 0); -- VGA outputs
        VGA_green : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        VGA_blue : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        VGA_hsync : OUT STD_LOGIC;
        VGA_vsync : OUT STD_LOGIC;
        Sp : IN STD_LOGIC_VECTOR (4 DOWNTO 0); -- player speed
        btnl : IN STD_LOGIC; -- left button pressed
        btnr : IN std_logic; -- left button pressed
        btnu : IN std_logic 
        
        );
END game;

architecture Behavioral OF game IS
	SIGNAL pxl_clk : STD_LOGIC := '0'; -- 25 MHz clock to VGA sync module
	SIGNAL S_red, S_green, S_blue : STD_LOGIC; --_VECTOR (3 DOWNTO 0);
    	SIGNAL S_vsync : STD_LOGIC;
    	SIGNAL S_pixel_row, S_pixel_col : STD_LOGIC_VECTOR (10 DOWNTO 0);

	COMPONENT player IS
        PORT (
            v_sync : IN STD_LOGIC;
            pixel_row : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
            pixel_col : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
            red : OUT STD_LOGIC;
            green : OUT STD_LOGIC;
            blue : OUT STD_LOGIC;
		    Sp : IN STD_LOGIC_VECTOR (4 DOWNTO 0); -- player speed
            btnl : IN STD_LOGIC; -- left button pressed
	        btnr : IN std_logic; -- right button pressed
	        btnu : IN std_logic
        );
	END COMPONENT;

	COMPONENT vga_sync IS
        PORT (
            pixel_clk : IN STD_LOGIC;
            red_in    : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            green_in  : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            blue_in   : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            red_out   : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            green_out : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            blue_out  : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            hsync : OUT STD_LOGIC;
            vsync : OUT STD_LOGIC;
            pixel_row : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
            pixel_col : OUT STD_LOGIC_VECTOR (10 DOWNTO 0)
        );
	END COMPONENT;

	COMPONENT clk_wiz_0 is
        PORT (
            clk_in1  : in std_logic;
            clk_out1 : out std_logic
        );
	END COMPONENT;
BEGIN
	pl : player
	PORT MAP(
		v_sync => S_vsync,
		pixel_row => S_pixel_row, 
        pixel_col => S_pixel_col,
		Sp => Sp,
		red => S_red, 
       	green => S_green, 
        blue => S_blue,
		btnl => btnl,
		btnr => btnr,
		btnu => btnu
	);
	
	vga_driver : vga_sync
    	PORT MAP(--instantiate vga_sync component
        	pixel_clk => pxl_clk, 
        	red_in => S_red & "000", 
        	green_in => S_green & "000", 
        	blue_in => S_blue & "000", 
        	red_out => VGA_red, 
        	green_out => VGA_green, 
        	blue_out => VGA_blue, 
        	pixel_row => S_pixel_row, 
        	pixel_col => S_pixel_col, 
        	hsync => VGA_hsync, 
        	vsync => S_vsync
    );
    VGA_vsync <= S_vsync; --connect output vsync

    clk_wiz_0_inst : clk_wiz_0
    PORT MAP (
      clk_in1 => clk_in,
      clk_out1 => pxl_clk
    );
END Behavioral;
	
	