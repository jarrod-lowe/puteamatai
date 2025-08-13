// bad-javascript.js - Intentionally bad JavaScript code to test ESLint rules

function badFunction() {
var x = 1;  // Should use let/const instead of var
var y = 2;  // Unused variable
console.log(x)  // Missing semicolon
}

function   another_bad_function   () {  // Bad spacing and naming
    if (true) console.log("no braces");  // Missing braces
    
    let z = {
        "key": "value"  // Unnecessary quotes on key
    }
    
    return z
}  // Missing semicolon

// Unused function
function unusedFunction() {
    return "never called";
}

export default { badFunction, another_bad_function };