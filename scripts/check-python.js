#!/usr/bin/env node

/**
 * Post-install script to verify Python installation
 */

const { spawnSync } = require('child_process');

function findPython() {
    const pythonCommands = ['python3', 'python'];

    for (const cmd of pythonCommands) {
        try {
            const result = spawnSync(cmd, ['--version'], {
                encoding: 'utf-8',
                stdio: 'pipe'
            });
            if (result.status === 0) {
                const version = result.stdout.trim() || result.stderr.trim();
                return { cmd, version };
            }
        } catch (e) {
            // Command not found, try next
        }
    }
    return null;
}

function checkPythonVersion(versionStr) {
    const match = versionStr.match(/Python (\d+)\.(\d+)/);
    if (match) {
        const major = parseInt(match[1]);
        const minor = parseInt(match[2]);
        return major >= 3 && minor >= 9;
    }
    return false;
}

function main() {
    console.log('\n--- XTract Installation Check ---\n');

    const python = findPython();

    if (!python) {
        console.log('\x1b[33m%s\x1b[0m', 'Warning: Python not found!');
        console.log('');
        console.log('XTract requires Python 3.9+ to run.');
        console.log('Please install Python from: https://www.python.org/downloads/');
        console.log('');
        console.log('After installing Python, you can use xtract normally:');
        console.log('  xtract MyContract.sol');
        console.log('');
        return;
    }

    console.log(`Found: ${python.version} (${python.cmd})`);

    if (!checkPythonVersion(python.version)) {
        console.log('\x1b[33m%s\x1b[0m', 'Warning: Python 3.9+ is recommended.');
        console.log('Your version may work but some features might not be available.');
    } else {
        console.log('\x1b[32m%s\x1b[0m', 'Python version OK!');
    }

    // Check if click is installed
    const clickCheck = spawnSync(python.cmd, ['-c', 'import click'], {
        encoding: 'utf-8',
        stdio: 'pipe'
    });

    if (clickCheck.status !== 0) {
        console.log('');
        console.log('Installing Python dependencies...');

        const pipInstall = spawnSync(python.cmd, ['-m', 'pip', 'install', 'click>=8.1'], {
            encoding: 'utf-8',
            stdio: 'inherit'
        });

        if (pipInstall.status === 0) {
            console.log('\x1b[32m%s\x1b[0m', 'Dependencies installed successfully!');
        } else {
            console.log('\x1b[33m%s\x1b[0m', 'Warning: Could not install dependencies automatically.');
            console.log('Please run: pip install click>=8.1');
        }
    }

    console.log('');
    console.log('\x1b[32m%s\x1b[0m', 'XTract is ready to use!');
    console.log('');
    console.log('Quick start:');
    console.log('  xtract MyContract.sol        # Transpile a Solidity file');
    console.log('  xtract -v MyContract.sol     # With verbose diagnostics');
    console.log('  xtract --help                # Show all options');
    console.log('');
}

main();
