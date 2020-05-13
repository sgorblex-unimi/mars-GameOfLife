## What is pngToHex?
pngToHex is a simple tool written in Go wich converts a png file in a text string containing the hexadecimal code of every pixel in the picture.

In Mars-GameOfLife it was used in order to easily print pictures on the bitmap display, wich requires to specify the exact 24bit-RGB color of every pixel. The transfer between the two programs was not automated, and pngToHex is fully indipendent.

If you want to use the program, install [Go] and compile it with:
```sh
go build pngToHex.go
```

Then run
```sh
./pngToHex path/to/picture.png
```
for a standard output print or
```sh
./pngToHex -tofile path/to/output/file.txt path/to/picture.png
```
for output to a specified file.

[Go]: https://golang.org/
