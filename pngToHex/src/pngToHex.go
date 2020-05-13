package main

import (
	"flag"
	"fmt"
	"image"
	_ "image/png"
	"log"
	"os"
)

var toFile = flag.String("tofile", "", "Redirects the output to the specified file (default: stdin)")

func main() {
	// set up log
	home := os.Getenv("HOME")
	logFile, err := os.OpenFile(home+"/.local/share/png-to-hex.log", os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
	if err != nil {
		fmt.Printf("Couldn't create logfile: %v\n", err)
	}
	defer logFile.Close()
	log.SetOutput(logFile)
	log.Println("Log started")

	// parsing options (flags)
	flag.Parse()

	// open png
	if len(flag.Args()) != 1 {
		fmt.Println("Insert a png path as argument")
		log.Fatal("No arguments")
	}
	reader, err := os.Open(flag.Args()[0])
	if err != nil {
		log.Fatal(err)
	}
	defer reader.Close()

	// decode png
	pic, _, err := image.Decode(reader)
	if err != nil {
		log.Fatal(err)
	}
	log.Println("png decoded")

	if *toFile != "" {
		fileOut(pic, *toFile)
	} else {
		stdout(pic)
	}
}

func stdout(pic image.Image) {
	// get picture bounds
	bounds := pic.Bounds()

	log.Println("Printing colors to stdout")
	for y := bounds.Min.Y; y < bounds.Max.Y; y++ {
		for x := bounds.Min.X; x < bounds.Max.X; x++ {
			// r, g, b, a := pic.At(x, y).RGBA()
			r, g, b, _ := pic.At(x, y).RGBA() // ignoring A field
			// fmt.Printf("0x%.2x%.2x%.2x%.2x ", r>>8, g>>8, b>>8, a>>8)
			fmt.Printf("0x%.2x%.2x%.2x ", r>>8, g>>8, b>>8)
		}
	}
}

func fileOut(pic image.Image, fileName string) {
	outputFile, err := os.Create(fileName)
	if err != nil {
		log.Fatal(err)
	}

	// get picture bounds
	bounds := pic.Bounds()

	log.Println("Printing colors to file", fileName)
	for y := bounds.Min.Y; y < bounds.Max.Y; y++ {
		for x := bounds.Min.X; x < bounds.Max.X; x++ {
			// r, g, b, a := pic.At(x, y).RGBA()
			r, g, b, _ := pic.At(x, y).RGBA() // ignoring A field
			// fmt.Printf("0x%.2x%.2x%.2x%.2x ", r>>8, g>>8, b>>8, a>>8)
			fmt.Fprintf(outputFile, "0x%.2x%.2x%.2x ", r>>8, g>>8, b>>8)
		}
	}
}
