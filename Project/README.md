# VHDL Platformer

The project focuses of using the FPGA board and its VGA output to create a platforming game

## Instructions

 - The game uses three of the buttons on the FPGA board to control the character. BTNU (Up), BTNL(Left), BTNR(Right)

## Description

 The game has two levels. The level can be changed by reaching the cyan square. The goal is to finish the second 
 level without being hit by the red enemy. Hitting the enemy will deplete the healthbar at the top of the screen.
 The enemy is designed to bounce off of the edges of the screen to be more unpredictable to dodge. 

 The code for this project uses a combination of normal VHDL statements and sequential processes to control how
 the player and enemy behave. The are separate processes for handling movement and drawing the objects. Drawing 
 objects onto the screen uses the VGA driver that was part of the Lab3 and Lab6 pong games.

## Video of the first level

![](game.gif)
