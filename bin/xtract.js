#!/usr/bin/env node

/**
 * XTract CLI - Solidity to MultiversX Rust Transpiler
 *
 * This is a Node.js wrapper that invokes the Python transpiler.
 * It provides a seamless npm-based installation experience.
 */

const { spawn } = require('child_process');
const path = require('path');
const fs = require('fs');

// Get the package root directory
const packageRoot = path.resolve(__dirname, '..');

// Try to find Python executable
function findPython() {
    const pythonCommands = ['python3', 'python'];

    for (const cmd of pythonCommands) {
        try {
            const result = require('child_process').spawnSync(cmd, ['--version'], {
                encoding: 'utf-8',
                stdio: 'pipe'
            });
            if (result.status === 0) {
                return cmd;
            }
        } catch (e) {
            // Command not found, try next
        }
    }
    return null;
}

// Main execution
function main() {
    const args = process.argv.slice(2);

    // Handle help flag
    if (args.includes('-h') || args.includes('--help')) {
        console.log(`
XTract - Solidity to MultiversX Rust Transpiler

Usage:
  xtract <input.sol> [output.rs]  Transpile a Solidity file
  xtract -v <input.sol>           Verbose mode (show diagnostics)
  xtract -q <input.sol>           Quiet mode

Options:
  -v, --verbose    Show detailed diagnostics
  -q, --quiet      Suppress non-error output
  -h, --help       Show this help message
  --version        Show version

Examples:
  xtract MyContract.sol              # Output to MyContract.rs
  xtract MyContract.sol output.rs    # Output to specified file
  xtract -v MyContract.sol           # Show diagnostics

For more information: https://github.com/XTract-build/Xtract
`);
        process.exit(0);
    }

    // Handle version flag
    if (args.includes('--version')) {
        const pkg = require('../package.json');
        console.log(`xtract v${pkg.version}`);
        process.exit(0);
    }

    // Find Python
    const python = findPython();
    if (!python) {
        console.error('Error: Python 3.9+ is required but not found.');
        console.error('Please install Python from https://www.python.org/downloads/');
        process.exit(1);
    }

    // Check if xtract module is available
    const xtractPath = path.join(packageRoot, 'xtract');
    if (!fs.existsSync(xtractPath)) {
        console.error('Error: XTract Python module not found.');
        console.error('Please reinstall the package: npm install -g xtract-cli');
        process.exit(1);
    }

    // Run the Python CLI
    const pythonArgs = ['-m', 'xtract.cli', ...args];

    const proc = spawn(python, pythonArgs, {
        cwd: packageRoot,
        stdio: 'inherit',
        env: {
            ...process.env,
            PYTHONPATH: packageRoot
        }
    });

    proc.on('error', (err) => {
        console.error(`Error running Python: ${err.message}`);
        process.exit(1);
    });

    proc.on('close', (code) => {
        process.exit(code || 0);
    });
}

main();
