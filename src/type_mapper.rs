use solang_parser::pt::Type;
// Use our mock types instead of multiversx-sc
use crate::multiversx_mock::types::{BigUint, ManagedBuffer, ManagedAddress, TokenIdentifier, BigInt};
use crate::multiversx_mock::api::ManagedTypeApi;
use crate::multiversx_mock::{SingleValueMapper, MapMapper, UnorderedMapMapper, VecMapper, ArrayMapper};

pub fn map_type(ty: &Type) -> Result<String, String> {
    match ty {
        Type::Bool => Ok("bool".to_string()),
        Type::Address => Ok("ManagedAddress<Self::Api>".to_string()),
        Type::AddressPayable => Ok("ManagedAddress<Self::Api>".to_string()),
        Type::Payable => Ok("ManagedAddress<Self::Api>".to_string()),
        Type::String => Ok("ManagedBuffer<Self::Api>".to_string()),
        Type::Int(size) => {
            let size_val = *size;
            match size_val {
                8 => Ok("i8".to_string()),
                16 => Ok("i16".to_string()),
                32 => Ok("i32".to_string()),
                64 => Ok("i64".to_string()),
                128 => Ok("BigInt<Self::Api>".to_string()),
                256 => Ok("BigInt<Self::Api>".to_string()),
                _ => Ok("BigInt<Self::Api>".to_string()), // Default to BigInt
            }
        },
        Type::Uint(size) => {
            let size_val = *size;
            match size_val {
                8 => Ok("u8".to_string()),
                16 => Ok("u16".to_string()), 
                32 => Ok("u32".to_string()),
                64 => Ok("u64".to_string()),
                128 => Ok("BigUint<Self::Api>".to_string()),
                256 => Ok("BigUint<Self::Api>".to_string()),
                _ => Ok("BigUint<Self::Api>".to_string()), // Default to BigUint
            }
        },
        Type::Bytes(size) => {
            let size_val = *size;
            if size_val <= 32 {
                Ok(format!("[u8; {}]", size_val))
            } else {
                Ok("ManagedBuffer<Self::Api>".to_string())
            }
        },
        Type::DynamicBytes => Ok("ManagedBuffer<Self::Api>".to_string()),
        Type::Mapping(loc, key_ty, value_ty, key_name, value_name) => {
            // Extract the key type
            let key_type = match &**key_ty {
                Type::Address | Type::AddressPayable | Type::Payable => 
                    Ok("ManagedAddress<Self::Api>".to_string()),
                Type::Uint(size) => {
                    match *size {
                        8 => Ok("u8".to_string()),
                        16 => Ok("u16".to_string()),
                        32 => Ok("u32".to_string()),
                        64 => Ok("u64".to_string()),
                        _ => Ok("BigUint<Self::Api>".to_string()),
                    }
                },
                Type::String => Ok("ManagedBuffer<Self::Api>".to_string()),
                _ => Err(format!("Unsupported mapping key type: {:?}", key_ty)),
            }?;

            // Extract the value type
            let value_type = map_type(&**value_ty)?;
            
            // For simple key types, use MapMapper
            match key_type.as_str() {
                "u8" | "u16" | "u32" | "u64" | "ManagedAddress<Self::Api>" => {
                    Ok(format!("MapMapper<Self::Api, {}, {}>", key_type, value_type))
                },
                _ => {
                    // For more complex keys, use UnorderedMapMapper
                    Ok(format!("UnorderedMapMapper<Self::Api, {}, {}>", key_type, value_type))
                }
            }
        },
        Type::DynamicArray(_, base_ty) => {
            let base_type = map_type(&**base_ty)?;
            Ok(format!("VecMapper<Self::Api, {}>", base_type))
        },
        Type::FixedArray(_, base_ty, size) => {
            let base_type = map_type(&**base_ty)?;
            Ok(format!("ArrayMapper<Self::Api, {}, {}>", base_type, size))
        },
        Type::UserType(_, name) => {
            // Assume user types are defined elsewhere and have Api parameter
            Ok(format!("{}<Self::Api>", name))
        },
        Type::Enum(_, name) => {
            // Simple enum name
            Ok(name.to_string())
        },
        Type::Contract(_, name) => {
            // Contract references are addresses in MultiversX
            Ok(format!("ManagedAddress<Self::Api> /* {} */", name))
        },
        Type::Rational => {
            // Rational numbers - can map to a fraction type if available
            Ok("BigInt<Self::Api>".to_string()) // Simplified for now
        },
        Type::Function { .. } => {
            // Function pointers are not directly supported, so map to address
            Ok("ManagedAddress<Self::Api>".to_string())
        },
        Type::Tuple(_, items) => {
            // Handle tuples - map to MultiversX MultiValue or similar
            if items.len() == 1 {
                map_type(&items[0].0)
            } else {
                let mapped_types = items
                    .iter()
                    .map(|(ty, _)| map_type(ty))
                    .collect::<Result<Vec<String>, String>>()?
                    .join(", ");
                Ok(format!("MultiValue<{}>", mapped_types))
            }
        },
        // Add any other variants as needed
        _ => Err(format!("Unsupported type: {:?}", ty)),
    }
}