// bad-go.go - Intentionally bad Go code to test GolangCI-Lint rules
package main

import (
	"fmt"
	"os"     // Unused import
	"strings" // Unused import
)

// BadFunction has poor naming and style
func BadFunction() {
	var x int = 5 // Redundant type declaration
	var y = 10    // Unused variable
	
	fmt.Printf("Value: %d\n", x) // Should use fmt.Print for simple cases
	
	// Bad error handling
	file, err := os.Open("nonexistent.txt")
	if err != nil {
		// Empty error handling
	}
	file.Close() // Potential nil pointer dereference
	
	// Inefficient string concatenation in loop
	result := ""
	for i := 0; i < 100; i++ {
		result = result + "a" // Should use strings.Builder
	}
	
	// Unreachable code
	return
	fmt.Println("This will never execute")
}

// unexported function with poor naming
func bad_function_name() { // Should be camelCase
	// Function does nothing useful
}

func main() {
	BadFunction()
	// bad_function_name is never called (unused)
}