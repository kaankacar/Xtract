use crate::{rust_ast::RustExpression, type_name::{ElementaryType, TypeName}};
use solang_parser::pt::{Expression, Type};
use anyhow::{Result, anyhow};


/*pub fn transform_visibility(visibility: Visibility) -> RustVisibility {
    match visibility {
        Visibility::Public(_) | Visibility::External(_) => RustVisibility::Public,
        Visibility::Private(_) | Visibility::Internal(_) => RustVisibility::Private,
    }
}*/

pub fn transform_expression(expr: &Expression) -> Result<RustExpression> {
    match expr {
        Expression::Variable(id) => Ok(RustExpression::Identifier(id.name.clone())),
        Expression::NumberLiteral(_, num, _, _) => Ok(RustExpression::NumberLiteral(num.clone())),
        Expression::StringLiteral(vals) => Ok(RustExpression::StringLiteral(
            vals.iter().map(|s| s.string.clone()).collect::<Vec<_>>().join("")
        )),
        Expression::BoolLiteral(_, value) => Ok(RustExpression::BoolLiteral(*value)),
        Expression::Add(_, left, right) => Ok(RustExpression::BinaryOperation {
            left: Box::new(transform_expression(left)?),
            operator: "+".to_string(),
            right: Box::new(transform_expression(right)?),
        }),
        Expression::Subtract(_, left, right) => Ok(RustExpression::BinaryOperation {
            left: Box::new(transform_expression(left)?),
            operator: "-".to_string(),
            right: Box::new(transform_expression(right)?),
        }),
        Expression::Multiply(_, left, right) => Ok(RustExpression::BinaryOperation {
            left: Box::new(transform_expression(left)?),
            operator: "*".to_string(),
            right: Box::new(transform_expression(right)?),
        }),
        Expression::Divide(_, left, right) => Ok(RustExpression::BinaryOperation {
            left: Box::new(transform_expression(left)?),
            operator: "/".to_string(),
            right: Box::new(transform_expression(right)?),
        }),
        _ => Err(anyhow!("Unsupported expression type {:?}", expr)),
    }
}

pub fn convert_expression_to_type(expr: &solang_parser::pt::Expression) -> Result<solang_parser::pt::Type, anyhow::Error> {
    match expr {
        solang_parser::pt::Expression::Type(_, ty) => Ok(ty.clone()),
        _ => Err(anyhow::anyhow!("Cannot convert expression to type")),
    }
}

pub fn transform_solidity_require(condition: &str, message: &str) -> String {
    format!("require!({}, {})", condition, message)
}

pub fn transform_solidity_revert(message: &str) -> String {
    format!("sc_panic!({})", message)
}

// Function to transform Solidity custom errors to MultiversX custom errors
pub fn transform_custom_error(error_name: &str, params: &[String]) -> String {
    let error_struct = format!(
        r#"
#[derive(TopEncode, TopDecode, TypeAbi)]
pub struct {}Error {{
    {}
}}

impl {}Error {{
    #[inline]
    fn throw() -> ! {{
        sc_panic!("{} error")
    }}
}}
"#,
        error_name,
        params.join(",\n    "),
        error_name,
        error_name
    );
    
    error_struct
}

// Helper function to handle Solidity-style events in MultiversX
pub fn transform_event_declaration(event_name: &str, params: &[(String, String, bool)]) -> String {
    let event_params = params.iter()
        .map(|(name, ty, indexed)| {
            if *indexed {
                format!("#[indexed] {}: {}", name, ty)
            } else {
                format!("{}: {}", name, ty)
            }
        })
        .collect::<Vec<_>>()
        .join(", ");
    
    format!("#[event(\"{}\")]\nfn {}_event(&self, {});", event_name, event_name, event_params)
}

// Helper function for struct definitions
pub fn transform_struct_definition(struct_name: &str, fields: &[(String, String)]) -> String {
    let struct_fields = fields.iter()
        .map(|(name, ty)| format!("pub {}: {}", name, ty))
        .collect::<Vec<_>>()
        .join(",\n    ");
    
    format!(
        r#"
#[derive(TypeAbi, TopEncode, TopDecode, NestedEncode, NestedDecode, ManagedVecItem)]
pub struct {}<M: ManagedTypeApi> {{
    {}
}}
"#,
        struct_name,
        struct_fields
    )
}

