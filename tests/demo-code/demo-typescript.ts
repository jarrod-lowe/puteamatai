// demo-typescript.ts - Demonstrates TypeScript and ESLint compliance
// Converted from demo-javascript.js as part of T01.9c

interface DemoObject {
  key: string;
}

function demoFunction(): void {
  const x: number = 1;
  console.log(x);
}

function anotherGoodFunction(): DemoObject {
  if (true) {
    console.log('proper braces');
  }
  
  const z: DemoObject = {
    key: 'value',
  };
  
  return z;
}

function utilityFunction(): string {
  return 'this function is used';
}

// Export with proper TypeScript typing
const demoExports = { demoFunction, anotherGoodFunction, utilityFunction };
export default demoExports;
export { demoFunction, anotherGoodFunction, utilityFunction, DemoObject };