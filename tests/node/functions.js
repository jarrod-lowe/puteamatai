// T01.3b - Minimal Node.js functions to make tests pass (Green Phase)

// add implements basic addition to make add test pass
function add(a, b) {
    return a + b;
}

// multiply implements basic multiplication to make multiply test pass  
function multiply(a, b) {
    return a * b;
}

module.exports = {
    add,
    multiply
};