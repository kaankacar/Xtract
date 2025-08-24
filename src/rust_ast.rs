#[derive(Debug, Clone, PartialEq)]
pub enum RustVisibility {
    Public,
    Private,
}

#[derive(Debug, Clone)]
pub struct RustParameter {
    pub name: String,
    pub type_name: String,
}

#[derive(Debug, Clone)]
pub enum RustExpression {
    StringLiteral(String),
    NumberLiteral(String),
    BoolLiteral(bool),
    AddressLiteral(String),
    Identifier(String),
    BinaryOperation {
        left: Box<RustExpression>,
        operator: String,
        right: Box<RustExpression>,
    },
    UnaryOperation {
        operator: String,
        operand: Box<RustExpression>,
    },
    FunctionCall {
        function: Box<RustExpression>,
        arguments: Vec<RustExpression>,
    },
    MemberAccess {
        expression: Box<RustExpression>,
        member: String,
    },
    ArrayAccess {
        array: Box<RustExpression>,
        index: Box<RustExpression>,
    },
    StructInitializer {
        struct_name: String,
        fields: Vec<(String, RustExpression)>,
    },
    ArrayInitializer(Vec<RustExpression>),
    Conditional {
        condition: Box<RustExpression>,
        true_branch: Box<RustExpression>,
        false_branch: Box<RustExpression>,
    },
}

#[derive(Debug, Clone)]
pub enum RustNode {
    Expression(RustExpression),
    Assignment {
        target: Box<RustExpression>,
        value: Box<RustExpression>,
    },
    VariableDeclaration {
        name: String,
        type_name: String,
        initial_value: Option<RustExpression>,
    },
    StorageDefinition {
        name: String,
        type_name: String,
    },
    Function {
        name: String,
        params: Vec<RustParameter>,
        returns: Option<Vec<RustParameter>>,
        body: Vec<RustNode>,
        visibility: RustVisibility,
        is_endpoint: bool,
        is_view: bool,
    },
    If {
        condition: RustExpression,
        body: Vec<RustNode>,
        else_body: Option<Vec<RustNode>>,
    },
    While {
        condition: RustExpression,
        body: Vec<RustNode>,
    },
    For {
        init: Option<Box<RustNode>>,
        condition: Option<RustExpression>,
        update: Option<Box<RustNode>>,
        body: Vec<RustNode>,
    },
    Block(Vec<RustNode>),
    Return(Option<RustExpression>),
    Break,
    Continue,
    EnumDefinition {
        name: String,
        variants: Vec<String>,
    },
    StructDefinition {
        name: String,
        fields: Vec<RustParameter>,
    },
    ErrorDefinition {
        name: String,
        params: Vec<RustParameter>,
    },
    EventDefinition {
        name: String,
        params: Vec<RustParameter>,
    },
    ModifierDefinition {
        name: String,
        params: Vec<RustParameter>,
        body: Vec<RustNode>,
    },
    ModifierCall {
        name: String,
        arguments: Vec<RustExpression>,
        body: Vec<RustNode>,
    },
    EmitEvent {
        name: String,
        arguments: Vec<RustExpression>,
    },
    Require {
        condition: RustExpression,
        message: Option<RustExpression>,
    },
    Revert {
        error: String,
        arguments: Vec<RustExpression>,
    },
    Comment(String),
}