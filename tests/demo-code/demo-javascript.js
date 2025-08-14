// demo-javascript.js - Demonstrates ESLint compliance

function demoFunction() {
  const x = 1;
  console.log(x);
}

function anotherGoodFunction() {
  if (true) {
    console.log('proper braces');
  }
  
  const z = {
    key: 'value',
  };
  
  return z;
}

function utilityFunction() {
  return 'this function is used';
}

export default { demoFunction, anotherGoodFunction, utilityFunction };