// T01.3a - Node.js dummy tests that FAIL to define test structure (Red phase)
// T01.3b - Now implementing functions to make tests pass (Green phase)
// Converted to TypeScript as part of T01.9c

import { add, multiply } from './functions';

// TestAdd tests basic arithmetic - NOW PASSES with implemented add() function
test('add function', (): void => {
  const result: number = add(2, 3);
  const expected: number = 5;
  expect(result).toBe(expected);
});

// TestMultiply tests multiplication - NOW PASSES with implemented multiply() function  
test('multiply function', (): void => {
  const result: number = multiply(4, 5);
  const expected: number = 20;
  expect(result).toBe(expected);
});