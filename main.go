package main

// T01.3b - Minimal Go scaffolds to make tests pass (Green Phase)

// add implements basic addition to make TestAdd pass
func add(a, b int) int {
	return a + b
}

// subtract implements basic subtraction to make TestSubtract pass
func subtract(a, b int) int {
	return a - b
}

func main() {
	// Minimal main function for Go module - demonstrate functions work
	result1 := add(2, 3)
	result2 := subtract(5, 3)
	_ = result1 // Use results to avoid unused variable warnings
	_ = result2
}
