LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY player IS
    PORT (
        v_sync : IN STD_LOGIC;
        pixel_row : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        pixel_col : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
	    btnl : IN STD_LOGIC; -- left button pressed
	    btnr : IN STD_LOGIC; -- right button pressed
	    btnu : IN std_logic;
        red : OUT STD_LOGIC;
        green : OUT STD_LOGIC;
        blue : OUT STD_LOGIC;
        Sp : IN STD_LOGIC_VECTOR (4 DOWNTO 0) -- player speed
);END player;

ARCHITECTURE Behavioral OF player IS
    CONSTANT HBarHeight : INTEGER := 15;
    SIGNAL Health : INTEGER := 100;
    SIGNAL h_on : std_logic;

	CONSTANT pwidth : INTEGER := 10;
	CONSTANT pheight : INTEGER := 10;
	
	CONSTANT ewidth : INTEGER := 5;
	CONSTANT eheight : INTEGER := 5;
	
	SIGNAL p_x :INTEGER := 50;
	SIGNAL p_y : INTEGER := 500;
	SIGNAL pl_on : std_logic;
	SIGNAL jumping : STD_LOGIC;
	
	

	
	SIGNAL e_x : STD_LOGIC_VECTOR(10 downto 0) := CONV_STD_LOGIC_VECTOR(800,11);
	SIGNAL e_y : STD_LOGIC_VECTOR(10 downto 0) := CONV_STD_LOGIC_VECTOR(500,11);
	SIGNAL e_on : STD_LOGIC;
	

	-- bg color is green

BEGIN
    red <= pl_on or e_on;
    green <= pl_on;
    blue <= pl_on;

    hdraw : process (Health) IS 
    begin -- Draws healthbar starting at 20,20
        if ((pixel_col >= 20 - Health) OR (20 <= Health)) AND pixel_col <= 20 + Health AND pixel_row >= 20 - HBarHeight AND pixel_row <= 20 + HBarHeight THEN
	       h_on <= '1';
	   else
	       h_on <= '0';
	   end if;
    
    end process;
    
    
    
    pldraw : process (p_x,p_y,pixel_row, pixel_col) IS
	begin
	   if ((pixel_col >= p_x - pwidth) OR (p_x <= pwidth)) AND pixel_col <= p_x + pwidth AND pixel_row >= p_y - pheight AND pixel_row <= p_y + pheight THEN
	       pl_on <= '1';
	   else
	       pl_on <= '0';
	   end if;
	     
	end process;
	pmove : process is begin
	   wait until rising_edge (v_sync);
	   if (btnl = '1') then -- move left
	       p_x <= p_x - 6;
	       wait for 10 ms;
	   end if;
	   if (btnr = '1') then -- move right
	       p_x <= p_x + 6;
	       wait for 10 ms;
	   end if;
	 
	   
	end process;
	jump : process is begin  -- allow player to jump if they are on the ground
	   wait until rising_edge(v_sync);
	   if ((btnu = '1') and (p_y > 500 or p_y = 500)) THEN
	       
	       jumping <= '1';
	       p_y <= p_y - 10; -- makes jumping more smooth, and not a teleport
	       wait for 20 ms; -- NEEDS TO JUMP HIGHER
	        p_y <= p_y - 20;
	       wait for 20 ms;
	        p_y <= p_y - 20;
	       wait for 20 ms;
	        p_y <= p_y - 20;
	       wait for 20 ms;
	        p_y <= p_y - 20;
	       wait for 20 ms;
	        p_y <= p_y - 20;
	       wait for 20 ms;
	       jumping <= '0';
	   
	   elsif (p_y < 500 and not jumping = '1') THEN -- gravity
	       
	       p_y <= p_y + 1;
	       wait for 150 ms; 
	   end if;
	end process;
	edraw : process(e_x, e_y, pixel_row, pixel_col) is begin -- inside () = sensitivity list
	   if ((pixel_col >= e_x - ewidth) OR (e_x <= ewidth)) AND pixel_col <= e_x + ewidth AND pixel_row >= e_y - eheight AND pixel_row <= e_y + eheight THEN
	       e_on <= '1';
	   else
	       e_on <= '0';
	   end if;
	end process;
	
	enemy : process is begin
	   wait until rising_edge(v_sync);
	   e_x <= e_x - 3;
	   wait for 100 ms;
	   
	end process;
END behavioral;
	