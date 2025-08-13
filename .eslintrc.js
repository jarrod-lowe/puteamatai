module.exports = {
  env: {
    browser: true,
    es2021: true,
    node: true,
    jest: true,
  },
  extends: [
    'eslint:recommended',
    '@typescript-eslint/recommended',
  ],
  parser: '@typescript-eslint/parser',
  parserOptions: {
    ecmaVersion: 'latest',
    sourceType: 'module',
  },
  plugins: [
    '@typescript-eslint',
  ],
  rules: {
    // Code style rules
    'indent': ['error', 2],
    'quotes': ['error', 'single'],
    'semi': ['error', 'always'],
    'comma-dangle': ['error', 'always-multiline'],
    
    // Variable rules  
    'no-unused-vars': 'error',
    'no-var': 'error',
    'prefer-const': 'error',
    
    // Best practices
    'no-console': 'warn',
    'no-debugger': 'error',
    'no-unreachable': 'error',
    'curly': ['error', 'all'],
    
    // ES6+ rules
    'arrow-spacing': 'error',
    'object-curly-spacing': ['error', 'always'],
    'array-bracket-spacing': ['error', 'never'],
    
    // Import/Export rules
    'no-duplicate-imports': 'error',
    
    // TypeScript specific overrides
    '@typescript-eslint/no-unused-vars': 'error',
    '@typescript-eslint/explicit-function-return-type': 'warn',
    '@typescript-eslint/no-explicit-any': 'warn',
    
    // Naming conventions
    'camelcase': ['error', { properties: 'never' }],
  },
  overrides: [
    {
      files: ['*.test.js', '*.test.ts', '*.spec.js', '*.spec.ts'],
      rules: {
        'no-console': 'off', // Allow console in test files
      },
    },
  ],
};