/**
 * XTract - Solidity to MultiversX Rust Transpiler
 *
 * This module provides programmatic access to the XTract transpiler.
 */

const { spawn, spawnSync } = require('child_process');
const path = require('path');
const fs = require('fs');

const packageRoot = path.resolve(__dirname, '..');

/**
 * Find available Python executable
 * @returns {string|null} Python command or null if not found
 */
function findPython() {
    const pythonCommands = ['python3', 'python'];

    for (const cmd of pythonCommands) {
        try {
            const result = spawnSync(cmd, ['--version'], {
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

/**
 * Transpile a Solidity file to MultiversX Rust
 *
 * @param {string} inputPath - Path to the Solidity file
 * @param {string} [outputPath] - Optional output path (defaults to input with .rs extension)
 * @param {Object} [options] - Transpilation options
 * @param {boolean} [options.verbose] - Enable verbose output
 * @param {boolean} [options.quiet] - Enable quiet mode
 * @returns {Promise<{success: boolean, output: string, error: string}>}
 */
async function transpile(inputPath, outputPath, options = {}) {
    return new Promise((resolve, reject) => {
        const python = findPython();
        if (!python) {
            reject(new Error('Python 3.9+ is required but not found'));
            return;
        }

        const args = ['-m', 'xtract.cli'];

        if (options.verbose) {
            args.push('-v');
        }
        if (options.quiet) {
            args.push('-q');
        }

        args.push(inputPath);

        if (outputPath) {
            args.push(outputPath);
        }

        let stdout = '';
        let stderr = '';

        const proc = spawn(python, args, {
            cwd: packageRoot,
            env: {
                ...process.env,
                PYTHONPATH: packageRoot
            }
        });

        proc.stdout.on('data', (data) => {
            stdout += data.toString();
        });

        proc.stderr.on('data', (data) => {
            stderr += data.toString();
        });

        proc.on('error', (err) => {
            reject(err);
        });

        proc.on('close', (code) => {
            resolve({
                success: code === 0,
                output: stdout,
                error: stderr,
                exitCode: code
            });
        });
    });
}

/**
 * Transpile Solidity code directly (without file I/O)
 *
 * @param {string} solidityCode - Solidity source code
 * @returns {Promise<{success: boolean, rustCode: string, diagnostics: string[]}>}
 */
async function transpileCode(solidityCode) {
    return new Promise((resolve, reject) => {
        const python = findPython();
        if (!python) {
            reject(new Error('Python 3.9+ is required but not found'));
            return;
        }

        // Create a Python script to transpile from stdin
        const pythonScript = `
import sys
sys.path.insert(0, '${packageRoot}')
from xtract.transpiler import Transpiler

solidity_code = sys.stdin.read()
transpiler = Transpiler()
result = transpiler.convert_with_diagnostics(solidity_code)

print("---RUST_CODE_START---")
print(result.code)
print("---RUST_CODE_END---")

if result.warnings:
    print("---DIAGNOSTICS_START---")
    for w in result.warnings:
        print(f"{w.severity}: {w.message}")
    print("---DIAGNOSTICS_END---")

sys.exit(0 if result.success else 1)
`;

        let stdout = '';
        let stderr = '';

        const proc = spawn(python, ['-c', pythonScript], {
            cwd: packageRoot,
            env: {
                ...process.env,
                PYTHONPATH: packageRoot
            }
        });

        proc.stdin.write(solidityCode);
        proc.stdin.end();

        proc.stdout.on('data', (data) => {
            stdout += data.toString();
        });

        proc.stderr.on('data', (data) => {
            stderr += data.toString();
        });

        proc.on('error', (err) => {
            reject(err);
        });

        proc.on('close', (code) => {
            // Parse output
            let rustCode = '';
            let diagnostics = [];

            const codeMatch = stdout.match(/---RUST_CODE_START---\n([\s\S]*?)\n---RUST_CODE_END---/);
            if (codeMatch) {
                rustCode = codeMatch[1];
            }

            const diagMatch = stdout.match(/---DIAGNOSTICS_START---\n([\s\S]*?)\n---DIAGNOSTICS_END---/);
            if (diagMatch) {
                diagnostics = diagMatch[1].split('\n').filter(line => line.trim());
            }

            resolve({
                success: code === 0,
                rustCode,
                diagnostics,
                error: stderr
            });
        });
    });
}

/**
 * Check if XTract is properly installed
 * @returns {boolean}
 */
function isInstalled() {
    const python = findPython();
    if (!python) return false;

    const xtractPath = path.join(packageRoot, 'xtract');
    return fs.existsSync(xtractPath);
}

/**
 * Get version information
 * @returns {string}
 */
function getVersion() {
    const pkg = require('../package.json');
    return pkg.version;
}

module.exports = {
    transpile,
    transpileCode,
    isInstalled,
    getVersion,
    findPython
};
