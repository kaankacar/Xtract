mod parser;
mod transpiler;
mod helper_functions;
mod final_conversion;
mod type_mapper;
mod type_name;
mod rust_ast;
mod statement;
mod deploy;
use std::{env, fs::{self}, io::Write};


use crate::final_conversion::convert_solidity_to_rust;
use crate::deploy::deploy_to_multiversx;
use anyhow::Result;
use deploy::compile_to_wasm;

fn main() -> Result<()> {

    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        eprintln!("Usage: {} <input.sol>", args[0]);
        std::process::exit(1);
    }

    let input_file = &args[1];

    let solidity_code = fs::read_to_string(input_file)?;

    let rust_ast = convert_solidity_to_rust(&solidity_code)?;
    let output_file = format!("{}.rs", input_file.trim_end_matches(".sol"));
    let mut file = fs::File::create(&output_file)?;
    writeln!(file, "{}", rust_ast)?;

    let wasm_output = compile_to_wasm(&output_file)?;
    println!("{wasm_output}");
    let gas_limit = 20_000_000; 
    let pem_path = "./wallet.pem";
    let proxy_url = "https://devnet-gateway.multiversx.com";
    deploy_to_multiversx(&wasm_output, pem_path, proxy_url, gas_limit)?;
    Ok(())
}



