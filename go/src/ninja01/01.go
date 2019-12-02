package main

import "fmt"

func main()  {
	x := 42
	y := "James Bond"
	z := true;

	fmt.Println(x, y, z)
	fmt.Printf("%#v\t %#v\t %#v\t\n", x, y, z)
	fmt.Printf("%T\n", z)
}