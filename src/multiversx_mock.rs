// This file provides mock types to replace MultiversX dependencies
// These are dummy implementations just to make the code compile

pub mod api {
    pub trait ManagedTypeApi {}
}

pub mod types {
    pub struct BigUint<T> {
        _phantom: std::marker::PhantomData<T>,
    }

    pub struct ManagedBuffer<T> {
        _phantom: std::marker::PhantomData<T>,
    }

    pub struct ManagedAddress<T> {
        _phantom: std::marker::PhantomData<T>,
    }

    pub struct TokenIdentifier<T> {
        _phantom: std::marker::PhantomData<T>,
    }

    pub struct BigInt<T> {
        _phantom: std::marker::PhantomData<T>,
    }
}

// Mock implementation of other MultiversX types
pub struct SingleValueMapper<T> {
    _phantom: std::marker::PhantomData<T>,
}

pub struct MapMapper<Api, K, V> {
    _phantom_api: std::marker::PhantomData<Api>,
    _phantom_k: std::marker::PhantomData<K>,
    _phantom_v: std::marker::PhantomData<V>,
}

pub struct UnorderedMapMapper<Api, K, V> {
    _phantom_api: std::marker::PhantomData<Api>,
    _phantom_k: std::marker::PhantomData<K>,
    _phantom_v: std::marker::PhantomData<V>,
}

pub struct VecMapper<Api, T> {
    _phantom_api: std::marker::PhantomData<Api>,
    _phantom_t: std::marker::PhantomData<T>,
}

pub struct ArrayMapper<Api, T, const N: usize> {
    _phantom_api: std::marker::PhantomData<Api>,
    _phantom_t: std::marker::PhantomData<T>,
}

// Mock derive macro replacements
// These are just placeholders as we won't actually use them
pub mod derive_imports {
    pub trait TypeAbi {}
    pub trait TopEncode {}
    pub trait TopDecode {}
    pub trait NestedEncode {}
    pub trait NestedDecode {}
    pub trait ManagedVecItem {}
} 