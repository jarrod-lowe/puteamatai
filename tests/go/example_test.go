package main

import "testing"

// T01.3a - Go dummy tests that FAIL to define test structure (Red phase)
// T01.3b - Now implementing functions to make tests pass (Green phase)

// TestAdd tests basic arithmetic - NOW PASSES with implemented add() function
func TestAdd(t *testing.T) {
	result := add(2, 3)
	expected := 5
	
	if result != expected {
		t.Errorf("add(2, 3) = %d, expected %d", result, expected)
	}
}

// TestSubtract tests subtraction - NOW PASSES with implemented subtract() function  
func TestSubtract(t *testing.T) {
	result := subtract(5, 3)
	expected := 2
	
	if result != expected {
		t.Errorf("subtract(5, 3) = %d, expected %d", result, expected)
	}
}

// Local implementations for testing (minimal scaffold)
func add(a, b int) int {
	return a + b
}

func subtract(a, b int) int {
	return a - b
}