// demo.ts - Basic TypeScript demonstration
// Part of T01.9a - TypeScript compilation testing

function greet(name: string): string {
    return `Hello, ${name}!`;
}

function add(a: number, b: number): number {
    return a + b;
}

// Export for module usage
export { greet, add };

// Main execution for standalone testing
if (require.main === module) {
    console.log(greet("TypeScript"));
    console.log(`2 + 3 = ${add(2, 3)}`);
}