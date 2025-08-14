// Package main demonstrates basic Go linting compliance
package main

import (
	"fmt"
	"os"
	"strings"
)

// DemoFunction demonstrates proper Go style and linting compliance
func DemoFunction() {
	x := 5
	fmt.Printf("Value: %d\n", x)
	
	// Proper error handling
	file, err := os.Open("example.txt")
	if err != nil {
		fmt.Printf("Error opening file: %v\n", err)
		return
	}
	defer file.Close()
	
	// Efficient string concatenation
	var result strings.Builder
	for i := 0; i < 100; i++ {
		result.WriteString("a")
	}
	fmt.Printf("Result length: %d\n", result.Len())
}

// goodFunctionName follows camelCase naming convention
func goodFunctionName() {
	fmt.Println("This function follows Go naming conventions")
}

func main() {
	DemoFunction()
	goodFunctionName()
}