// File: types.rs

#[derive(Debug)]
pub enum TypeName {
    Elementary(ElementaryType),
    Array(Box<TypeName>, Option<usize>),
    Mapping {
        key_type: Box<TypeName>,
        value_type: Box<TypeName>,
    },
    UserDefined(String),
}

#[derive(Debug)]
pub enum ElementaryType {
    Address,
    Bool,
    String,
    Uint(u16),
    Int(u16),
    Bytes(Option<u8>),
}
