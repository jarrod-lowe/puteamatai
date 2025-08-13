// T01.3a - Node.js dummy tests that FAIL to define test structure (Red phase)
// T01.3b will implement the code to make these pass (Green phase)

// TestAdd tests basic arithmetic - WILL FAIL until add() function is implemented
test('add function', () => {
    const result = add(2, 3);
    const expected = 5;
    expect(result).toBe(expected);
});

// TestMultiply tests multiplication - WILL FAIL until multiply() function is implemented  
test('multiply function', () => {
    const result = multiply(4, 5);
    const expected = 20;
    expect(result).toBe(expected);
});

// These functions don't exist yet - tests will fail until T01.3b implements them
// function add(a, b) { }
// function multiply(a, b) { }