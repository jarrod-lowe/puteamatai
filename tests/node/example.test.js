// T01.3a - Node.js dummy tests that FAIL to define test structure (Red phase)
// T01.3b - Now implementing functions to make tests pass (Green phase)

const { add, multiply } = require('./functions');

// TestAdd tests basic arithmetic - NOW PASSES with implemented add() function
test('add function', () => {
    const result = add(2, 3);
    const expected = 5;
    expect(result).toBe(expected);
});

// TestMultiply tests multiplication - NOW PASSES with implemented multiply() function  
test('multiply function', () => {
    const result = multiply(4, 5);
    const expected = 20;
    expect(result).toBe(expected);
});