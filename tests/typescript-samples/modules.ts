// modules.ts - TypeScript module system demonstration
// Part of T01.9a - TypeScript compilation testing

import { greet, add } from './demo';
import { FinanceManager, User, TransactionType } from './types';

async function runDemo(): Promise<void> {
    console.log("=== TypeScript Module Demo ===");
    
    // Demo basic functions
    console.log(greet("Module System"));
    console.log(`Math result: ${add(10, 20)}`);
    
    // Demo finance manager
    const manager = new FinanceManager();
    const user: User = {
        id: 1,
        name: "Demo User",
        email: "demo@puteamatai.com",
        active: true
    };
    
    // Add some transactions
    manager.addTransaction({
        id: "demo-tx-1",
        type: "credit" as TransactionType,
        amount: 500,
        user
    });
    
    manager.addTransaction({
        id: "demo-tx-2", 
        type: "debit" as TransactionType,
        amount: 150,
        user
    });
    
    const balance = manager.getBalance(user.id);
    const transactions = manager.getUserTransactions(user.id);
    
    console.log(`User balance: $${balance}`);
    console.log(`Transaction count: ${transactions.length}`);
}

// Promise handling for async execution
runDemo().catch(error => {
    console.error("Demo failed:", error);
    process.exit(1);
});

// Export for module usage
export { runDemo };