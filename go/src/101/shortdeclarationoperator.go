package main

import (
	"fmt"
)

func main() {
	x := 42 // cannot use short declaration operator outside of function
	fmt.Println(x)
	x = 99
	fmt.Println(x)
	y := 100 + 70
	fmt.Println(y)
	z := "Bond, James"
	fmt.Println(z)

}
