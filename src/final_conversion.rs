use crate::transpiler::transform_with_attributes;
use anyhow::Result;

pub fn convert_solidity_to_rust(source: &str) -> Result<String> {
    let parsed_contract = crate::parser::parse_contract(source)?;
    let rust_ast = transform_with_attributes(parsed_contract)?;
    
    Ok(rust_ast)
}