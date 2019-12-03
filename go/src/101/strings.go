package main

import "fmt"

func main() {
	var name = "Circle"

	fmt.Println(name)

	name = "Labs"

	fmt.Println(name)

	s := "Hello Circle Labs"
	fmt.Println(s)
	fmt.Printf("%T\n", s)

	bs := []byte(s)
	fmt.Println(bs)
	fmt.Printf("%T\n", bs)

for i := 0; i < len(s); i++ {
		fmt.Printf("%#U ", s[i])
	}
}
