// T01.3b - Minimal Node.js functions to make tests pass (Green Phase)
// Converted to TypeScript as part of T01.9c

// add implements basic addition to make add test pass
function add(a: number, b: number): number {
    return a + b;
}

// multiply implements basic multiplication to make multiply test pass  
function multiply(a: number, b: number): number {
    return a * b;
}

export {
    add,
    multiply
};