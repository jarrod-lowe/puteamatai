package main

import "testing"

// T01.3a - Go dummy tests that FAIL to define test structure (Red phase)
// T01.3b will implement the code to make these pass (Green phase)

// TestAdd tests basic arithmetic - WILL FAIL until add() function is implemented
func TestAdd(t *testing.T) {
	result := add(2, 3)
	expected := 5
	
	if result != expected {
		t.Errorf("add(2, 3) = %d, expected %d", result, expected)
	}
}

// TestSubtract tests subtraction - WILL FAIL until subtract() function is implemented  
func TestSubtract(t *testing.T) {
	result := subtract(5, 3)
	expected := 2
	
	if result != expected {
		t.Errorf("subtract(5, 3) = %d, expected %d", result, expected)
	}
}

// These functions don't exist yet - tests will fail until T01.3b implements them
// func add(a, b int) int
// func subtract(a, b int) int