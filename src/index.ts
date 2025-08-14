// src/index.ts - Main TypeScript entry point for PūteaMātai
// Part of T01.9b - TypeScript compilation implementation

import { greet, add } from '../tests/typescript-samples/demo';

console.log('🏗️  PūteaMātai TypeScript compilation is working!');
console.log(greet('PūteaMātai'));
console.log(`TypeScript math: ${add(5, 10)}`);

export { greet, add };