// File: parser.rs
use solang_parser::parse;
use solang_parser::pt;
use anyhow::{Result, anyhow};

pub struct ParsedContract {
    pub solidity_ast: pt::SourceUnit,
}

pub fn parse_contract(source: &str) -> Result<ParsedContract> {
    let (solidity_ast, _) = parse(source, 0).map_err(|e| anyhow!("Failed to parse Solidity code: {:#?}", e))?;
    Ok(ParsedContract { solidity_ast })
}

