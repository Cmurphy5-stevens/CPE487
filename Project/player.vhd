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
    --healthbar signals
    CONSTANT HBarHeight : INTEGER := 15;
    SIGNAL Health : INTEGER := 600;
    SIGNAL h_on : std_logic;

	CONSTANT pwidth : INTEGER := 10;
	CONSTANT pheight : INTEGER := 10;
	
	--player signals
	SIGNAL p_x :INTEGER := 50;
	SIGNAL p_y : INTEGER := 500;
	SIGNAL pl_on : std_logic;
	SIGNAL jumping : STD_LOGIC;
	
	

	--enemy signals
	CONSTANT ewidth : INTEGER := 5;
	CONSTANT eheight : INTEGER := 5;
	SIGNAL edirect : std_logic; --movement direction
	SIGNAL e_x : STD_LOGIC_VECTOR(10 downto 0) := CONV_STD_LOGIC_VECTOR(700,11);
	SIGNAL e_y : STD_LOGIC_VECTOR(10 downto 0) := CONV_STD_LOGIC_VECTOR(500,11);
	SIGNAL e_on : STD_LOGIC;
	

	--platform signals
	
	SIGNAL plat_x : STD_LOGIC_VECTOR(10 downto 0) := CONV_STD_LOGIC_VECTOR(200,11);
	SIGNAL plat_y : STD_LOGIC_VECTOR(10 downto 0) := CONV_STD_LOGIC_VECTOR(460,11);
	CONSTANT platw :  STD_LOGIC_VECTOR(10 downto 0) := CONV_STD_LOGIC_VECTOR(200,11);
	CONSTANT plath :  STD_LOGIC_VECTOR(10 downto 0) := CONV_STD_LOGIC_VECTOR(10,11);
	
	SIGNAL plat_on : std_logic; --drawing singal for platform 0 above
	
	SIGNAL plat1_x : STD_LOGIC_VECTOR(10 downto 0) := CONV_STD_LOGIC_VECTOR(450,11);
	SIGNAL plat1_y : STD_LOGIC_VECTOR(10 downto 0) := CONV_STD_LOGIC_VECTOR(440,11);
	CONSTANT plat1w :  STD_LOGIC_VECTOR(10 downto 0) := CONV_STD_LOGIC_VECTOR(200,11);
	CONSTANT plat1h :  STD_LOGIC_VECTOR(10 downto 0) := CONV_STD_LOGIC_VECTOR(10,11);
	
	SIGNAL plat1_on : std_logic; --drawing singal for spawn platform 1 above
	
	SIGNAL plat2_x : STD_LOGIC_VECTOR(10 downto 0) := CONV_STD_LOGIC_VECTOR(600,11);
	SIGNAL plat2_y : STD_LOGIC_VECTOR(10 downto 0) := CONV_STD_LOGIC_VECTOR(400,11);
	CONSTANT plat2w :  STD_LOGIC_VECTOR(10 downto 0) := CONV_STD_LOGIC_VECTOR(200,11);
	CONSTANT plat2h :  STD_LOGIC_VECTOR(10 downto 0) := CONV_STD_LOGIC_VECTOR(10,11);
	
	SIGNAL plat2_on : std_logic; --drawing singal for spawn platform 2 above
	
	-- spawn platform below, always under player spawn
	SIGNAL platS_x : STD_LOGIC_VECTOR(10 downto 0) := CONV_STD_LOGIC_VECTOR(20,11);
	SIGNAL platS_y : STD_LOGIC_VECTOR(10 downto 0) := CONV_STD_LOGIC_VECTOR(510,11);
	CONSTANT platSw :  STD_LOGIC_VECTOR(10 downto 0) := CONV_STD_LOGIC_VECTOR(600,11);
	CONSTANT platSh :  STD_LOGIC_VECTOR(10 downto 0) := CONV_STD_LOGIC_VECTOR(10,11);
	
	SIGNAL platS_on : std_logic; --drawing singal for spawn platform above
	
	SIGNAL can_jump : std_logic; -- condition for player to be able to jump
	
--add a process to change the level # when the player moves to the edge, it can change the platoform position
--add a enemy hitboxes and and damage (partially done)
-- add more enemies(hitbox edits)
BEGIN
    red <= pl_on or e_on or h_on;
    green <= pl_on;
    blue <= pl_on or plat_on or platS_on or plat1_on or plat2_on;
    -- new platforms need new draw funciton, signals, and edits to checkjump
    platSdraw : process (pixel_row,pixel_col,platS_x,platS_y) IS
    begin
    if (pixel_col < platS_x + platSw) and (pixel_col > platS_x) and (pixel_row > platS_y) and (pixel_row < platSh + platS_y) THEN
	       platS_on <= '1';
	else
	       platS_on <= '0';
	end if;
	end process;
	
    platdraw : process (pixel_row,pixel_col,plat_x,plat_y) IS
    begin
    if (pixel_col < plat_x + platw) and (pixel_col > plat_x) and (pixel_row > plat_y) and (pixel_row < plath + plat_y) THEN
	       plat_on <= '1';
	else
	       plat_on <= '0';
	end if;
	end process;
	
	plat1draw : process (pixel_row,pixel_col,plat1_x,plat1_y) IS
    begin
    if (pixel_col < plat1_x + plat1w) and (pixel_col > plat1_x) and (pixel_row > plat1_y) and (pixel_row < plat1h + plat1_y) THEN
	       plat1_on <= '1';
	else
	       plat1_on <= '0';
	end if;
	end process;
    plat2draw : process (pixel_row,pixel_col,plat2_x,plat2_y) IS
    begin
    if (pixel_col < plat2_x + plat2w) and (pixel_col > plat2_x) and (pixel_row > plat2_y) and (pixel_row < plat2h + plat2_y) THEN
	       plat2_on <= '1';
	else
	       plat2_on <= '0';
	end if;
	end process;
    

    hdraw : process (Health,pixel_row,pixel_col) IS --draws healthbat on screen, uses Health signal as the width
    begin -- Draws healthbar starting at 40,40
        if ((pixel_col >= 40 - Health) OR (40 <= Health)) AND pixel_col <= 40 + Health AND pixel_row >= 40 - HBarHeight AND pixel_row <= 40 + HBarHeight THEN
	       h_on <= '1';
	   else
	       h_on <= '0';
	   end if;
    
    end process;
    
    hset : process IS --controlles palyer health
    begin
        wait until rising_edge(v_sync);
        
        -- (p_x + pwidth > e_x) and (p_x < e_x + ewidth) <- works for x-dimention hitboxes
        -- add y coordinate check
        if (p_x + pwidth > e_x) and (p_x < e_x + ewidth) then 
            Health <= Health - 100;
        end if;
        
    end process;
    
    pldraw : process (p_x,p_y,pixel_row, pixel_col) IS
	begin
	   if (pixel_col < p_x + pwidth) and (pixel_col > p_x) and (pixel_row > p_y) and (pixel_row < pheight + p_y) THEN
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
	checkjump : process is --bug, player cannot jump high enough to test platform......
	begin
	wait until rising_edge(v_sync);
	-- first checks if the player is on the ground, then if it is on a platform
	--(p_y > 500) or (p_y = 500) <- code for ground at 500, not needed with platforms as ground
	-- changed player drawing, and logic for plat0 (leftmost non-spawn platform) if works, redo the rest of the logic
	if (((p_y > plat_y - 10) and (p_y < plat_y)) and (p_x > plat_x and (p_x < plat_x + platw))) or (((p_y > platS_y - 15) and (p_y < platS_y)) and (p_x > platS_x and (p_x < platS_x + platSw))) or (((p_y > plat1_y - 15) and (p_y < plat1_y)) and (p_x > plat1_x and (p_x < plat1_x + plat1w))) or (((p_y > plat2_y - 15) and (p_y < plat2_y)) and (p_x > plat2_x and (p_x < plat2_x + plat2w))) then
	   can_jump <= '1'; --add a new check for each additional platform
	else
	   can_jump <= '0';
    end if;
	
	end process;
	jump : process is begin  -- allow player to jump if they are on the ground
	   wait until rising_edge(v_sync);
	   if ((btnu = '1') and (can_jump = '1')) THEN
	       
	       jumping <= '1';
	       p_y <= p_y - 100; -- makes jumping more smooth, and not a teleport (temp at 100 for testing)
	       wait for 1 sec;
	       p_y <= p_y - 30;
	       jumping <= '0';
	       wait for 1 sec;
	   
	   elsif (can_jump = '0') THEN -- gravity (only affects player when they do not meet jumping conditions)
	       
	       p_y <= p_y + 3;
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
	
	enemy : process is begin --move left and right between 200 and 750 x positions
	   wait until rising_edge(v_sync);
	   if edirect = '0' then 
	       e_x <= e_x - 3;
	   else
	       e_x <= e_x + 3;
	   end if;
	   
	   if e_x < 200 then --if less than 200, change direction
	       edirect <= not edirect;
	       e_x <= e_x + 5; --stop it from getting stuck?
	   elsif e_x > 750 then -- if greater than 750, change direction
	       edirect <= not edirect;
	       e_x <= e_x - 5; --stops it from getting stuck
	   end if;
	   
	   wait for 100 ms;
	   
	end process;
END behavioral;
	