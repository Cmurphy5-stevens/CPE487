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
	SIGNAL Spawnx : INTEGER := 500;
	SIGNAL Spawny : INTEGER := 500;
	SIGNAL p_x :INTEGER := 50;
	SIGNAL p_y : INTEGER := 500;
	SIGNAL pl_on : std_logic;
	SIGNAL jumping : STD_LOGIC;
	SIGNAL pl_hit : std_logic;
	SIGNAL can_jump : std_logic; -- condition for player to be able to jump
	
	

	--enemy signals
	CONSTANT ewidth : INTEGER := 20;
	CONSTANT eheight : INTEGER := 20;
	SIGNAL edirect : std_logic; --movement direction
	SIGNAL e_x : STD_LOGIC_VECTOR(10 downto 0) := CONV_STD_LOGIC_VECTOR(400,11);
	SIGNAL e_y : STD_LOGIC_VECTOR(10 downto 0) := CONV_STD_LOGIC_VECTOR(400,11);
	SIGNAL e_on : STD_LOGIC;
	
	CONSTANT eXmin : INTEGER := 100; -- defines box for edges of enemy motion
	CONSTANT eXmax : INTEGER := 700;
	CONSTANT eYmin : INTEGER := 100;
	CONSTANT eYMax : INTEGER := 485;
	SIGNAL eYspeed : INTEGER := 5;
	SIGNAL eXspeed : INTEGER := 5;
	SIGNAL eXdirect : std_logic;
	SIGNAL eYdirect : std_logic; 
	
	--platform signals
	
	--platform 0
	SIGNAL plat_x : INTEGER := 100;
	SIGNAL plat_y : INTEGER := 410;
	CONSTANT platw :  STD_LOGIC_VECTOR(10 downto 0) := CONV_STD_LOGIC_VECTOR(200,11);
	CONSTANT plath :  STD_LOGIC_VECTOR(10 downto 0) := CONV_STD_LOGIC_VECTOR(10,11);
	
	SIGNAL plat_on : std_logic; 
	--platform 1
	SIGNAL plat1_x : INTEGER := 350;
	SIGNAL plat1_y : INTEGER := 390;
	CONSTANT plat1w :  STD_LOGIC_VECTOR(10 downto 0) := CONV_STD_LOGIC_VECTOR(200,11);
	CONSTANT plat1h :  STD_LOGIC_VECTOR(10 downto 0) := CONV_STD_LOGIC_VECTOR(10,11);
	
	SIGNAL plat1_on : std_logic; 
	--platform 2
	SIGNAL plat2_x : INTEGER := 600;
	SIGNAL plat2_y : INTEGER := 370;
	CONSTANT plat2w :  STD_LOGIC_VECTOR(10 downto 0) := CONV_STD_LOGIC_VECTOR(200,11);
	CONSTANT plat2h :  STD_LOGIC_VECTOR(10 downto 0) := CONV_STD_LOGIC_VECTOR(10,11);
	
	SIGNAL plat2_on : std_logic; 
	
	-- spawn platform 
	SIGNAL platS_x : INTEGER := 100;
	SIGNAL platS_y : INTEGER := 510;
	CONSTANT platSw :  STD_LOGIC_VECTOR(10 downto 0) := CONV_STD_LOGIC_VECTOR(600,11);
	CONSTANT platSh :  STD_LOGIC_VECTOR(10 downto 0) := CONV_STD_LOGIC_VECTOR(10,11);
	
	SIGNAL platS_on : std_logic; 
	
	--Portal signals
	
	SIGNAL portal_on : std_logic;
	SIGNAL pl_on_portal : std_logic;
	
	SIGNAL portal_x : INTEGER := 700; 
	SIGNAL portal_y : INTEGER := 300;
	CONSTANT portalw :  STD_LOGIC_VECTOR(10 downto 0) := CONV_STD_LOGIC_VECTOR(50,11);
	CONSTANT portalh :  INTEGER := 50;
	
	SIGNAL level : STD_LOGIC_VECTOR(10 downto 0) := conv_std_logic_vector(1,11);
	

   
-- health bar updates too fast


BEGIN
    
    red <= pl_on or e_on or h_on;
    green <= pl_on or portal_on;
    blue <= pl_on or plat_on or platS_on or plat1_on or plat2_on or portal_on;
    
    pl_hit <= pl_on and e_on; 
    levelcontroller : process is
    begin
        wait until rising_edge(v_sync);
        if (pl_on_portal = '1') then
            level <= level + 1;
            plat2_x <= 600;
            plat2_y <= 390;
            plat1_x <= 350;
            plat1_y <= 340;
            plat_x <= 100;
            plat_y <= 390;
            platS_x <= 120;
            platS_y <= 510;
            portal_x <= 425;
            portal_y <= 220;
            
            Spawnx <= 350;
           
             
            
            wait for 500ms;
            --move player and platforms to new locations, move platfrom before player
        end if;
           
        
    end process;
    portaldraw : process (pixel_row,pixel_col,portal_x,portal_y) IS
    begin
    if (pixel_col < portal_x + portalw) and (pixel_col > portal_x) and (pixel_row > portal_y) and (pixel_row < portalh + portal_y) THEN
	       portal_on <= '1';
	else
	       portal_on <= '0';
	end if;
	end process;
	
	checkportal : process (p_x, p_y) is
	begin
	if (p_x < portal_x + portalw) and (p_x > portal_x) and (p_y > portal_y) and (p_y < portalh + portal_y) then
	   pl_on_portal <= '1';
	else
	   pl_on_portal <= '0';
	end if;
	end process;
	
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
    

    hdraw : process (Health,pixel_row,pixel_col) IS --draws health on screen, uses Health signal as the width
    begin -- Draws healthbar starting at 40,40
        if ((pixel_col >= 40 - Health) OR (40 <= Health)) AND pixel_col <= 40 + Health AND pixel_row >= 40 - HBarHeight AND pixel_row <= 40 + HBarHeight THEN
	       h_on <= '1';
	   else
	       h_on <= '0';
	   end if;
    
    end process;
    
    hset : process IS --controlls palyer health
    begin
        if pl_hit = '1' then
            Health <= Health - 2; 
            wait for 500ms;
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
	       p_x <= p_x - 10;
	       wait for 10 ms;
	   end if;
	   if (btnr = '1') then -- move right
	       p_x <= p_x + 10;
	       wait for 10 ms;
	   end if;
	   --jumping and gravity below
	   if ((btnu = '1') and (can_jump = '1')) THEN
	       
	       jumping <= '1';
	       p_y <= p_y - 150; -- makes jumping more smooth, and not a teleport (temp at 100 for testing)
	       wait for 1 sec;
	       p_y <= p_y - 60;
	       jumping <= '0';
	       wait for 1 sec;
	   
	   elsif (can_jump = '0') THEN -- gravity (only affects player when they do not meet jumping conditions)
	       
	       p_y <= p_y + 3;
	       wait for 150 ms;
	   end if; 
	   
	   if (p_y > 600) then --resets player to spawn if they fall too low
	       p_x <= Spawnx;
	       p_y <= Spawny;
	   
	   end if;
	   
	   if (pl_on_portal = '1') then -- moves player to level spawn when level changes
	       wait for 50 ms;
	       p_x <= Spawnx;
	       p_y <= Spawny;
	       wait for 500 ms;
	       
	   end if;
	end process;
	
	
	checkjump : process is --bug, player cannot jump high enough to test platform......
	begin
	wait until rising_edge(v_sync);
	
	if (((p_y > plat_y - 10) and (p_y < plat_y)) and (p_x > plat_x and (p_x < plat_x + platw))) or (((p_y > platS_y - 15) and (p_y < platS_y)) and (p_x > platS_x and (p_x < platS_x + platSw))) or (((p_y > plat1_y - 15) and (p_y < plat1_y)) and (p_x > plat1_x and (p_x < plat1_x + plat1w))) or (((p_y > plat2_y - 15) and (p_y < plat2_y)) and (p_x > plat2_x and (p_x < plat2_x + plat2w))) then
	   can_jump <= '1'; --add a new check for each additional platform
	else
	   can_jump <= '0';
    end if;
	
	end process;
	edraw : process(e_x, e_y, pixel_row, pixel_col) is begin -- inside () = sensitivity list
	   if ((pixel_col >= e_x - ewidth) OR (e_x <= ewidth)) AND pixel_col <= e_x + ewidth AND pixel_row >= e_y - eheight AND pixel_row <= e_y + eheight THEN
	       e_on <= '1';
	   else
	       e_on <= '0';
	   end if;
	end process;
	
	enemy : process is begin -- controls enemy movement
	   wait until rising_edge(v_sync);
	   if eXdirect = '1' then
	       e_x <= e_x + eXspeed;
	   else
	       e_x <= e_x - eXspeed;
	   end if;
	   
	   if eYdirect = '1' then
	       e_y <= e_y + eYspeed;
	   else
	       e_y <= e_y - eYspeed;
	   end if;
	   
	   if (e_x < eXmin) then
	       eXdirect <= not eXdirect;
	       e_x <= e_x + eXspeed * 2;
	   elsif (e_x > eXmax) then
	       eXdirect <= not eXdirect;
	       e_x <= e_X - eXspeed * 2;
	   elsif (e_y < eYmin) then
	       eYdirect <= not eYdirect;
	       e_y <= e_y + eYspeed * 3;
	   elsif (e_y > eYmax) then
	       eYdirect <= not eYdirect;
	       e_y <= e_y - eYspeed * 3;
	  
	   end if;
	   
	   wait for 100 ms;
	   
	end process;
END behavioral;
	