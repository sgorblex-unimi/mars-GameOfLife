# Mars-GameOfLife [WIP]
Mars-GameOfLife is a MIPS assembly implementation of the popular cellular automation by Conway, specifically thought to run on the Mars emulator.

The project is still a Work in Progress. Currently there's a main game implementation, a title screen, a menu with a loadable preset and some procedures.


## What is Game of Life
[Game of Life] is a cellular automation devised by John Conway in 1970. It is a zero-player game, meaning that its evolution is determined by its initial state, requiring no further input. One interacts with the Game of Life by creating an initial configuration and observing how it evolves. It is Turing complete and can simulate a universal constructor or any other Turing machine. 

[Game of Life]: https://en.wikipedia.org/wiki/Conway's_Game_of_Life

### Rules
The game is represented by a grid of cells. The grid evolves its state at every iteration, with the following rules applying to the next state:
- Any live cell with two or three live neighbours survives.
- Any dead cell with three live neighbours becomes a live cell.
- All other live cells die in the next generation. Similarly, all other dead cells stay dead.


## What is Mars
The [Mars] program is a combined assembly language editor, assembler, simulator, and debugger for the MIPS processor. It was developed by Pete Sanderson and Kenneth Vollmar at Missouri State University.

Its last update is from 2014, which let us presume that its development is unfortunately discontinued.

[Mars]: https://courses.missouristate.edu/KenVollmar/MARS/index.htm


## What is Mars-GameOfLife
Mars-GameOfLife is a simple MIPS program which tries to implement the game and some additional features in the Bitmap Display Mars tool, while getting user input and outputing message in the MMIO Keyboard Simulator tool.

### How to install/use
- Download and install the [Mars] program (it requires Java).
- Clone the Mars-GameOfLife repo in your current directory with
	```sh
	git clone github.com/sgorblex/mars-gameoflife
	```
- Open Mars and open the file `src/main.asm` from the repo directory.
- Check the "Assemble all files in directory" option in the settings menu (menu bar).
- Assemble with the wrench icon and run with the green "play" icon.
- As the dialog pop-up window will tell you, you'll now need to open the Bitmap Display and the MMIO Keyboard Simulator tools from the tools Mars menu. After closing the pop up menu, set this configuration in the Bitmap Display tool (some of the options will be the default):
	- Unit Width in Pixels: 8
	- Unit Height in Pixels: 8
	- Display Width in Pixels: 512
	- Display Height in Pixels: 512
	- Base Address for Display: 0x10010000 (static data)

  The MMIO Keyboard Simulator won't need any tweak.
- Press "Connect to MIPS" on both tools
- Have fun!

### Features
- main menu with real time input detection
- 64x64 cell implementation of Game Of Life through a simulated bitmap display, with "pacman effect" (a boundary cell's next cell is the first on the other side)
- real time draw mode to create a starting pattern
- some presets (Gosper's Glider Gun)

### Notes
The program is a bit heavy, due to the fact that it is running on an emulator and it is relatively calculation-heavy. Because of that, some changes have been made:
- traditional nested loops to deal with 2-dimensional matrixes have been replaced by a linear approach. More info in `old_code/old_code_readme.md`
- the convention of spilling $ra is slightly modified: if a procedure call is in a loop, the push/pop of $ra is done before and after the loop to avoid doing it at every iteration.
- when multiple registers need to be spilled, we choose to use only one addi instruction and several sw/lw.

## What is pngToHex
pngToHex is a simple tool written in [Go] wich converts a png file in a text string containing the hexadecimal code of every pixel in the picture.

In Mars-GameOfLife it was used in order to easily print pictures on the bitmap display, wich requires to specify the exact 24bit-RGB color of every pixel. The transfer between the two programs was not automated, and pngToHex is fully indipendent.

More information in `pngToHex/pngToHex_readme.md`
