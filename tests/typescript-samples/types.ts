// types.ts - TypeScript type system demonstration
// Part of T01.9a - TypeScript compilation testing

interface User {
    id: number;
    name: string;
    email: string;
    active?: boolean;
}

type TransactionType = 'debit' | 'credit';

interface Transaction {
    id: string;
    type: TransactionType;
    amount: number;
    user: User;
    timestamp: Date;
}

class FinanceManager {
    private transactions: Transaction[] = [];

    addTransaction(transaction: Omit<Transaction, 'timestamp'>): void {
        const fullTransaction: Transaction = {
            ...transaction,
            timestamp: new Date()
        };
        this.transactions.push(fullTransaction);
    }

    getBalance(userId: number): number {
        return this.transactions
            .filter(t => t.user.id === userId)
            .reduce((balance, t) => {
                return t.type === 'credit' ? balance + t.amount : balance - t.amount;
            }, 0);
    }

    getUserTransactions(userId: number): Transaction[] {
        return this.transactions.filter(t => t.user.id === userId);
    }
}

// Export for module usage
export { User, Transaction, TransactionType, FinanceManager };

// Main execution for standalone testing
if (require.main === module) {
    const manager = new FinanceManager();
    const user: User = { id: 1, name: "Test User", email: "test@example.com" };
    
    manager.addTransaction({
        id: "tx1",
        type: "credit",
        amount: 100,
        user
    });
    
    console.log(`Balance: ${manager.getBalance(1)}`);
}