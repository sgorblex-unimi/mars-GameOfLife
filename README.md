# Mars-GameOfLife
Mars-GameOfLife is a MIPS assembly implementation of the popular cellular automation by Conway, specifically thought to run on the Mars emulator.

The program is now full-featured but updates are very likely


## What is Game of Life
[Game of Life] is a cellular automation devised by John Conway in 1970. It is a zero-player game, meaning that its evolution is determined by its initial state, requiring no further input. One interacts with the Game of Life by creating an initial configuration and observing how it evolves. It is Turing complete and can simulate a universal constructor or any other Turing machine.

Way, way more on the [wiki]

[Game of Life]: https://en.wikipedia.org/wiki/Conway's_Game_of_Life
[wiki]: https://www.conwaylife.com/wiki/Main_Page

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
- Press a character/enter key on the input part of the MMIO tool (bottom rectangle) and have fun!

## Features
- Main menu with real time input detection
- 64x64 cell implementation of Game Of Life through a simulated bitmap display, with "pacman effect" (a boundary cell's next cell is the first on the other side)
- Real time draw mode to create a starting pattern
- Some presets (see under)
- Possibility to randomly choose a pattern

### Draw mode
Use the WASD keys (no capslock) to move the cursor. Green cursor means the pixel you're overing on is active, red cursor otherwise. Press enter to invert the activation state of the hovering pixel.

### Presets
By selecting load presets in the menu you can load one of the following presets:
- [Gosper's glider gun]
- Some [spaceships] ([glider], [big glider])
- Various [oscillators] ([pulsar], [figure eight], [toad], [worker bee], [blinker], [pinwheel], [star])
- [R-pentomino]

[Gosper's glider gun]: 	https://www.conwaylife.com/wiki/Gosper_glider_gun
[spaceships]: 		https://www.conwaylife.com/wiki/Spaceship
[glider]: 		https://www.conwaylife.com/wiki/Glider
[big glider]: 		https://www.conwaylife.com/wiki/Big_glider
[oscillators]: 		https://www.conwaylife.com/wiki/Oscillator
[pulsar]: 		https://www.conwaylife.com/wiki/Pulsar
[figure eight]: 	https://www.conwaylife.com/wiki/Figure_eight
[toad]: 		https://www.conwaylife.com/wiki/Toad
[worker bee]: 		https://www.conwaylife.com/wiki/Worker_bee
[blinker]: 		https://www.conwaylife.com/wiki/Blinker
[pinwheel]: 		https://www.conwaylife.com/wiki/Pinwheel
[star]: 		https://www.conwaylife.com/wiki/Star
[R-pentomino]: 		https://www.conwaylife.com/wiki/R-pentomino

### In game
Launch from the menu and that's it. Press any character key or enter to go back to the menu.

### Settings
Via the settings you can customize:
- The delay time, wich is added to the normal calculation time (which depending on your machine could be a lot) at every iteration
- The active pixels' color

### Notes
The program is a bit heavy, due to the fact that it is running on an emulator and it is relatively calculation-heavy (natively though it would be much, much faster). Because of that, some changes have been made:
- Traditional nested loops to deal with 2-dimensional matrixes (arrays) have been replaced by a linear approach. More info in `old_code/old_code_readme.md`
- If a procedure calls other procedures, the push of `$ra` to the stack (return address spilling) is done at the beginning and at the end of the entire procedure (not at every call)
- When multiple registers need to be spilled, we choose to use only one `addi` instruction and several `sw`/`lw`.
- We often use available registers to keep constants available through relatively large portions of code, in order not to load them from memory or with `li` pseudoinstructions every timewe make use of them.


## What is pngToHex
pngToHex is a simple tool written in [Go] wich converts a png file in a text string containing the hexadecimal code of every pixel in the picture.

In Mars-GameOfLife it was used in order to easily print pictures on the bitmap display, wich requires to specify the exact 24bit-RGB color of every pixel. The transfer between the two programs was not automated, and pngToHex is fully indipendent.

More information in `pngToHex/pngToHex_readme.md`

[Go]: https://golang.org
