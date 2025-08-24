use crate::helper_functions::transform_expression;
use crate::rust_ast::{RustExpression, RustNode, RustVisibility};
use anyhow::{anyhow, Result};
use inflector::Inflector;
use solang_parser::pt;


// Helper function to check for `return` statements in the body
pub fn statements_contains_return(statements: &[pt::Statement]) -> bool {
    statements
        .iter()
        .any(|stmt| matches!(stmt, pt::Statement::Return(_, _)))
}
pub fn transform_statements(statements: &[pt::Statement]) -> Result<Vec<RustNode>> {
    statements.iter().map(transform_statement).collect()
}

pub fn transform_statement(stmt: &pt::Statement) -> Result<RustNode> {
    match stmt {
        pt::Statement::Block { statements, .. } => {
            let body = statements
                .iter()
                .map(transform_statement)
                .collect::<Result<Vec<_>>>()?;
            Ok(RustNode::Function {
                name: "block".to_string(),
                params: vec![],
                returns: None,
                body,
                visibility: RustVisibility::Private,
                is_endpoint: false,
                is_view: false,
            })
        }

        pt::Statement::Emit(_, function_call) => {
            if let pt::Expression::FunctionCall(_, function, args) = function_call {
                let event_name = match function.as_ref() {
                    pt::Expression::Variable(identifier) => identifier.name.clone(),
                    _ => return Err(anyhow!("Unsupported function in Emit")),
                };
                let transformed_args = args
                    .iter()
                    .map(transform_expression) // Transform each argument
                    .collect::<Result<Vec<_>>>()?;
                Ok(RustNode::Expression(RustExpression::FunctionCall {
                    function: Box::new(RustExpression::Identifier(format!(
                        "self.{}_event",
                        event_name.to_snake_case()
                    ))),
                    arguments: transformed_args,
                }))
            } else {
                Err(anyhow!("Unsupported Emit statement"))
            }
        }
        
        
        pt::Statement::Expression(_, expr) => {
            match expr {
                // Match an assignment expression
                pt::Expression::Assign(_, left, right) => Ok(RustNode::Assignment {
                    target: Box::new(transform_expression(left)?), // Ensure `left` is passed to `transform_expression`
                    value: Box::new(transform_expression(right)?), // Ensure `right` is passed to `transform_expression`
                }),

                // Match a function call expression
                pt::Expression::FunctionCall(_, function, args) => {
                    let func_name = match function.as_ref() {
                        pt::Expression::Variable(id) => id.name.clone(),
                        _ => return Err(anyhow!("Unsupported function call")),
                    };
                    let transformed_args = args
                        .iter()
                        .map(|arg| transform_expression(arg)) // Process each argument with `transform_expression`
                        .collect::<Result<Vec<_>>>()?;
                    Ok(RustNode::Expression(RustExpression::FunctionCall {
                        function: Box::new(RustExpression::Identifier(func_name)),
                        arguments: transformed_args,
                    }))
                }
                pt::Expression::PostIncrement(_, operand)
                | pt::Expression::PreIncrement(_, operand)
                | pt::Expression::PostDecrement(_, operand)
                | pt::Expression::PreDecrement(_, operand) => {
                    let operand_expr = transform_expression(operand)?;
                    if let RustExpression::Identifier(ref name) = operand_expr {
                        let (method_name, operator) = match expr {
                            pt::Expression::PostIncrement(_, _) => ("increment", "+"),
                            pt::Expression::PreIncrement(_, _) => ("pre_increment", "+"),
                            pt::Expression::PostDecrement(_, _) => ("decrement", "-"),
                            pt::Expression::PreDecrement(_, _) => ("pre_decrement", "-"),
                            _ => unreachable!(),
                        };

                        Ok(RustNode::Expression(RustExpression::FunctionCall {
                            function: Box::new(RustExpression::MemberAccess {
                                expression: Box::new(RustExpression::Identifier(
                                    "self".to_string(),
                                )),
                                member: method_name.to_string(),
                            }),
                            arguments: vec![
                                RustExpression::Identifier(name.clone()),
                                RustExpression::Identifier(operator.to_string()),
                            ],
                        }))
                    } else {
                        Err(anyhow!("Operand is not an identifier"))
                    }
                }

                pt::Expression::AssignAdd(_, left, right)
                | pt::Expression::AssignSubtract(_, left, right)
                | pt::Expression::AssignMultiply(_, left, right)
                | pt::Expression::AssignDivide(_, left, right)
                | pt::Expression::AssignModulo(_, left, right) => {
                    let operator = match expr {
                        pt::Expression::AssignAdd(_, _, _) => "+",
                        pt::Expression::AssignSubtract(_, _, _) => "-",
                        pt::Expression::AssignMultiply(_, _, _) => "*",
                        pt::Expression::AssignDivide(_, _, _) => "/",
                        pt::Expression::AssignModulo(_, _, _) => "%",
                        _ => unreachable!(),
                    };

                    let left_expr = transform_expression(left)?;
                    let right_expr = transform_expression(right)?;
                    Ok(RustNode::Assignment {
                        target: Box::new(RustExpression::Identifier(left.to_string())),
                        value: Box::new(RustExpression::BinaryOperation {
                            left: Box::new(left_expr),
                            operator: operator.to_string(),
                            right: Box::new(right_expr),
                        }),
                    })
                }

                // Handle other arithmetic operations like `+`, `-`, `*`, `/`, `%`
                pt::Expression::Add(_, left, right)
                | pt::Expression::Subtract(_, left, right)
                | pt::Expression::Multiply(_, left, right)
                | pt::Expression::Divide(_, left, right)
                | pt::Expression::Modulo(_, left, right) => {
                    let operator = match expr {
                        pt::Expression::Add(_, _, _) => "+",
                        pt::Expression::Subtract(_, _, _) => "-",
                        pt::Expression::Multiply(_, _, _) => "*",
                        pt::Expression::Divide(_, _, _) => "/",
                        pt::Expression::Modulo(_, _, _) => "%",
                        _ => unreachable!(),
                    };
                    let left_expr = transform_expression(left)?;
                    let right_expr = transform_expression(right)?;
                    Ok(RustNode::Assignment {
                        target: Box::new(RustExpression::Identifier(left.to_string())),
                        value: Box::new(RustExpression::BinaryOperation {
                            left: Box::new(left_expr),
                            operator: operator.to_string(),
                            right: Box::new(right_expr),
                        }),
                    })
                }

                // Handle variable identifiers
                pt::Expression::Variable(id) => Ok(RustNode::Expression(
                    RustExpression::Identifier(id.name.clone()),
                )),

                // Handle number literals
                pt::Expression::NumberLiteral(_, value, _, _) => Ok(RustNode::Expression(
                    RustExpression::NumberLiteral(value.clone()),
                )),

                // Handle unsupported expressions
                _ => Err(anyhow!("Unsupported expression statement {}", expr)),
            }
        }

        pt::Statement::Return(_, expr) => Ok(RustNode::Return(
            expr.as_ref().map(transform_expression).transpose()?,
        )),
        pt::Statement::If(_, condition, body, else_body) => {
            // Transform the condition
            let condition = transform_expression(condition)?;

            // Handle the `body` of the `if` statement
            let body = if let pt::Statement::Block { statements, .. } = &**body {
                statements
                    .iter()
                    .map(transform_statement)
                    .collect::<Result<Vec<_>>>()?
            } else {
                vec![transform_statement(body)?] // Treat as a single statement
            };

            // Handle the `else_body`, if present
            let else_body = if let Some(else_body) = else_body {
                if let pt::Statement::Block { statements, .. } = &**else_body {
                    Some(
                        statements
                            .iter()
                            .map(transform_statement)
                            .collect::<Result<Vec<_>>>()?,
                    )
                } else {
                    Some(vec![transform_statement(else_body)?])
                }
            } else {
                None
            };

            Ok(RustNode::IfStatement {
                condition: Box::new(condition),
                body,
                else_body,
            })
        }

        pt::Statement::While(_, condition, body) => {
            // Transform the condition expression
            let condition = transform_expression(condition)?;

            // Transform the body of the while loop
            let body = if let pt::Statement::Block { statements, .. } = &**body {
                statements
                    .iter()
                    .map(transform_statement)
                    .collect::<Result<Vec<_>>>()?
            } else {
                vec![transform_statement(body)?] // Treat as a single statement
            };

            Ok(RustNode::WhileStatement {
                condition: Box::new(condition),
                body,
            })
        }

        pt::Statement::For(_, init, condition, increment, body) => {
            // Handle the `init` statement
            let init = if let Some(init) = init {
                Some(Box::new(transform_statement(&**init)?))
            } else {
                None
            };

            // Handle the `condition` expression
            let condition = if let Some(condition) = condition {
                Some(Box::new(transform_expression(&**condition)?))
            } else {
                None
            };

            let increment = if let Some(increment) = increment {
                Some(Box::new(RustNode::Expression(transform_expression(
                    &**increment,
                )?)))
            } else {
                None
            };

            // Handle the `body` of the for loop
            let body = if let Some(body) = body {
                if let pt::Statement::Block { statements, .. } = &**body {
                    statements
                        .iter()
                        .map(transform_statement)
                        .collect::<Result<Vec<_>>>()?
                } else {
                    vec![transform_statement(&**body)?] // Treat as a single statement
                }
            } else {
                Vec::new()
            };

            Ok(RustNode::ForStatement {
                init,
                condition,
                increment,
                body,
            })
        }

        _ => Err(anyhow!("Unsupported statement type {}", stmt)),
    }
}


pub fn snake_to_camel_case(name: &str) -> String {
    if name.contains('_') {
        // Convert only snake_case strings
        name.split('_')
            .enumerate()
            .map(|(i, part)| {
                if i == 0 {
                    part.to_ascii_lowercase()
                } else {
                    let mut chars = part.chars();
                    chars
                        .next()
                        .map(|c| c.to_ascii_uppercase().to_string())
                        .unwrap_or_default()
                        + chars.as_str()
                }
            })
            .collect::<String>()
    } else {
        // Leave already camelCase or PascalCase strings unchanged
        name.to_string()
    }
}
