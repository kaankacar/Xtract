use anyhow::{Context, Result};

use std::process::Command;

pub fn compile_to_wasm(input_file: &str) -> Result<String> {
    // Ensure that the environment is set up for WASM compilation
    let output_file = format!("{}.wasm", input_file.trim_end_matches(".rs"));

    println!("Compiling {} to WASM...", input_file);

    let status = Command::new("cargo")
        .args([
            "build",
            "--release",
            "--target",
            "wasm32-unknown-unknown",
        ])
        .status()
        .with_context(|| "Failed to execute Cargo for WASM compilation")?;

    if !status.success() {
        return Err(anyhow::anyhow!(
            "WASM compilation failed for file: {}",
            input_file
        ));
    }

    Ok(output_file)
}

pub fn deploy_to_multiversx(wasm_path: &str, pem_path: &str, proxy_url: &str, gas_limit: u64) -> Result<()> {
    println!("Deploying WASM contract to MultiversX...");

    let status = Command::new("mxpy")
        .args([
            "--send",
            "--pem",
            pem_path,
            "--wasm",
            wasm_path,
            "--gas-limit",
            &gas_limit.to_string(),
            "--proxy",
            proxy_url,
        ])
        .status()
        .with_context(|| "Failed to execute mxpy for contract deployment")?;

    if !status.success() {
        return Err(anyhow::anyhow!(
            "Deployment failed for WASM file: {}",
            wasm_path
        ));
    }

    Ok(())
}