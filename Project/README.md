# VHDL Platformer

The project focuses on using the FPGA board and its VGA output to create a platforming game

## Instructions:

 - The game uses three of the buttons on the FPGA board to control the character. BTNU (Jump), BTNL(Left), BTNR(Right)

 - The game has two levels, the level can be changed by reaching the cyan portal.
 - The goal is to finish the second level without being hit by the red enemy. 
 - Hitting the enemy will deplete the healthbar at the top of the screen.
 - The enemy is designed to bounce off of the edges of the screen to be more unpredictable to dodge. 

##Description:

 	The code for this project uses a combination of normal VHDL statements and sequential processes to control how
 the player, enemy, and levels behave. The are separate processes for handling movement and drawing of objects. 
 Drawing objects onto the screen uses the VGA driver that was included as a part of the Lab3 and Lab6 pong games. 
 The code is able to detect when the enemy contacts the player by reusing signals from the drawing processes.
 The signals that keep
 track of where the player and enemy are drawn can be checked to see if they are in overlapping positons. The game 
 is also able to switch the level by moving the platforms when the player constacts the cyan portal. Many of these
 conditions are tracked using boolean values to it is very easy to determine certain conditions, such as, when 
 the player is drawn, and what it is in contact with. This makes it very easy to trigger multiple processes at
 the same time, since separate processes can read the same signals.

	

## Video of the first level

![](game.gif)
