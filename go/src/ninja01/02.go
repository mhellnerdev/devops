package main

import "fmt"

var x int
var y string = "emptyString"
var z bool

func main()  {
	fmt.Println(x)
	fmt.Println(y)
	fmt.Println(z)

	fmt.Printf("%T\n%T\n%T\n", x,y,z)
}