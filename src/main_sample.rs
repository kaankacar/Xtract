use solang_parser::{parse, pt};
use std::fs::{self, File};
use std::io::{self, Write};
use std::path::Path;
use std::{env};

fn main() -> io::Result<()> {

    let args: Vec<String> = env::args().collect();
    if args.len() != 2 {
        eprintln!("Usage: {} <path_to_solidity_file>", args[0]);
        return Ok(());
    }

    let input_path = &args[1];

    let sol_code = fs::read_to_string(input_path)?;

    let parsed = parse(&sol_code, 0);
    match parsed {
        Ok((source_unit, _)) => {
            let rust_code = convert_solidity_to_rust(&source_unit);
            let output_path = Path::new(input_path).with_extension("rs");
            let mut output_file = File::create(output_path)?;
            output_file.write_all(rust_code.as_bytes())?;
            println!("Rust code written to {:?}", output_file);
        }
        Err(errors) => {
            eprintln!("Parsing errors:");
            for error in errors {
                eprintln!("{:?}", error);
            }
        }
    }

    Ok(())
}

fn convert_solidity_to_rust(source_unit: &pt::SourceUnit) -> String {
    let mut rust_code = String::new();
    rust_code.push_str("#![no_std]\n\nuse multiversx_sc::imports::*;\n\n");

    for item in &source_unit.0 {
        if let pt::SourceUnitPart::ContractDefinition(contract) = item {
            let contract_name = contract.name.as_ref().map_or("UnnamedContract", |id| id.name.as_str());
            rust_code.push_str(&format!("#[multiversx_sc::contract]\npub trait {} {{\n", contract_name));

            for part in &contract.parts {
                if let pt::ContractPart::VariableDefinition(var) = part {
                    if let pt::Expression::Type(_, ty) = &var.ty {
                        let rust_type = map_solidity_type_to_rust(ty);
                        let var_name = var.name.as_ref().map_or("unnamed", |id| id.name.as_str());
                        rust_code.push_str(&format!("    #[storage_mapper(\"{}\")]\n", var_name));
                        rust_code.push_str(&format!("    pub fn {}(&self) -> SingleValueMapper<{}>;\n\n", var_name, rust_type));
                    }
                }
            }

            rust_code.push_str("}\n\n");
            rust_code.push_str(&format!("impl {} {{\n", contract_name));
            
            for part in &contract.parts {
                if let pt::ContractPart::FunctionDefinition(func) = part {
                    let func_name = func.name.as_ref().map_or("unnamed", |id| id.name.as_str());
                    let params = get_function_parameters(&func.params);
                    let body = get_function_body(&func.body);
            
                    let annotation = match func.ty {
                        pt::FunctionTy::Function => "#[endpoint]",
                        pt::FunctionTy::Receive | pt::FunctionTy::Fallback => "#[payable]",
                        pt::FunctionTy::Constructor => "// Constructor (handled differently)",
                        pt::FunctionTy::Modifier => "// Modifier (requires manual conversion)",
                    };
            
                    rust_code.push_str(&format!("    {}\n", annotation));
                    rust_code.push_str(&format!("    pub fn {}(&self, {}) {{\n", func_name, params));
                    rust_code.push_str(&format!("        {}\n", body));
                    rust_code.push_str("    }\n\n");
                }
            }
            

            rust_code.push_str("}\n");
        }
    }

    rust_code
}

fn map_solidity_type_to_rust(ty: &pt::Type) -> String {
    match ty {
        pt::Type::Uint(_) => "u64".to_string(),
        pt::Type::Int(_) => "i64".to_string(),
        pt::Type::Bool => "bool".to_string(),
        pt::Type::Address => "ManagedAddress".to_string(),
        pt::Type::Bytes(_) => "ManagedBuffer".to_string(),
        pt::Type::String => "ManagedBuffer".to_string(),
        //pt::Type::Array(_, _) => "Vec<T>".to_string(),
        _ => "UnknownType".to_string(),
    }
}

fn get_function_parameters(params: &Vec<(pt::Loc, Option<pt::Parameter>)>) -> String {
    params
        .iter()
        .filter_map(|(_, param)| param.as_ref())
        .map(|param| {
            let param_name = param.name.as_ref().map_or("unnamed", |id| id.name.as_str());
            let param_type = if let pt::Expression::Type(_, ty) = &param.ty {
                map_solidity_type_to_rust(ty)
            } else {
                "UnknownType".to_string()
            };
            format!("{}: {}", param_name, param_type)
        })
        .collect::<Vec<_>>()
        .join(", ")
}

fn get_function_body(body: &Option<pt::Statement>) -> String {
    if let Some(statement) = body {
        match statement {
            pt::Statement::Block { statements, .. } => statements
                .iter()
                .map(|stmt| match stmt {
                    pt::Statement::Expression(_, expr) => match expr {
                        pt::Expression::Assign(_, lhs, rhs) => format!(
                            "{}.set({});",
                            convert_expression_to_rust(lhs),
                            convert_expression_to_rust(rhs)
                        ),
                        _ => "// Unsupported expression".to_string(),
                    },
                    pt::Statement::Return(_, expr) => {
                        if let Some(expr) = expr {
                            format!("return {}; // Convert expression", convert_expression_to_rust(expr))
                        } else {
                            "return;".to_string()
                        }
                    }
                    _ => "// Unsupported statement".to_string(),
                })
                .collect::<Vec<_>>()
                .join("\n        "),
            _ => "// Unsupported function body".to_string(),
        }
    } else {
        "// Empty function body".to_string()
    }
}

fn convert_expression_to_rust(expression: &pt::Expression) -> String {
    match expression {
        pt::Expression::Variable(id) => id.name.clone(),
        pt::Expression::NumberLiteral(_, num, _, _) => num.clone(),
        _ => "/* Unsupported expression */".to_string(),
    }
}
