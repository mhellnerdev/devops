package main

import "fmt"

//
func main() {
	circleLabs()
	counter()
	foobar()

}

func circleLabs() {
	fmt.Println("Circle Labs")
	fmt.Println("Automated Infrastructure Management")
	fmt.Println("Since 2020")
}

func counter() {
	for i := 0; i < 100; i++ {
		if i%25 == 0 {
			fmt.Println(i)
		}
	}

}

func foobar(){
	fmt.Println("exiting...")
}
