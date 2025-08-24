(module $ping_pong_test_wasm.wasm
  (type (;0;) (func (param i32 i32)))
  (type (;1;) (func (result i32)))
  (type (;2;) (func (param i32 i32) (result i32)))
  (type (;3;) (func (param i32) (result i32)))
  (type (;4;) (func (param i32 i32 i32) (result i32)))
  (type (;5;) (func (param i32)))
  (type (;6;) (func (param i32) (result i64)))
  (type (;7;) (func (param i64)))
  (type (;8;) (func (param i32 i32 i32 i32) (result i32)))
  (type (;9;) (func (param i32 i32 i64 i32 i32) (result i32)))
  (type (;10;) (func (result i64)))
  (type (;11;) (func))
  (type (;12;) (func (param i32 i32 i32 i64 i32)))
  (type (;13;) (func (param i32 i32 i32)))
  (type (;14;) (func (param i32 i32 i32 i32)))
  (type (;15;) (func (param i32 i32) (result i64)))
  (type (;16;) (func (param i32 i64)))
  (type (;17;) (func (param i32 i64 i64 i64 i32 i32)))
  (type (;18;) (func (param i64 i32)))
  (type (;19;) (func (param i32 i64 i32)))
  (import "env" "signalError" (func $signalError (;0;) (type 0)))
  (import "env" "mBufferNew" (func $mBufferNew (;1;) (type 1)))
  (import "env" "mBufferAppend" (func $mBufferAppend (;2;) (type 2)))
  (import "env" "bigIntGetUnsignedArgument" (func $bigIntGetUnsignedArgument (;3;) (type 0)))
  (import "env" "mBufferGetLength" (func $mBufferGetLength (;4;) (type 3)))
  (import "env" "mBufferAppendBytes" (func $mBufferAppendBytes (;5;) (type 4)))
  (import "env" "managedCaller" (func $managedCaller (;6;) (type 5)))
  (import "env" "managedSCAddress" (func $managedSCAddress (;7;) (type 5)))
  (import "env" "managedGetMultiESDTCallValue" (func $managedGetMultiESDTCallValue (;8;) (type 5)))
  (import "env" "bigIntGetCallValue" (func $bigIntGetCallValue (;9;) (type 5)))
  (import "env" "managedSignalError" (func $managedSignalError (;10;) (type 5)))
  (import "env" "mBufferGetArgument" (func $mBufferGetArgument (;11;) (type 2)))
  (import "env" "smallIntGetUnsignedArgument" (func $smallIntGetUnsignedArgument (;12;) (type 6)))
  (import "env" "getNumArguments" (func $getNumArguments (;13;) (type 1)))
  (import "env" "smallIntFinishUnsigned" (func $smallIntFinishUnsigned (;14;) (type 7)))
  (import "env" "mBufferSetBytes" (func $mBufferSetBytes (;15;) (type 4)))
  (import "env" "mBufferEq" (func $mBufferEq (;16;) (type 2)))
  (import "env" "mBufferFromBigIntUnsigned" (func $mBufferFromBigIntUnsigned (;17;) (type 2)))
  (import "env" "mBufferToBigIntUnsigned" (func $mBufferToBigIntUnsigned (;18;) (type 2)))
  (import "env" "mBufferStorageLoad" (func $mBufferStorageLoad (;19;) (type 2)))
  (import "env" "mBufferCopyByteSlice" (func $mBufferCopyByteSlice (;20;) (type 8)))
  (import "env" "mBufferStorageStore" (func $mBufferStorageStore (;21;) (type 2)))
  (import "env" "managedTransferValueExecute" (func $managedTransferValueExecute (;22;) (type 9)))
  (import "env" "managedWriteLog" (func $managedWriteLog (;23;) (type 0)))
  (import "env" "getBlockTimestamp" (func $getBlockTimestamp (;24;) (type 10)))
  (import "env" "checkNoPayment" (func $checkNoPayment (;25;) (type 11)))
  (import "env" "bigIntCmp" (func $bigIntCmp (;26;) (type 2)))
  (import "env" "mBufferGetBytes" (func $mBufferGetBytes (;27;) (type 2)))
  (import "env" "bigIntGetESDTExternalBalance" (func $bigIntGetESDTExternalBalance (;28;) (type 12)))
  (import "env" "bigIntGetExternalBalance" (func $bigIntGetExternalBalance (;29;) (type 0)))
  (import "env" "bigIntAdd" (func $bigIntAdd (;30;) (type 13)))
  (import "env" "getGasLeft" (func $getGasLeft (;31;) (type 10)))
  (import "env" "finish" (func $finish (;32;) (type 0)))
  (import "env" "mBufferFinish" (func $mBufferFinish (;33;) (type 3)))
  (import "env" "bigIntFinishUnsigned" (func $bigIntFinishUnsigned (;34;) (type 5)))
  (import "env" "mBufferGetByteSlice" (func $mBufferGetByteSlice (;35;) (type 8)))
  (memory (;0;) 3)
  (global $__stack_pointer (;0;) (mut i32) i32.const 131072)
  (global (;1;) i32 i32.const 131817)
  (global (;2;) i32 i32.const 131824)
  (export "memory" (memory 0))
  (export "init" (func $init))
  (export "upgrade" (func $upgrade))
  (export "ping" (func $ping))
  (export "pong" (func $pong))
  (export "pongAll" (func $pongAll))
  (export "getUserAddresses" (func $getUserAddresses))
  (export "getContractState" (func $getContractState))
  (export "getPingAmount" (func $getPingAmount))
  (export "getDeadline" (func $getDeadline))
  (export "getActivationTimestamp" (func $getActivationTimestamp))
  (export "getMaxFunds" (func $getMaxFunds))
  (export "getUserStatus" (func $getUserStatus))
  (export "pongAllLastUser" (func $pongAllLastUser))
  (export "callBack" (func $callBack))
  (export "__data_end" (global 1))
  (export "__heap_base" (global 2))
  (func $_ZN106_$LT$$RF$str$u20$as$u20$multiversx_sc..contract_base..wrappers..error_helper..IntoSignalError$LT$M$GT$$GT$25signal_error_with_message17h6dddbfbddafded8cE (;36;) (type 0) (param i32 i32)
    local.get 0
    local.get 1
    call $signalError
    unreachable
  )
  (func $_ZN115_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h2a3c94b7e254c05cE (;37;) (type 3) (param i32) (result i32)
    (local i32)
    call $mBufferNew
    local.tee 1
    local.get 0
    call $mBufferAppend
    drop
    local.get 1
  )
  (func $_ZN133_$LT$multiversx_sc..io..finish..ApiOutputAdapter$LT$FA$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$19start_nested_encode17h827d95c24a3d29c9E (;38;) (type 1) (result i32)
    i32.const 1
    i32.const 0
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$14new_from_bytes17h82e8fb451363e092E
  )
  (func $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$14new_from_bytes17h82e8fb451363e092E (;39;) (type 2) (param i32 i32) (result i32)
    (local i32)
    call $_ZN26multiversx_sc_wasm_adapter3api13managed_types19static_var_api_node11next_handle17h140133c4fd796bd1E
    local.tee 2
    local.get 0
    local.get 1
    call $mBufferSetBytes
    drop
    local.get 2
  )
  (func $_ZN133_$LT$multiversx_sc..types..managed..wrapped..big_uint..BigUint$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..top_de..TopDecode$GT$24top_decode_or_handle_err17hd094d2fb52da94d4E (;40;) (type 3) (param i32) (result i32)
    (local i32)
    local.get 0
    call $_ZN26multiversx_sc_wasm_adapter3api13managed_types19static_var_api_node11next_handle17h140133c4fd796bd1E
    local.tee 1
    call $bigIntGetUnsignedArgument
    local.get 1
  )
  (func $_ZN26multiversx_sc_wasm_adapter3api13managed_types19static_var_api_node11next_handle17h140133c4fd796bd1E (;41;) (type 1) (result i32)
    (local i32)
    i32.const 0
    i32.const 0
    i32.load offset=131744
    i32.const -1
    i32.add
    local.tee 0
    i32.store offset=131744
    local.get 0
  )
  (func $_ZN139_$LT$multiversx_sc..types..managed..wrapped..big_uint..BigUint$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en..NestedEncode$GT$24dep_encode_or_handle_err17h89cb528c5accd023E (;42;) (type 0) (param i32 i32)
    (local i32 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 2
    global.set $__stack_pointer
    local.get 2
    local.get 0
    call $_ZN13multiversx_sc5types7managed7wrapped8big_uint16BigUint$LT$M$GT$18to_bytes_be_buffer17hec98bdc195bcc87eE
    local.tee 3
    call $mBufferGetLength
    local.tee 0
    i32.const 24
    i32.shl
    local.get 0
    i32.const 65280
    i32.and
    i32.const 8
    i32.shl
    i32.or
    local.get 0
    i32.const 8
    i32.shr_u
    i32.const 65280
    i32.and
    local.get 0
    i32.const 24
    i32.shr_u
    i32.or
    i32.or
    i32.store offset=12
    local.get 1
    local.get 2
    i32.const 12
    i32.add
    i32.const 4
    call $mBufferAppendBytes
    drop
    local.get 1
    local.get 3
    call $mBufferAppend
    drop
    local.get 2
    i32.const 16
    i32.add
    global.set $__stack_pointer
  )
  (func $_ZN13multiversx_sc5types7managed7wrapped8big_uint16BigUint$LT$M$GT$18to_bytes_be_buffer17hec98bdc195bcc87eE (;43;) (type 3) (param i32) (result i32)
    (local i32)
    call $_ZN26multiversx_sc_wasm_adapter3api13managed_types19static_var_api_node11next_handle17h140133c4fd796bd1E
    local.tee 1
    local.get 0
    call $mBufferFromBigIntUnsigned
    drop
    local.get 1
  )
  (func $_ZN13multiversx_sc13contract_base8wrappers12error_helper20ErrorHelper$LT$M$GT$25signal_error_with_message17he08d9f3729d44387E (;44;) (type 0) (param i32 i32)
    local.get 0
    local.get 1
    call $_ZN106_$LT$$RF$str$u20$as$u20$multiversx_sc..contract_base..wrappers..error_helper..IntoSignalError$LT$M$GT$$GT$25signal_error_with_message17h6dddbfbddafded8cE
    unreachable
  )
  (func $_ZN13multiversx_sc13contract_base8wrappers18blockchain_wrapper26BlockchainWrapper$LT$A$GT$10get_caller17ha48e4e017c8b0a66E (;45;) (type 1) (result i32)
    (local i32)
    call $_ZN26multiversx_sc_wasm_adapter3api13managed_types19static_var_api_node11next_handle17h140133c4fd796bd1E
    local.tee 0
    call $managedCaller
    local.get 0
  )
  (func $_ZN13multiversx_sc13contract_base8wrappers18blockchain_wrapper26BlockchainWrapper$LT$A$GT$14get_sc_address17h7db029c54afa28f0E (;46;) (type 1) (result i32)
    (local i32)
    call $_ZN26multiversx_sc_wasm_adapter3api13managed_types19static_var_api_node11next_handle17h140133c4fd796bd1E
    local.tee 0
    call $managedSCAddress
    local.get 0
  )
  (func $_ZN13multiversx_sc13contract_base8wrappers18call_value_wrapper25CallValueWrapper$LT$A$GT$4egld17h500d89ddeb471ed0E (;47;) (type 1) (result i32)
    (local i32 i32 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 0
    global.set $__stack_pointer
    block ;; label = @1
      i32.const 2
      call $_ZN13multiversx_sc3api13managed_types14static_var_api16StaticVarApiImpl21flag_is_set_or_update17h64d7fdfa0eb72ee3E
      br_if 0 (;@1;)
      i32.const -38
      call $managedGetMultiESDTCallValue
    end
    block ;; label = @1
      block ;; label = @2
        block ;; label = @3
          block ;; label = @4
            block ;; label = @5
              block ;; label = @6
                i32.const -38
                call $mBufferGetLength
                i32.const 4
                i32.shr_u
                br_table 1 (;@5;) 2 (;@4;) 0 (;@6;)
              end
              i32.const 131122
              i32.const 29
              call $signalError
              unreachable
            end
            i32.const -35
            local.set 1
            i32.const 1
            call $_ZN13multiversx_sc3api13managed_types14static_var_api16StaticVarApiImpl21flag_is_set_or_update17h64d7fdfa0eb72ee3E
            br_if 1 (;@3;)
            i32.const -35
            local.set 1
            i32.const -35
            call $bigIntGetCallValue
            br 1 (;@3;)
          end
          local.get 0
          i32.const 8
          i32.add
          i64.const 0
          i64.store
          local.get 0
          i64.const 0
          i64.store
          i32.const -38
          i32.const 0
          local.get 0
          i32.const 16
          call $_ZN26multiversx_sc_wasm_adapter3api13managed_types23managed_buffer_api_node161_$LT$impl$u20$multiversx_sc..api..managed_types..managed_buffer_api..ManagedBufferApiImpl$u20$for$u20$multiversx_sc_wasm_adapter..api..vm_api_node..VmApiImpl$GT$13mb_load_slice17h1231c44778661112E
          br_if 1 (;@2;)
          local.get 0
          i32.load offset=12
          local.set 1
          local.get 0
          i32.load
          local.tee 2
          i32.const 24
          i32.shl
          local.get 2
          i32.const 65280
          i32.and
          i32.const 8
          i32.shl
          i32.or
          local.get 2
          i32.const 8
          i32.shr_u
          i32.const 65280
          i32.and
          local.get 2
          i32.const 24
          i32.shr_u
          i32.or
          i32.or
          call $_ZN13multiversx_sc5types7managed7wrapped29egld_or_esdt_token_identifier34EgldOrEsdtTokenIdentifier$LT$M$GT$7is_egld17h2ded2bffc2497867E
          i32.eqz
          br_if 2 (;@1;)
          local.get 1
          i32.const 24
          i32.shl
          local.get 1
          i32.const 65280
          i32.and
          i32.const 8
          i32.shl
          i32.or
          local.get 1
          i32.const 8
          i32.shr_u
          i32.const 65280
          i32.and
          local.get 1
          i32.const 24
          i32.shr_u
          i32.or
          i32.or
          local.set 1
        end
        local.get 0
        i32.const 16
        i32.add
        global.set $__stack_pointer
        local.get 1
        return
      end
      i32.const 131266
      i32.const 29
      call $signalError
      unreachable
    end
    i32.const 131085
    i32.const 37
    call $signalError
    unreachable
  )
  (func $_ZN13multiversx_sc3api13managed_types14static_var_api16StaticVarApiImpl21flag_is_set_or_update17h64d7fdfa0eb72ee3E (;48;) (type 3) (param i32) (result i32)
    (local i32 i32)
    block ;; label = @1
      i32.const 0
      i32.load8_u offset=131752
      local.tee 1
      local.get 0
      i32.and
      i32.const 255
      i32.and
      local.get 0
      i32.const 255
      i32.and
      i32.eq
      local.tee 2
      br_if 0 (;@1;)
      i32.const 0
      local.get 1
      local.get 0
      i32.or
      i32.store8 offset=131752
    end
    local.get 2
  )
  (func $_ZN26multiversx_sc_wasm_adapter3api13managed_types23managed_buffer_api_node161_$LT$impl$u20$multiversx_sc..api..managed_types..managed_buffer_api..ManagedBufferApiImpl$u20$for$u20$multiversx_sc_wasm_adapter..api..vm_api_node..VmApiImpl$GT$13mb_load_slice17h1231c44778661112E (;49;) (type 8) (param i32 i32 i32 i32) (result i32)
    local.get 0
    local.get 1
    local.get 3
    local.get 2
    call $mBufferGetByteSlice
    i32.const 0
    i32.ne
  )
  (func $_ZN13multiversx_sc5types7managed7wrapped29egld_or_esdt_token_identifier34EgldOrEsdtTokenIdentifier$LT$M$GT$7is_egld17h2ded2bffc2497867E (;50;) (type 3) (param i32) (result i32)
    i32.const -40
    i32.const 131327
    i32.const 11
    call $mBufferSetBytes
    drop
    i32.const -40
    local.get 0
    call $mBufferEq
    i32.const 0
    i32.gt_s
  )
  (func $_ZN13multiversx_sc2io12signal_error19signal_arg_de_error17hb152be4bd99a2e89E (;51;) (type 14) (param i32 i32 i32 i32)
    (local i32)
    i32.const 131151
    i32.const 23
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$14new_from_bytes17h82e8fb451363e092E
    local.tee 4
    local.get 0
    local.get 1
    call $mBufferAppendBytes
    drop
    local.get 4
    i32.const 131174
    i32.const 3
    call $mBufferAppendBytes
    drop
    local.get 4
    local.get 2
    local.get 3
    call $mBufferAppendBytes
    drop
    local.get 4
    call $managedSignalError
    unreachable
  )
  (func $_ZN13multiversx_sc2io16arg_nested_tuple14load_multi_arg17h8d7eda2a6d467ad9E (;52;) (type 0) (param i32 i32)
    (local i32 i32)
    i32.const 0
    local.set 2
    block ;; label = @1
      block ;; label = @2
        local.get 1
        i32.load
        local.tee 3
        i32.const 0
        i32.load offset=131748
        i32.lt_s
        br_if 0 (;@2;)
        i32.const 1
        local.set 2
        br 1 (;@1;)
      end
      local.get 1
      local.get 3
      i32.const 1
      i32.add
      i32.store
      local.get 3
      call $_ZN133_$LT$multiversx_sc..types..managed..wrapped..big_uint..BigUint$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..top_de..TopDecode$GT$24top_decode_or_handle_err17hd094d2fb52da94d4E
      local.set 1
    end
    local.get 0
    local.get 1
    i32.store offset=4
    local.get 0
    local.get 2
    i32.store
  )
  (func $_ZN13multiversx_sc2io16arg_nested_tuple14load_multi_arg17hb9c1aa8cc3bf7119E (;53;) (type 5) (param i32)
    local.get 0
    i32.const 0
    i32.load offset=131748
    i32.store
  )
  (func $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17h595511fd1da80044E (;54;) (type 5) (param i32)
    (local i32 i32 i32 i64 i64)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee 1
    global.set $__stack_pointer
    i32.const 2
    call $_ZN26multiversx_sc_wasm_adapter3api13managed_types19static_var_api_node11next_handle17h140133c4fd796bd1E
    local.tee 2
    call $mBufferGetArgument
    drop
    local.get 1
    local.get 2
    call $mBufferGetLength
    local.tee 3
    i32.store offset=20
    local.get 1
    i32.const 0
    i32.store offset=16
    local.get 1
    local.get 2
    i32.store offset=12
    block ;; label = @1
      block ;; label = @2
        local.get 3
        br_if 0 (;@2;)
        i64.const 0
        local.set 4
        br 1 (;@1;)
      end
      local.get 1
      i32.const 0
      i32.store8 offset=24
      local.get 1
      i32.const 12
      i32.add
      local.get 1
      i32.const 24
      i32.add
      i32.const 1
      call $_ZN198_$LT$multiversx_sc..types..managed..codec_util..managed_buffer_nested_de_input..ManagedBufferNestedDecodeInput$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_de_input..NestedDecodeInput$GT$9read_into17hc164ef3f3bbbed15E
      i64.const 0
      local.set 4
      block ;; label = @2
        block ;; label = @3
          block ;; label = @4
            local.get 1
            i32.load8_u offset=24
            br_table 2 (;@2;) 1 (;@3;) 0 (;@4;)
          end
          i32.const 131603
          i32.const 24
          i32.const 131072
          i32.const 13
          call $_ZN13multiversx_sc2io12signal_error19signal_arg_de_error17hb152be4bd99a2e89E
          unreachable
        end
        local.get 1
        i64.const 0
        i64.store offset=24
        local.get 1
        i32.const 12
        i32.add
        local.get 1
        i32.const 24
        i32.add
        i32.const 8
        call $_ZN198_$LT$multiversx_sc..types..managed..codec_util..managed_buffer_nested_de_input..ManagedBufferNestedDecodeInput$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_de_input..NestedDecodeInput$GT$9read_into17hc164ef3f3bbbed15E
        local.get 1
        i64.load offset=24
        local.tee 4
        i64.const 56
        i64.shl
        local.get 4
        i64.const 65280
        i64.and
        i64.const 40
        i64.shl
        i64.or
        local.get 4
        i64.const 16711680
        i64.and
        i64.const 24
        i64.shl
        local.get 4
        i64.const 4278190080
        i64.and
        i64.const 8
        i64.shl
        i64.or
        i64.or
        local.get 4
        i64.const 8
        i64.shr_u
        i64.const 4278190080
        i64.and
        local.get 4
        i64.const 24
        i64.shr_u
        i64.const 16711680
        i64.and
        i64.or
        local.get 4
        i64.const 40
        i64.shr_u
        i64.const 65280
        i64.and
        local.get 4
        i64.const 56
        i64.shr_u
        i64.or
        i64.or
        i64.or
        local.set 5
        i64.const 1
        local.set 4
      end
      local.get 1
      i32.load offset=20
      local.get 1
      i32.load offset=16
      i32.eq
      br_if 0 (;@1;)
      i32.const 131603
      i32.const 24
      i32.const 131237
      i32.const 14
      call $_ZN13multiversx_sc2io12signal_error19signal_arg_de_error17hb152be4bd99a2e89E
      unreachable
    end
    local.get 0
    local.get 5
    i64.store offset=8
    local.get 0
    local.get 4
    i64.store
    local.get 1
    i32.const 32
    i32.add
    global.set $__stack_pointer
  )
  (func $_ZN198_$LT$multiversx_sc..types..managed..codec_util..managed_buffer_nested_de_input..ManagedBufferNestedDecodeInput$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_de_input..NestedDecodeInput$GT$9read_into17hc164ef3f3bbbed15E (;55;) (type 13) (param i32 i32 i32)
    (local i32)
    block ;; label = @1
      local.get 0
      i32.load
      local.get 0
      i32.load offset=4
      local.tee 3
      local.get 1
      local.get 2
      call $_ZN26multiversx_sc_wasm_adapter3api13managed_types23managed_buffer_api_node161_$LT$impl$u20$multiversx_sc..api..managed_types..managed_buffer_api..ManagedBufferApiImpl$u20$for$u20$multiversx_sc_wasm_adapter..api..vm_api_node..VmApiImpl$GT$13mb_load_slice17h1231c44778661112E
      i32.eqz
      br_if 0 (;@1;)
      call $_ZN198_$LT$multiversx_sc..types..managed..codec_util..managed_buffer_nested_de_input..ManagedBufferNestedDecodeInput$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_de_input..NestedDecodeInput$GT$9peek_into28_$u7b$$u7b$closure$u7d$$u7d$17hebf07c878f59f3daE
      unreachable
    end
    local.get 0
    local.get 3
    local.get 2
    i32.add
    i32.store offset=4
  )
  (func $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17h5c97185c1560416fE (;56;) (type 1) (result i32)
    (local i64)
    block ;; label = @1
      i32.const 0
      call $smallIntGetUnsignedArgument
      local.tee 0
      i64.const 4294967296
      i64.lt_u
      br_if 0 (;@1;)
      i32.const 131627
      i32.const 7
      i32.const 131237
      i32.const 14
      call $_ZN13multiversx_sc2io12signal_error19signal_arg_de_error17hb152be4bd99a2e89E
      unreachable
    end
    local.get 0
    i32.wrap_i64
  )
  (func $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17h98b79247857ed50eE (;57;) (type 1) (result i32)
    i32.const 0
    call $_ZN133_$LT$multiversx_sc..types..managed..wrapped..big_uint..BigUint$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..top_de..TopDecode$GT$24top_decode_or_handle_err17hd094d2fb52da94d4E
  )
  (func $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17he06a9b2edc2f9783E (;58;) (type 10) (result i64)
    i32.const 1
    call $smallIntGetUnsignedArgument
  )
  (func $_ZN13multiversx_sc2io16arg_nested_tuple18check_no_more_args17hf0137016c3221a08E (;59;) (type 5) (param i32)
    block ;; label = @1
      local.get 0
      i32.const 0
      i32.load offset=131748
      i32.lt_s
      br_if 0 (;@1;)
      return
    end
    i32.const 131194
    i32.const 18
    call $signalError
    unreachable
  )
  (func $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_eq17hb6cfff90ed14e47cE (;60;) (type 5) (param i32)
    block ;; label = @1
      call $getNumArguments
      local.get 0
      i32.ne
      br_if 0 (;@1;)
      return
    end
    i32.const 131212
    i32.const 25
    call $signalError
    unreachable
  )
  (func $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_ge17hede2fb20e6ddc134E (;61;) (type 5) (param i32)
    block ;; label = @1
      i32.const 0
      i32.load offset=131748
      local.get 0
      i32.lt_s
      br_if 0 (;@1;)
      return
    end
    i32.const 131177
    i32.const 17
    call $signalError
    unreachable
  )
  (func $_ZN13multiversx_sc2io16arg_nested_tuple26init_arguments_static_data17h60cc3ba5036bf72dE (;62;) (type 11)
    i32.const 0
    call $getNumArguments
    i32.store offset=131748
  )
  (func $_ZN13multiversx_sc2io6finish12finish_multi17h2e9b232a1f462d67E (;63;) (type 5) (param i32)
    local.get 0
    call $_ZN13multiversx_sc7storage7mappers19single_value_mapper35SingleValueMapper$LT$SA$C$T$C$A$GT$3get17h656de0b911e2d985E
    call $smallIntFinishUnsigned
  )
  (func $_ZN13multiversx_sc7storage7mappers19single_value_mapper35SingleValueMapper$LT$SA$C$T$C$A$GT$3get17h656de0b911e2d985E (;64;) (type 6) (param i32) (result i64)
    local.get 0
    local.get 0
    call $_ZN19multiversx_sc_codec6single12top_de_input14TopDecodeInput8into_u6417h0b9cd59f0c66ef11E
  )
  (func $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h1e279485930b6512E (;65;) (type 1) (result i32)
    i32.const 1
    i32.const 0
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$14new_from_bytes17h82e8fb451363e092E
  )
  (func $_ZN13multiversx_sc5types7managed7wrapped11managed_vec23ManagedVec$LT$M$C$T$GT$4push17hf74ffcf752ff0ac8E (;66;) (type 0) (param i32 i32)
    (local i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 2
    global.set $__stack_pointer
    local.get 2
    local.get 1
    i32.const 24
    i32.shl
    local.get 1
    i32.const 65280
    i32.and
    i32.const 8
    i32.shl
    i32.or
    local.get 1
    i32.const 8
    i32.shr_u
    i32.const 65280
    i32.and
    local.get 1
    i32.const 24
    i32.shr_u
    i32.or
    i32.or
    i32.store offset=12
    local.get 0
    local.get 2
    i32.const 12
    i32.add
    i32.const 4
    call $mBufferAppendBytes
    drop
    local.get 2
    i32.const 16
    i32.add
    global.set $__stack_pointer
  )
  (func $_ZN13multiversx_sc5types7managed7wrapped8big_uint16BigUint$LT$M$GT$20from_bytes_be_buffer17hb1d65a35a633fc91E (;67;) (type 3) (param i32) (result i32)
    (local i32)
    local.get 0
    call $_ZN26multiversx_sc_wasm_adapter3api13managed_types19static_var_api_node11next_handle17h140133c4fd796bd1E
    local.tee 1
    call $mBufferToBigIntUnsigned
    drop
    local.get 1
  )
  (func $_ZN13multiversx_sc7storage11storage_get24StorageGetInput$LT$A$GT$17to_managed_buffer17h1055d7794ba1a69eE (;68;) (type 3) (param i32) (result i32)
    (local i32)
    local.get 0
    call $_ZN26multiversx_sc_wasm_adapter3api13managed_types19static_var_api_node11next_handle17h140133c4fd796bd1E
    local.tee 1
    call $mBufferStorageLoad
    drop
    local.get 1
  )
  (func $_ZN13multiversx_sc7storage11storage_get24StorageGetInput$LT$A$GT$23load_len_managed_buffer17h16e8cb9d1f3f2629E (;69;) (type 3) (param i32) (result i32)
    local.get 0
    i32.const -25
    call $mBufferStorageLoad
    drop
    i32.const -25
    call $mBufferGetLength
  )
  (func $_ZN13multiversx_sc7storage11storage_key19StorageKey$LT$A$GT$11append_item17h693637499c66dd6fE (;70;) (type 0) (param i32 i32)
    (local i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 2
    global.set $__stack_pointer
    local.get 2
    local.get 1
    i32.const 24
    i32.shl
    local.get 1
    i32.const 65280
    i32.and
    i32.const 8
    i32.shl
    i32.or
    local.get 1
    i32.const 8
    i32.shr_u
    i32.const 65280
    i32.and
    local.get 1
    i32.const 24
    i32.shr_u
    i32.or
    i32.or
    i32.store offset=12
    local.get 0
    local.get 2
    i32.const 12
    i32.add
    i32.const 4
    call $mBufferAppendBytes
    drop
    local.get 2
    i32.const 16
    i32.add
    global.set $__stack_pointer
  )
  (func $_ZN13multiversx_sc7storage7mappers11user_mapper24UserMapper$LT$SA$C$A$GT$11get_user_id17hc28b18b625a9972dE (;71;) (type 2) (param i32 i32) (result i32)
    local.get 0
    local.get 1
    call $_ZN13multiversx_sc7storage7mappers11user_mapper24UserMapper$LT$SA$C$A$GT$15get_user_id_key17hbdbca7372b177083E
    call $_ZN141_$LT$multiversx_sc..storage..mappers..source..CurrentStorage$u20$as$u20$multiversx_sc..storage..mappers..source..StorageAddress$LT$SA$GT$$GT$19address_storage_get17hecf8779266aedeeaE
  )
  (func $_ZN13multiversx_sc7storage7mappers11user_mapper24UserMapper$LT$SA$C$A$GT$15get_user_id_key17hbdbca7372b177083E (;72;) (type 2) (param i32 i32) (result i32)
    local.get 0
    call $_ZN115_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h2a3c94b7e254c05cE
    local.tee 0
    i32.const 131338
    i32.const 14
    call $mBufferAppendBytes
    drop
    local.get 0
    local.get 1
    call $mBufferAppend
    drop
    local.get 0
  )
  (func $_ZN141_$LT$multiversx_sc..storage..mappers..source..CurrentStorage$u20$as$u20$multiversx_sc..storage..mappers..source..StorageAddress$LT$SA$GT$$GT$19address_storage_get17hecf8779266aedeeaE (;73;) (type 3) (param i32) (result i32)
    (local i64)
    block ;; label = @1
      local.get 0
      local.get 0
      call $_ZN19multiversx_sc_codec6single12top_de_input14TopDecodeInput8into_u6417h0b9cd59f0c66ef11E
      local.tee 1
      i64.const 4294967296
      i64.lt_u
      br_if 0 (;@1;)
      local.get 0
      i32.const 131237
      i32.const 14
      call $_ZN147_$LT$multiversx_sc..storage..storage_get..StorageGetErrorHandler$LT$M$GT$$u20$as$u20$multiversx_sc_codec..codec_err_handler..DecodeErrorHandler$GT$12handle_error17h386838bdb262d878E
      unreachable
    end
    local.get 1
    i32.wrap_i64
  )
  (func $_ZN13multiversx_sc7storage7mappers11user_mapper24UserMapper$LT$SA$C$A$GT$14get_user_count17h7f4b629dafd192a7E (;74;) (type 3) (param i32) (result i32)
    local.get 0
    call $_ZN13multiversx_sc7storage7mappers11user_mapper24UserMapper$LT$SA$C$A$GT$18get_user_count_key17h57ecf9e31045b086E
    call $_ZN141_$LT$multiversx_sc..storage..mappers..source..CurrentStorage$u20$as$u20$multiversx_sc..storage..mappers..source..StorageAddress$LT$SA$GT$$GT$19address_storage_get17hecf8779266aedeeaE
  )
  (func $_ZN13multiversx_sc7storage7mappers11user_mapper24UserMapper$LT$SA$C$A$GT$18get_user_count_key17h57ecf9e31045b086E (;75;) (type 3) (param i32) (result i32)
    local.get 0
    call $_ZN115_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h2a3c94b7e254c05cE
    local.tee 0
    i32.const 131352
    i32.const 6
    call $mBufferAppendBytes
    drop
    local.get 0
  )
  (func $_ZN13multiversx_sc7storage7mappers11user_mapper24UserMapper$LT$SA$C$A$GT$20get_user_address_key17h2ad72733154dc6e4E (;76;) (type 2) (param i32 i32) (result i32)
    local.get 0
    call $_ZN115_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h2a3c94b7e254c05cE
    local.tee 0
    i32.const 131358
    i32.const 14
    call $mBufferAppendBytes
    drop
    local.get 0
    local.get 1
    call $_ZN13multiversx_sc7storage11storage_key19StorageKey$LT$A$GT$11append_item17h693637499c66dd6fE
    local.get 0
  )
  (func $_ZN13multiversx_sc7storage7mappers19single_value_mapper35SingleValueMapper$LT$SA$C$T$C$A$GT$3get17h0391073f973cf385E (;77;) (type 3) (param i32) (result i32)
    local.get 0
    call $_ZN13multiversx_sc7storage11storage_get24StorageGetInput$LT$A$GT$17to_managed_buffer17h1055d7794ba1a69eE
    call $_ZN13multiversx_sc5types7managed7wrapped8big_uint16BigUint$LT$M$GT$20from_bytes_be_buffer17hb1d65a35a633fc91E
  )
  (func $_ZN13multiversx_sc7storage7mappers19single_value_mapper35SingleValueMapper$LT$SA$C$T$C$A$GT$3get17h1c0ceedad7ce9c02E (;78;) (type 3) (param i32) (result i32)
    (local i64)
    block ;; label = @1
      local.get 0
      call $_ZN13multiversx_sc7storage11storage_get24StorageGetInput$LT$A$GT$23load_len_managed_buffer17h16e8cb9d1f3f2629E
      br_if 0 (;@1;)
      i32.const 0
      return
    end
    block ;; label = @1
      block ;; label = @2
        local.get 0
        local.get 0
        call $_ZN19multiversx_sc_codec6single12top_de_input14TopDecodeInput8into_u6417h0b9cd59f0c66ef11E
        local.tee 1
        i64.const 256
        i64.ge_u
        br_if 0 (;@2;)
        local.get 1
        i64.const 3
        i64.ge_u
        br_if 1 (;@1;)
        local.get 1
        i32.wrap_i64
        return
      end
      local.get 0
      i32.const 131237
      i32.const 14
      call $_ZN147_$LT$multiversx_sc..storage..storage_get..StorageGetErrorHandler$LT$M$GT$$u20$as$u20$multiversx_sc_codec..codec_err_handler..DecodeErrorHandler$GT$12handle_error17h386838bdb262d878E
      unreachable
    end
    local.get 0
    i32.const 131072
    i32.const 13
    call $_ZN147_$LT$multiversx_sc..storage..storage_get..StorageGetErrorHandler$LT$M$GT$$u20$as$u20$multiversx_sc_codec..codec_err_handler..DecodeErrorHandler$GT$12handle_error17h386838bdb262d878E
    unreachable
  )
  (func $_ZN19multiversx_sc_codec6single12top_de_input14TopDecodeInput8into_u6417h0b9cd59f0c66ef11E (;79;) (type 15) (param i32 i32) (result i64)
    (local i32 i32 i64)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 2
    global.set $__stack_pointer
    local.get 2
    i64.const 0
    i64.store offset=8
    block ;; label = @1
      local.get 0
      call $_ZN13multiversx_sc7storage11storage_get24StorageGetInput$LT$A$GT$17to_managed_buffer17h1055d7794ba1a69eE
      local.tee 3
      call $mBufferGetLength
      local.tee 0
      i32.const 9
      i32.lt_u
      br_if 0 (;@1;)
      local.get 1
      i32.const 131237
      i32.const 14
      call $_ZN147_$LT$multiversx_sc..storage..storage_get..StorageGetErrorHandler$LT$M$GT$$u20$as$u20$multiversx_sc_codec..codec_err_handler..DecodeErrorHandler$GT$12handle_error17h386838bdb262d878E
      unreachable
    end
    local.get 3
    i32.const 0
    local.get 2
    i32.const 8
    i32.add
    local.get 0
    i32.sub
    i32.const 8
    i32.add
    local.get 0
    call $_ZN26multiversx_sc_wasm_adapter3api13managed_types23managed_buffer_api_node161_$LT$impl$u20$multiversx_sc..api..managed_types..managed_buffer_api..ManagedBufferApiImpl$u20$for$u20$multiversx_sc_wasm_adapter..api..vm_api_node..VmApiImpl$GT$13mb_load_slice17h1231c44778661112E
    drop
    local.get 2
    i64.load offset=8
    local.set 4
    local.get 2
    i32.const 16
    i32.add
    global.set $__stack_pointer
    local.get 4
    i64.const 56
    i64.shl
    local.get 4
    i64.const 65280
    i64.and
    i64.const 40
    i64.shl
    i64.or
    local.get 4
    i64.const 16711680
    i64.and
    i64.const 24
    i64.shl
    local.get 4
    i64.const 4278190080
    i64.and
    i64.const 8
    i64.shl
    i64.or
    i64.or
    local.get 4
    i64.const 8
    i64.shr_u
    i64.const 4278190080
    i64.and
    local.get 4
    i64.const 24
    i64.shr_u
    i64.const 16711680
    i64.and
    i64.or
    local.get 4
    i64.const 40
    i64.shr_u
    i64.const 65280
    i64.and
    local.get 4
    i64.const 56
    i64.shr_u
    i64.or
    i64.or
    i64.or
  )
  (func $_ZN147_$LT$multiversx_sc..storage..storage_get..StorageGetErrorHandler$LT$M$GT$$u20$as$u20$multiversx_sc_codec..codec_err_handler..DecodeErrorHandler$GT$12handle_error17h386838bdb262d878E (;80;) (type 13) (param i32 i32 i32)
    (local i32)
    i32.const 131372
    i32.const 27
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$14new_from_bytes17h82e8fb451363e092E
    local.tee 3
    local.get 0
    call $mBufferAppend
    drop
    local.get 3
    i32.const 131174
    i32.const 3
    call $mBufferAppendBytes
    drop
    local.get 3
    local.get 1
    local.get 2
    call $mBufferAppendBytes
    drop
    local.get 3
    call $managedSignalError
    unreachable
  )
  (func $_ZN13multiversx_sc7storage7mappers19single_value_mapper35SingleValueMapper$LT$SA$C$T$C$A$GT$3get17hf795bca050ba19baE (;81;) (type 0) (param i32 i32)
    (local i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 2
    global.set $__stack_pointer
    local.get 2
    local.get 1
    call $_ZN13multiversx_sc7storage11storage_get24StorageGetInput$LT$A$GT$17to_managed_buffer17h1055d7794ba1a69eE
    local.tee 3
    call $mBufferGetLength
    local.tee 4
    i32.store offset=8
    i32.const 0
    local.set 5
    local.get 2
    i32.const 0
    i32.store offset=4
    local.get 2
    local.get 3
    i32.store
    block ;; label = @1
      block ;; label = @2
        block ;; label = @3
          block ;; label = @4
            local.get 4
            br_if 0 (;@4;)
            br 1 (;@3;)
          end
          i32.const 0
          local.set 5
          local.get 2
          i32.const 0
          i32.store8 offset=12
          local.get 2
          local.get 2
          i32.const 12
          i32.add
          i32.const 1
          local.get 1
          call $_ZN198_$LT$multiversx_sc..types..managed..codec_util..managed_buffer_nested_de_input..ManagedBufferNestedDecodeInput$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_de_input..NestedDecodeInput$GT$9read_into17h75292ec7df79ebdbE
          block ;; label = @4
            block ;; label = @5
              block ;; label = @6
                block ;; label = @7
                  local.get 2
                  i32.load8_u offset=12
                  br_table 0 (;@7;) 2 (;@5;) 1 (;@6;)
                end
                local.get 2
                i32.load offset=4
                local.set 4
                br 2 (;@4;)
              end
              local.get 1
              i32.const 131072
              i32.const 13
              call $_ZN147_$LT$multiversx_sc..storage..storage_get..StorageGetErrorHandler$LT$M$GT$$u20$as$u20$multiversx_sc_codec..codec_err_handler..DecodeErrorHandler$GT$12handle_error17h386838bdb262d878E
              unreachable
            end
            local.get 2
            i32.const 0
            i32.store offset=12
            local.get 2
            local.get 2
            i32.const 12
            i32.add
            i32.const 4
            local.get 1
            call $_ZN198_$LT$multiversx_sc..types..managed..codec_util..managed_buffer_nested_de_input..ManagedBufferNestedDecodeInput$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_de_input..NestedDecodeInput$GT$9read_into17h75292ec7df79ebdbE
            local.get 2
            i32.load offset=12
            local.set 5
            local.get 2
            i32.load offset=4
            local.set 3
            call $mBufferNew
            local.set 6
            local.get 2
            i32.load
            local.get 3
            local.get 5
            i32.const 24
            i32.shl
            local.get 5
            i32.const 65280
            i32.and
            i32.const 8
            i32.shl
            i32.or
            local.get 5
            i32.const 8
            i32.shr_u
            i32.const 65280
            i32.and
            local.get 5
            i32.const 24
            i32.shr_u
            i32.or
            i32.or
            local.tee 5
            local.get 6
            call $mBufferCopyByteSlice
            br_if 2 (;@2;)
            local.get 3
            local.get 5
            i32.add
            local.set 4
            i32.const 1
            local.set 5
            local.get 6
            call $_ZN13multiversx_sc5types7managed7wrapped8big_uint16BigUint$LT$M$GT$20from_bytes_be_buffer17hb1d65a35a633fc91E
            local.set 3
          end
          local.get 2
          i32.load offset=8
          local.get 4
          i32.ne
          br_if 2 (;@1;)
        end
        local.get 0
        local.get 3
        i32.store offset=4
        local.get 0
        local.get 5
        i32.store
        local.get 2
        i32.const 16
        i32.add
        global.set $__stack_pointer
        return
      end
      local.get 1
      i32.const 131251
      i32.const 15
      call $_ZN147_$LT$multiversx_sc..storage..storage_get..StorageGetErrorHandler$LT$M$GT$$u20$as$u20$multiversx_sc_codec..codec_err_handler..DecodeErrorHandler$GT$12handle_error17h386838bdb262d878E
      unreachable
    end
    local.get 1
    i32.const 131237
    i32.const 14
    call $_ZN147_$LT$multiversx_sc..storage..storage_get..StorageGetErrorHandler$LT$M$GT$$u20$as$u20$multiversx_sc_codec..codec_err_handler..DecodeErrorHandler$GT$12handle_error17h386838bdb262d878E
    unreachable
  )
  (func $_ZN198_$LT$multiversx_sc..types..managed..codec_util..managed_buffer_nested_de_input..ManagedBufferNestedDecodeInput$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_de_input..NestedDecodeInput$GT$9read_into17h75292ec7df79ebdbE (;82;) (type 14) (param i32 i32 i32 i32)
    (local i32)
    block ;; label = @1
      local.get 0
      i32.load
      local.get 0
      i32.load offset=4
      local.tee 4
      local.get 1
      local.get 2
      call $_ZN26multiversx_sc_wasm_adapter3api13managed_types23managed_buffer_api_node161_$LT$impl$u20$multiversx_sc..api..managed_types..managed_buffer_api..ManagedBufferApiImpl$u20$for$u20$multiversx_sc_wasm_adapter..api..vm_api_node..VmApiImpl$GT$13mb_load_slice17h1231c44778661112E
      i32.eqz
      br_if 0 (;@1;)
      local.get 3
      call $_ZN198_$LT$multiversx_sc..types..managed..codec_util..managed_buffer_nested_de_input..ManagedBufferNestedDecodeInput$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_de_input..NestedDecodeInput$GT$9peek_into28_$u7b$$u7b$closure$u7d$$u7d$17h76e3f4fbb94a3286E
      unreachable
    end
    local.get 0
    local.get 4
    local.get 2
    i32.add
    i32.store offset=4
  )
  (func $_ZN13multiversx_sc8log_util18serialize_log_data17he05a29f69580e963E (;83;) (type 3) (param i32) (result i32)
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h1e279485930b6512E
    drop
    local.get 0
    call $_ZN13multiversx_sc5types7managed7wrapped8big_uint16BigUint$LT$M$GT$18to_bytes_be_buffer17hec98bdc195bcc87eE
  )
  (func $_ZN13multiversx_sc8log_util21serialize_event_topic17h36457962dd395fdaE (;84;) (type 0) (param i32 i32)
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h1e279485930b6512E
    drop
    local.get 0
    local.get 1
    call $_ZN115_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h2a3c94b7e254c05cE
    call $_ZN13multiversx_sc5types7managed7wrapped11managed_vec23ManagedVec$LT$M$C$T$GT$4push17hf74ffcf752ff0ac8E
  )
  (func $_ZN13multiversx_sc8log_util23event_topic_accumulator17h0aaa8582c16d749aE (;85;) (type 1) (result i32)
    (local i32)
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h1e279485930b6512E
    local.tee 0
    i32.const 1
    i32.const 0
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$14new_from_bytes17h82e8fb451363e092E
    call $_ZN13multiversx_sc5types7managed7wrapped11managed_vec23ManagedVec$LT$M$C$T$GT$4push17hf74ffcf752ff0ac8E
    local.get 0
  )
  (func $_ZN141_$LT$multiversx_sc..storage..mappers..source..CurrentStorage$u20$as$u20$multiversx_sc..storage..mappers..source..StorageAddress$LT$SA$GT$$GT$19address_storage_get17h67add4529adee6d1E (;86;) (type 3) (param i32) (result i32)
    (local i32)
    block ;; label = @1
      local.get 0
      call $_ZN13multiversx_sc7storage11storage_get24StorageGetInput$LT$A$GT$17to_managed_buffer17h1055d7794ba1a69eE
      local.tee 1
      call $mBufferGetLength
      i32.const 32
      i32.eq
      br_if 0 (;@1;)
      local.get 0
      i32.const 131634
      i32.const 16
      call $_ZN147_$LT$multiversx_sc..storage..storage_get..StorageGetErrorHandler$LT$M$GT$$u20$as$u20$multiversx_sc_codec..codec_err_handler..DecodeErrorHandler$GT$12handle_error17h386838bdb262d878E
      unreachable
    end
    local.get 1
  )
  (func $_ZN142_$LT$multiversx_sc..storage..storage_set..StorageSetOutput$LT$A$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$12set_slice_u817hdf5ef4d336a41c07E (;87;) (type 13) (param i32 i32 i32)
    local.get 0
    local.get 1
    local.get 2
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$14new_from_bytes17h82e8fb451363e092E
    call $mBufferStorageStore
    drop
  )
  (func $_ZN14ping_pong_test12PingPongTest15pong_by_user_id17h11161e81effb9b25E (;88;) (type 0) (param i32 i32)
    (local i32 i32 i32)
    i32.const 131399
    local.set 2
    i32.const 24
    local.set 3
    block ;; label = @1
      block ;; label = @2
        block ;; label = @3
          block ;; label = @4
            local.get 1
            call $_ZN50_$LT$C$u20$as$u20$ping_pong_test..PingPongTest$GT$11user_status17h0d02f78b111ba8eeE
            call $_ZN13multiversx_sc7storage7mappers19single_value_mapper35SingleValueMapper$LT$SA$C$T$C$A$GT$3get17h1c0ceedad7ce9c02E
            i32.const 255
            i32.and
            br_table 3 (;@1;) 0 (;@4;) 1 (;@3;) 3 (;@1;)
          end
          local.get 1
          call $_ZN50_$LT$C$u20$as$u20$ping_pong_test..PingPongTest$GT$11user_status17h0d02f78b111ba8eeE
          i64.const 2
          call $_ZN19multiversx_sc_codec6single13top_en_output15TopEncodeOutput7set_u6417hb78e14ded25daa4eE
          i32.const 12
          local.set 3
          call $_ZN50_$LT$C$u20$as$u20$ping_pong_test..PingPongTest$GT$11user_mapper17h29692d25e0d07d21E
          local.get 1
          call $_ZN13multiversx_sc7storage7mappers11user_mapper24UserMapper$LT$SA$C$A$GT$20get_user_address_key17h2ad72733154dc6e4E
          local.tee 2
          call $_ZN13multiversx_sc7storage11storage_get24StorageGetInput$LT$A$GT$23load_len_managed_buffer17h16e8cb9d1f3f2629E
          br_if 1 (;@2;)
          i32.const 131423
          local.set 2
          br 2 (;@1;)
        end
        i32.const 131435
        local.set 2
        i32.const 17
        local.set 3
        br 1 (;@1;)
      end
      local.get 2
      call $_ZN141_$LT$multiversx_sc..storage..mappers..source..CurrentStorage$u20$as$u20$multiversx_sc..storage..mappers..source..StorageAddress$LT$SA$GT$$GT$19address_storage_get17h67add4529adee6d1E
      local.tee 2
      call $_ZN50_$LT$C$u20$as$u20$ping_pong_test..PingPongTest$GT$11ping_amount17haa8f64fbf059fe9bE
      call $_ZN13multiversx_sc7storage7mappers19single_value_mapper35SingleValueMapper$LT$SA$C$T$C$A$GT$3get17h0391073f973cf385E
      local.tee 1
      i64.const 0
      call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h1e279485930b6512E
      call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h1e279485930b6512E
      call $managedTransferValueExecute
      drop
      call $_ZN13multiversx_sc8log_util23event_topic_accumulator17h0aaa8582c16d749aE
      local.tee 4
      local.get 2
      call $_ZN13multiversx_sc8log_util21serialize_event_topic17h36457962dd395fdaE
      local.get 4
      local.get 1
      call $_ZN13multiversx_sc8log_util18serialize_log_data17he05a29f69580e963E
      call $managedWriteLog
      i32.const 0
      local.set 2
    end
    local.get 0
    local.get 3
    i32.store offset=4
    local.get 0
    local.get 2
    i32.store
  )
  (func $_ZN50_$LT$C$u20$as$u20$ping_pong_test..PingPongTest$GT$11user_status17h0d02f78b111ba8eeE (;89;) (type 3) (param i32) (result i32)
    (local i32)
    i32.const 131664
    i32.const 10
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$14new_from_bytes17h82e8fb451363e092E
    local.tee 1
    local.get 0
    call $_ZN13multiversx_sc7storage11storage_key19StorageKey$LT$A$GT$11append_item17h693637499c66dd6fE
    local.get 1
  )
  (func $_ZN19multiversx_sc_codec6single13top_en_output15TopEncodeOutput7set_u6417hb78e14ded25daa4eE (;90;) (type 16) (param i32 i64)
    (local i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 2
    global.set $__stack_pointer
    local.get 2
    local.get 1
    local.get 2
    i32.const 8
    i32.add
    call $_ZN19multiversx_sc_codec8num_conv17top_encode_number17h7324a026905601a7E
    local.get 0
    local.get 2
    i32.load
    local.get 2
    i32.load offset=4
    call $_ZN142_$LT$multiversx_sc..storage..storage_set..StorageSetOutput$LT$A$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$12set_slice_u817hdf5ef4d336a41c07E
    local.get 2
    i32.const 16
    i32.add
    global.set $__stack_pointer
  )
  (func $_ZN50_$LT$C$u20$as$u20$ping_pong_test..PingPongTest$GT$11user_mapper17h29692d25e0d07d21E (;91;) (type 1) (result i32)
    i32.const 131660
    i32.const 4
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$14new_from_bytes17h82e8fb451363e092E
  )
  (func $_ZN50_$LT$C$u20$as$u20$ping_pong_test..PingPongTest$GT$11ping_amount17haa8f64fbf059fe9bE (;92;) (type 1) (result i32)
    i32.const 131650
    i32.const 10
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$14new_from_bytes17h82e8fb451363e092E
  )
  (func $_ZN14ping_pong_test12PingPongTest4init17h50bca30d6406de7cE (;93;) (type 17) (param i32 i64 i64 i64 i32 i32)
    call $_ZN50_$LT$C$u20$as$u20$ping_pong_test..PingPongTest$GT$11ping_amount17haa8f64fbf059fe9bE
    local.get 0
    call $_ZN13multiversx_sc5types7managed7wrapped8big_uint16BigUint$LT$M$GT$18to_bytes_be_buffer17hec98bdc195bcc87eE
    call $mBufferStorageStore
    drop
    block ;; label = @1
      local.get 2
      i32.wrap_i64
      i32.const 1
      i32.and
      br_if 0 (;@1;)
      call $getBlockTimestamp
      local.set 3
    end
    call $_ZN50_$LT$C$u20$as$u20$ping_pong_test..PingPongTest$GT$8deadline17heaa721fc0bdc2faeE
    local.get 3
    local.get 1
    i64.add
    call $_ZN19multiversx_sc_codec6single13top_en_output15TopEncodeOutput7set_u6417hb78e14ded25daa4eE
    call $_ZN50_$LT$C$u20$as$u20$ping_pong_test..PingPongTest$GT$20activation_timestamp17hb2a0cc51c935e510E
    local.get 3
    call $_ZN19multiversx_sc_codec6single13top_en_output15TopEncodeOutput7set_u6417hb78e14ded25daa4eE
    call $_ZN50_$LT$C$u20$as$u20$ping_pong_test..PingPongTest$GT$9max_funds17h620f745426f6a455E
    local.set 0
    block ;; label = @1
      local.get 4
      br_if 0 (;@1;)
      i32.const 1
      i32.const 0
      call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$14new_from_bytes17h82e8fb451363e092E
      local.tee 4
      i32.const 1
      call $_ZN19multiversx_sc_codec6single16nested_en_output18NestedEncodeOutput9push_byte17h1eaed3347978f1d5E
      local.get 5
      local.get 4
      call $_ZN139_$LT$multiversx_sc..types..managed..wrapped..big_uint..BigUint$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en..NestedEncode$GT$24dep_encode_or_handle_err17h89cb528c5accd023E
      local.get 0
      local.get 4
      call $mBufferStorageStore
      drop
      return
    end
    local.get 0
    i32.const 1
    i32.const 0
    call $_ZN142_$LT$multiversx_sc..storage..storage_set..StorageSetOutput$LT$A$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$12set_slice_u817hdf5ef4d336a41c07E
  )
  (func $_ZN50_$LT$C$u20$as$u20$ping_pong_test..PingPongTest$GT$8deadline17heaa721fc0bdc2faeE (;94;) (type 1) (result i32)
    i32.const 131708
    i32.const 8
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$14new_from_bytes17h82e8fb451363e092E
  )
  (func $_ZN50_$LT$C$u20$as$u20$ping_pong_test..PingPongTest$GT$20activation_timestamp17hb2a0cc51c935e510E (;95;) (type 1) (result i32)
    i32.const 131689
    i32.const 19
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$14new_from_bytes17h82e8fb451363e092E
  )
  (func $_ZN50_$LT$C$u20$as$u20$ping_pong_test..PingPongTest$GT$9max_funds17h620f745426f6a455E (;96;) (type 1) (result i32)
    i32.const 131716
    i32.const 8
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$14new_from_bytes17h82e8fb451363e092E
  )
  (func $_ZN19multiversx_sc_codec6single16nested_en_output18NestedEncodeOutput9push_byte17h1eaed3347978f1d5E (;97;) (type 0) (param i32 i32)
    (local i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 2
    global.set $__stack_pointer
    local.get 2
    local.get 1
    i32.store8 offset=15
    local.get 0
    local.get 2
    i32.const 15
    i32.add
    i32.const 1
    call $mBufferAppendBytes
    drop
    local.get 2
    i32.const 16
    i32.add
    global.set $__stack_pointer
  )
  (func $_ZN163_$LT$multiversx_sc..types..managed..wrapped..managed_vec_iter_payload..ManagedVecPayloadIterator$LT$M$C$P$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17hc9b8e2d723e948cbE (;98;) (type 0) (param i32 i32)
    (local i32 i32 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 2
    global.set $__stack_pointer
    i32.const 0
    local.set 3
    block ;; label = @1
      local.get 1
      i32.load offset=4
      local.tee 4
      local.get 1
      i32.load offset=8
      i32.ge_u
      br_if 0 (;@1;)
      local.get 2
      i32.const 0
      i32.store offset=12
      local.get 1
      i32.load
      local.get 4
      local.get 2
      i32.const 12
      i32.add
      i32.const 4
      call $_ZN26multiversx_sc_wasm_adapter3api13managed_types23managed_buffer_api_node161_$LT$impl$u20$multiversx_sc..api..managed_types..managed_buffer_api..ManagedBufferApiImpl$u20$for$u20$multiversx_sc_wasm_adapter..api..vm_api_node..VmApiImpl$GT$13mb_load_slice17h1231c44778661112E
      drop
      local.get 1
      local.get 4
      i32.const 4
      i32.add
      i32.store offset=4
      local.get 0
      local.get 2
      i32.load offset=12
      i32.store offset=1 align=1
      i32.const 1
      local.set 3
    end
    local.get 0
    local.get 3
    i32.store8
    local.get 2
    i32.const 16
    i32.add
    global.set $__stack_pointer
  )
  (func $_ZN198_$LT$multiversx_sc..types..managed..codec_util..managed_buffer_nested_de_input..ManagedBufferNestedDecodeInput$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_de_input..NestedDecodeInput$GT$9peek_into28_$u7b$$u7b$closure$u7d$$u7d$17h76e3f4fbb94a3286E (;99;) (type 5) (param i32)
    local.get 0
    i32.const 131251
    i32.const 15
    call $_ZN147_$LT$multiversx_sc..storage..storage_get..StorageGetErrorHandler$LT$M$GT$$u20$as$u20$multiversx_sc_codec..codec_err_handler..DecodeErrorHandler$GT$12handle_error17h386838bdb262d878E
    unreachable
  )
  (func $_ZN198_$LT$multiversx_sc..types..managed..codec_util..managed_buffer_nested_de_input..ManagedBufferNestedDecodeInput$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_de_input..NestedDecodeInput$GT$9peek_into28_$u7b$$u7b$closure$u7d$$u7d$17hebf07c878f59f3daE (;100;) (type 11)
    i32.const 131603
    i32.const 24
    i32.const 131251
    i32.const 15
    call $_ZN13multiversx_sc2io12signal_error19signal_arg_de_error17hb152be4bd99a2e89E
    unreachable
  )
  (func $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned86_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$u64$GT$24dep_encode_or_handle_err17h4b95e3cdd95f77b7E (;101;) (type 18) (param i64 i32)
    (local i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 2
    global.set $__stack_pointer
    local.get 2
    local.get 0
    i64.const 56
    i64.shl
    local.get 0
    i64.const 65280
    i64.and
    i64.const 40
    i64.shl
    i64.or
    local.get 0
    i64.const 16711680
    i64.and
    i64.const 24
    i64.shl
    local.get 0
    i64.const 4278190080
    i64.and
    i64.const 8
    i64.shl
    i64.or
    i64.or
    local.get 0
    i64.const 8
    i64.shr_u
    i64.const 4278190080
    i64.and
    local.get 0
    i64.const 24
    i64.shr_u
    i64.const 16711680
    i64.and
    i64.or
    local.get 0
    i64.const 40
    i64.shr_u
    i64.const 65280
    i64.and
    local.get 0
    i64.const 56
    i64.shr_u
    i64.or
    i64.or
    i64.or
    i64.store offset=8
    local.get 1
    local.get 2
    i32.const 8
    i32.add
    i32.const 8
    call $mBufferAppendBytes
    drop
    local.get 2
    i32.const 16
    i32.add
    global.set $__stack_pointer
  )
  (func $_ZN19multiversx_sc_codec6single13top_en_output15TopEncodeOutput7set_u6417h311ea26de8f8d3c1E (;102;) (type 16) (param i32 i64)
    (local i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 2
    global.set $__stack_pointer
    local.get 2
    local.get 1
    local.get 2
    i32.const 8
    i32.add
    call $_ZN19multiversx_sc_codec8num_conv17top_encode_number17h7324a026905601a7E
    local.get 0
    local.get 2
    i32.load
    local.get 2
    i32.load offset=4
    call $mBufferSetBytes
    drop
    local.get 2
    i32.const 16
    i32.add
    global.set $__stack_pointer
  )
  (func $_ZN19multiversx_sc_codec8num_conv17top_encode_number17h7324a026905601a7E (;103;) (type 19) (param i32 i64 i32)
    (local i64 i32 i32)
    local.get 2
    local.get 1
    i64.const 56
    i64.shl
    local.get 1
    i64.const 65280
    i64.and
    i64.const 40
    i64.shl
    i64.or
    local.get 1
    i64.const 16711680
    i64.and
    i64.const 24
    i64.shl
    local.get 1
    i64.const 4278190080
    i64.and
    i64.const 8
    i64.shl
    i64.or
    i64.or
    local.get 1
    i64.const 8
    i64.shr_u
    i64.const 4278190080
    i64.and
    local.get 1
    i64.const 24
    i64.shr_u
    i64.const 16711680
    i64.and
    i64.or
    local.get 1
    i64.const 40
    i64.shr_u
    local.tee 3
    i64.const 65280
    i64.and
    local.get 1
    i64.const 56
    i64.shr_u
    i64.or
    i64.or
    i64.or
    i64.store align=1
    local.get 0
    i32.const 8
    i32.const 0
    local.get 1
    i64.const 72057594037927936
    i64.lt_u
    local.tee 4
    local.get 1
    i64.const 48
    i64.shr_u
    i32.wrap_i64
    i32.const 255
    i32.and
    select
    local.tee 5
    local.get 4
    i32.add
    i32.const 0
    local.get 5
    local.get 3
    i32.wrap_i64
    i32.const 255
    i32.and
    select
    local.tee 4
    i32.add
    i32.const 0
    local.get 4
    local.get 1
    i64.const 32
    i64.shr_u
    i32.wrap_i64
    i32.const 255
    i32.and
    select
    local.tee 5
    i32.add
    i32.const 0
    local.get 5
    local.get 1
    i32.wrap_i64
    local.tee 4
    i32.const 24
    i32.shr_u
    select
    local.tee 5
    i32.add
    i32.const 0
    local.get 5
    local.get 4
    i32.const 16
    i32.shr_u
    i32.const 255
    i32.and
    select
    local.tee 5
    i32.add
    i32.const 0
    local.get 5
    local.get 4
    i32.const 8
    i32.shr_u
    i32.const 255
    i32.and
    select
    local.tee 4
    i32.add
    local.get 4
    i32.const 0
    local.get 1
    i64.eqz
    select
    i32.add
    local.tee 4
    i32.sub
    i32.store offset=4
    local.get 0
    local.get 2
    local.get 4
    i32.add
    i32.store
  )
  (func $_ZN50_$LT$C$u20$as$u20$ping_pong_test..PingPongTest$GT$18pong_all_last_user17h68d135167e2486bdE (;104;) (type 1) (result i32)
    i32.const 131674
    i32.const 15
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$14new_from_bytes17h82e8fb451363e092E
  )
  (func $init (;105;) (type 11)
    (local i32 i32 i64 i64 i64 i32 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee 0
    global.set $__stack_pointer
    call $checkNoPayment
    call $_ZN13multiversx_sc2io16arg_nested_tuple26init_arguments_static_data17h60cc3ba5036bf72dE
    i32.const 3
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_ge17hede2fb20e6ddc134E
    call $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17h98b79247857ed50eE
    local.set 1
    call $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17he06a9b2edc2f9783E
    local.set 2
    local.get 0
    i32.const 16
    i32.add
    call $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17h595511fd1da80044E
    local.get 0
    i64.load offset=24
    local.set 3
    local.get 0
    i64.load offset=16
    local.set 4
    local.get 0
    i32.const 3
    i32.store offset=16
    local.get 0
    i32.const 8
    i32.add
    local.get 0
    i32.const 16
    i32.add
    call $_ZN13multiversx_sc2io16arg_nested_tuple14load_multi_arg17h8d7eda2a6d467ad9E
    local.get 0
    i32.load offset=12
    local.set 5
    local.get 0
    i32.load offset=8
    local.set 6
    local.get 0
    i32.load offset=16
    call $_ZN13multiversx_sc2io16arg_nested_tuple18check_no_more_args17hf0137016c3221a08E
    local.get 1
    local.get 2
    local.get 4
    local.get 3
    local.get 6
    local.get 5
    call $_ZN14ping_pong_test12PingPongTest4init17h50bca30d6406de7cE
    local.get 0
    i32.const 32
    i32.add
    global.set $__stack_pointer
  )
  (func $upgrade (;106;) (type 11)
    (local i32 i32 i64 i64 i64 i32 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee 0
    global.set $__stack_pointer
    call $checkNoPayment
    call $_ZN13multiversx_sc2io16arg_nested_tuple26init_arguments_static_data17h60cc3ba5036bf72dE
    i32.const 3
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_ge17hede2fb20e6ddc134E
    call $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17h98b79247857ed50eE
    local.set 1
    call $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17he06a9b2edc2f9783E
    local.set 2
    local.get 0
    i32.const 16
    i32.add
    call $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17h595511fd1da80044E
    local.get 0
    i64.load offset=24
    local.set 3
    local.get 0
    i64.load offset=16
    local.set 4
    local.get 0
    i32.const 3
    i32.store offset=16
    local.get 0
    i32.const 8
    i32.add
    local.get 0
    i32.const 16
    i32.add
    call $_ZN13multiversx_sc2io16arg_nested_tuple14load_multi_arg17h8d7eda2a6d467ad9E
    local.get 0
    i32.load offset=12
    local.set 5
    local.get 0
    i32.load offset=8
    local.set 6
    local.get 0
    i32.load offset=16
    call $_ZN13multiversx_sc2io16arg_nested_tuple18check_no_more_args17hf0137016c3221a08E
    local.get 1
    local.get 2
    local.get 4
    local.get 3
    local.get 6
    local.get 5
    call $_ZN14ping_pong_test12PingPongTest4init17h50bca30d6406de7cE
    local.get 0
    i32.const 32
    i32.add
    global.set $__stack_pointer
  )
  (func $ping (;107;) (type 11)
    (local i32 i32 i64 i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 0
    global.set $__stack_pointer
    call $_ZN13multiversx_sc13contract_base8wrappers18call_value_wrapper25CallValueWrapper$LT$A$GT$4egld17h500d89ddeb471ed0E
    drop
    call $_ZN13multiversx_sc2io16arg_nested_tuple26init_arguments_static_data17h60cc3ba5036bf72dE
    i32.const 0
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_ge17hede2fb20e6ddc134E
    local.get 0
    i32.const 12
    i32.add
    call $_ZN13multiversx_sc2io16arg_nested_tuple14load_multi_arg17hb9c1aa8cc3bf7119E
    local.get 0
    i32.load offset=12
    call $_ZN13multiversx_sc2io16arg_nested_tuple18check_no_more_args17hf0137016c3221a08E
    block ;; label = @1
      block ;; label = @2
        block ;; label = @3
          call $_ZN13multiversx_sc13contract_base8wrappers18call_value_wrapper25CallValueWrapper$LT$A$GT$4egld17h500d89ddeb471ed0E
          local.tee 1
          call $_ZN50_$LT$C$u20$as$u20$ping_pong_test..PingPongTest$GT$11ping_amount17haa8f64fbf059fe9bE
          call $_ZN13multiversx_sc7storage7mappers19single_value_mapper35SingleValueMapper$LT$SA$C$T$C$A$GT$3get17h0391073f973cf385E
          call $bigIntCmp
          br_if 0 (;@3;)
          call $getBlockTimestamp
          local.set 2
          call $_ZN50_$LT$C$u20$as$u20$ping_pong_test..PingPongTest$GT$20activation_timestamp17hb2a0cc51c935e510E
          call $_ZN13multiversx_sc7storage7mappers19single_value_mapper35SingleValueMapper$LT$SA$C$T$C$A$GT$3get17h656de0b911e2d985E
          local.get 2
          i64.gt_u
          br_if 1 (;@2;)
          local.get 2
          call $_ZN50_$LT$C$u20$as$u20$ping_pong_test..PingPongTest$GT$8deadline17heaa721fc0bdc2faeE
          call $_ZN13multiversx_sc7storage7mappers19single_value_mapper35SingleValueMapper$LT$SA$C$T$C$A$GT$3get17h656de0b911e2d985E
          i64.ge_u
          br_if 2 (;@1;)
          local.get 0
          call $_ZN50_$LT$C$u20$as$u20$ping_pong_test..PingPongTest$GT$9max_funds17h620f745426f6a455E
          call $_ZN13multiversx_sc7storage7mappers19single_value_mapper35SingleValueMapper$LT$SA$C$T$C$A$GT$3get17hf795bca050ba19baE
          block ;; label = @4
            block ;; label = @5
              block ;; label = @6
                block ;; label = @7
                  block ;; label = @8
                    local.get 0
                    i32.load
                    i32.const 1
                    i32.and
                    i32.eqz
                    br_if 0 (;@8;)
                    local.get 0
                    i32.load offset=4
                    local.set 3
                    i32.const 131327
                    i32.const 11
                    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$14new_from_bytes17h82e8fb451363e092E
                    local.tee 4
                    call $_ZN13multiversx_sc5types7managed7wrapped29egld_or_esdt_token_identifier34EgldOrEsdtTokenIdentifier$LT$M$GT$7is_egld17h2ded2bffc2497867E
                    local.set 5
                    call $_ZN13multiversx_sc13contract_base8wrappers18blockchain_wrapper26BlockchainWrapper$LT$A$GT$14get_sc_address17h7db029c54afa28f0E
                    local.set 6
                    call $_ZN26multiversx_sc_wasm_adapter3api13managed_types19static_var_api_node11next_handle17h140133c4fd796bd1E
                    local.set 7
                    block ;; label = @9
                      block ;; label = @10
                        local.get 5
                        br_if 0 (;@10;)
                        local.get 4
                        call $mBufferGetLength
                        local.set 5
                        local.get 6
                        call $_ZN26multiversx_sc_wasm_adapter3api13managed_types23managed_buffer_api_node26unsafe_buffer_load_address17hbbb94c7ff9c62f38E
                        local.get 4
                        i32.const 131785
                        call $mBufferGetBytes
                        drop
                        i32.const 131753
                        i32.const 131785
                        local.get 5
                        i64.const 0
                        local.get 7
                        call $bigIntGetESDTExternalBalance
                        br 1 (;@9;)
                      end
                      local.get 6
                      call $_ZN26multiversx_sc_wasm_adapter3api13managed_types23managed_buffer_api_node26unsafe_buffer_load_address17hbbb94c7ff9c62f38E
                      i32.const 131753
                      local.get 7
                      call $bigIntGetExternalBalance
                    end
                    call $_ZN26multiversx_sc_wasm_adapter3api13managed_types19static_var_api_node11next_handle17h140133c4fd796bd1E
                    local.tee 4
                    local.get 7
                    local.get 1
                    call $bigIntAdd
                    local.get 4
                    local.get 3
                    call $bigIntCmp
                    i32.const 0
                    i32.gt_s
                    br_if 1 (;@7;)
                  end
                  call $_ZN13multiversx_sc13contract_base8wrappers18blockchain_wrapper26BlockchainWrapper$LT$A$GT$10get_caller17ha48e4e017c8b0a66E
                  local.set 7
                  block ;; label = @8
                    call $_ZN50_$LT$C$u20$as$u20$ping_pong_test..PingPongTest$GT$11user_mapper17h29692d25e0d07d21E
                    local.tee 4
                    local.get 7
                    call $_ZN13multiversx_sc7storage7mappers11user_mapper24UserMapper$LT$SA$C$A$GT$11get_user_id17hc28b18b625a9972dE
                    local.tee 3
                    br_if 0 (;@8;)
                    local.get 4
                    call $_ZN13multiversx_sc7storage7mappers11user_mapper24UserMapper$LT$SA$C$A$GT$14get_user_count17h7f4b629dafd192a7E
                    local.set 3
                    local.get 4
                    call $_ZN13multiversx_sc7storage7mappers11user_mapper24UserMapper$LT$SA$C$A$GT$18get_user_count_key17h57ecf9e31045b086E
                    local.get 3
                    i32.const 1
                    i32.add
                    local.tee 3
                    i64.extend_i32_u
                    local.tee 2
                    call $_ZN19multiversx_sc_codec6single13top_en_output15TopEncodeOutput7set_u6417hb78e14ded25daa4eE
                    local.get 4
                    local.get 7
                    call $_ZN13multiversx_sc7storage7mappers11user_mapper24UserMapper$LT$SA$C$A$GT$15get_user_id_key17hbdbca7372b177083E
                    local.get 2
                    call $_ZN19multiversx_sc_codec6single13top_en_output15TopEncodeOutput7set_u6417hb78e14ded25daa4eE
                    local.get 4
                    local.get 3
                    call $_ZN13multiversx_sc7storage7mappers11user_mapper24UserMapper$LT$SA$C$A$GT$20get_user_address_key17h2ad72733154dc6e4E
                    local.get 7
                    call $mBufferStorageStore
                    drop
                  end
                  local.get 3
                  call $_ZN50_$LT$C$u20$as$u20$ping_pong_test..PingPongTest$GT$11user_status17h0d02f78b111ba8eeE
                  call $_ZN13multiversx_sc7storage7mappers19single_value_mapper35SingleValueMapper$LT$SA$C$T$C$A$GT$3get17h1c0ceedad7ce9c02E
                  i32.const 255
                  i32.and
                  br_table 3 (;@4;) 1 (;@6;) 2 (;@5;) 3 (;@4;)
                end
                i32.const 131536
                i32.const 19
                call $_ZN13multiversx_sc13contract_base8wrappers12error_helper20ErrorHelper$LT$M$GT$25signal_error_with_message17he08d9f3729d44387E
                unreachable
              end
              i32.const 131555
              i32.const 18
              call $_ZN13multiversx_sc13contract_base8wrappers12error_helper20ErrorHelper$LT$M$GT$25signal_error_with_message17he08d9f3729d44387E
              unreachable
            end
            i32.const 131435
            i32.const 17
            call $_ZN13multiversx_sc13contract_base8wrappers12error_helper20ErrorHelper$LT$M$GT$25signal_error_with_message17he08d9f3729d44387E
            unreachable
          end
          local.get 3
          call $_ZN50_$LT$C$u20$as$u20$ping_pong_test..PingPongTest$GT$11user_status17h0d02f78b111ba8eeE
          i64.const 1
          call $_ZN19multiversx_sc_codec6single13top_en_output15TopEncodeOutput7set_u6417hb78e14ded25daa4eE
          call $_ZN13multiversx_sc8log_util23event_topic_accumulator17h0aaa8582c16d749aE
          local.tee 3
          local.get 7
          call $_ZN13multiversx_sc8log_util21serialize_event_topic17h36457962dd395fdaE
          local.get 3
          local.get 1
          call $_ZN13multiversx_sc8log_util18serialize_log_data17he05a29f69580e963E
          call $managedWriteLog
          local.get 0
          i32.const 16
          i32.add
          global.set $__stack_pointer
          return
        end
        i32.const 131452
        i32.const 36
        call $_ZN13multiversx_sc13contract_base8wrappers12error_helper20ErrorHelper$LT$M$GT$25signal_error_with_message17he08d9f3729d44387E
        unreachable
      end
      i32.const 131488
      i32.const 29
      call $_ZN13multiversx_sc13contract_base8wrappers12error_helper20ErrorHelper$LT$M$GT$25signal_error_with_message17he08d9f3729d44387E
      unreachable
    end
    i32.const 131517
    i32.const 19
    call $_ZN13multiversx_sc13contract_base8wrappers12error_helper20ErrorHelper$LT$M$GT$25signal_error_with_message17he08d9f3729d44387E
    unreachable
  )
  (func $_ZN26multiversx_sc_wasm_adapter3api13managed_types23managed_buffer_api_node26unsafe_buffer_load_address17hbbb94c7ff9c62f38E (;108;) (type 5) (param i32)
    local.get 0
    i32.const 131753
    call $mBufferGetBytes
    drop
  )
  (func $pong (;109;) (type 11)
    (local i32 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 0
    global.set $__stack_pointer
    call $checkNoPayment
    i32.const 0
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_eq17hb6cfff90ed14e47cE
    block ;; label = @1
      block ;; label = @2
        call $getBlockTimestamp
        call $_ZN50_$LT$C$u20$as$u20$ping_pong_test..PingPongTest$GT$8deadline17heaa721fc0bdc2faeE
        call $_ZN13multiversx_sc7storage7mappers19single_value_mapper35SingleValueMapper$LT$SA$C$T$C$A$GT$3get17h656de0b911e2d985E
        i64.lt_u
        br_if 0 (;@2;)
        call $_ZN13multiversx_sc13contract_base8wrappers18blockchain_wrapper26BlockchainWrapper$LT$A$GT$10get_caller17ha48e4e017c8b0a66E
        local.set 1
        local.get 0
        i32.const 8
        i32.add
        call $_ZN50_$LT$C$u20$as$u20$ping_pong_test..PingPongTest$GT$11user_mapper17h29692d25e0d07d21E
        local.get 1
        call $_ZN13multiversx_sc7storage7mappers11user_mapper24UserMapper$LT$SA$C$A$GT$11get_user_id17hc28b18b625a9972dE
        call $_ZN14ping_pong_test12PingPongTest15pong_by_user_id17h11161e81effb9b25E
        local.get 0
        i32.load offset=8
        local.tee 1
        br_if 1 (;@1;)
        local.get 0
        i32.const 16
        i32.add
        global.set $__stack_pointer
        return
      end
      i32.const 131573
      i32.const 30
      call $_ZN13multiversx_sc13contract_base8wrappers12error_helper20ErrorHelper$LT$M$GT$25signal_error_with_message17he08d9f3729d44387E
      unreachable
    end
    local.get 1
    local.get 0
    i32.load offset=12
    call $_ZN13multiversx_sc13contract_base8wrappers12error_helper20ErrorHelper$LT$M$GT$25signal_error_with_message17he08d9f3729d44387E
    unreachable
  )
  (func $pongAll (;110;) (type 11)
    (local i32 i64 i32 i32 i64 i32 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 0
    global.set $__stack_pointer
    call $checkNoPayment
    i32.const 0
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_eq17hb6cfff90ed14e47cE
    block ;; label = @1
      block ;; label = @2
        block ;; label = @3
          call $getBlockTimestamp
          local.tee 1
          call $_ZN50_$LT$C$u20$as$u20$ping_pong_test..PingPongTest$GT$8deadline17heaa721fc0bdc2faeE
          call $_ZN13multiversx_sc7storage7mappers19single_value_mapper35SingleValueMapper$LT$SA$C$T$C$A$GT$3get17h656de0b911e2d985E
          i64.lt_u
          br_if 0 (;@3;)
          call $_ZN50_$LT$C$u20$as$u20$ping_pong_test..PingPongTest$GT$11user_mapper17h29692d25e0d07d21E
          call $_ZN13multiversx_sc7storage7mappers11user_mapper24UserMapper$LT$SA$C$A$GT$14get_user_count17h7f4b629dafd192a7E
          local.set 2
          call $_ZN50_$LT$C$u20$as$u20$ping_pong_test..PingPongTest$GT$18pong_all_last_user17h68d135167e2486bdE
          call $_ZN141_$LT$multiversx_sc..storage..mappers..source..CurrentStorage$u20$as$u20$multiversx_sc..storage..mappers..source..StorageAddress$LT$SA$GT$$GT$19address_storage_get17hecf8779266aedeeaE
          local.tee 3
          local.get 2
          local.get 3
          local.get 2
          i32.gt_u
          select
          local.set 2
          loop ;; label = @4
            local.get 2
            local.get 3
            i32.eq
            br_if 2 (;@2;)
            block ;; label = @5
              call $getGasLeft
              i64.const 3000000
              i64.lt_u
              br_if 0 (;@5;)
              local.get 0
              i32.const 8
              i32.add
              local.get 3
              i32.const 1
              i32.add
              local.tee 3
              call $_ZN14ping_pong_test12PingPongTest15pong_by_user_id17h11161e81effb9b25E
              br 1 (;@4;)
            end
          end
          call $_ZN50_$LT$C$u20$as$u20$ping_pong_test..PingPongTest$GT$18pong_all_last_user17h68d135167e2486bdE
          local.get 3
          i64.extend_i32_u
          local.tee 4
          call $_ZN19multiversx_sc_codec6single13top_en_output15TopEncodeOutput7set_u6417hb78e14ded25daa4eE
          i32.const 11
          local.set 2
          i32.const 131733
          local.set 5
          br 2 (;@1;)
        end
        i32.const 131573
        i32.const 30
        call $_ZN13multiversx_sc13contract_base8wrappers12error_helper20ErrorHelper$LT$M$GT$25signal_error_with_message17he08d9f3729d44387E
        unreachable
      end
      i64.const 0
      local.set 4
      call $_ZN50_$LT$C$u20$as$u20$ping_pong_test..PingPongTest$GT$18pong_all_last_user17h68d135167e2486bdE
      i64.const 0
      call $_ZN19multiversx_sc_codec6single13top_en_output15TopEncodeOutput7set_u6417hb78e14ded25daa4eE
      i32.const 9
      local.set 2
      i32.const 131724
      local.set 5
    end
    call $_ZN13multiversx_sc8log_util23event_topic_accumulator17h0aaa8582c16d749aE
    local.set 3
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h1e279485930b6512E
    local.tee 6
    local.get 1
    call $_ZN19multiversx_sc_codec6single13top_en_output15TopEncodeOutput7set_u6417h311ea26de8f8d3c1E
    local.get 3
    local.get 6
    call $_ZN13multiversx_sc5types7managed7wrapped11managed_vec23ManagedVec$LT$M$C$T$GT$4push17hf74ffcf752ff0ac8E
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h1e279485930b6512E
    local.tee 6
    local.get 5
    local.get 2
    call $mBufferSetBytes
    drop
    local.get 3
    local.get 6
    call $_ZN13multiversx_sc5types7managed7wrapped11managed_vec23ManagedVec$LT$M$C$T$GT$4push17hf74ffcf752ff0ac8E
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h1e279485930b6512E
    local.tee 6
    local.get 4
    call $_ZN19multiversx_sc_codec6single13top_en_output15TopEncodeOutput7set_u6417h311ea26de8f8d3c1E
    local.get 3
    local.get 6
    call $_ZN13multiversx_sc5types7managed7wrapped11managed_vec23ManagedVec$LT$M$C$T$GT$4push17hf74ffcf752ff0ac8E
    local.get 3
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h1e279485930b6512E
    call $managedWriteLog
    local.get 5
    local.get 2
    call $finish
    local.get 0
    i32.const 16
    i32.add
    global.set $__stack_pointer
  )
  (func $getUserAddresses (;111;) (type 11)
    (local i32 i32 i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee 0
    global.set $__stack_pointer
    call $checkNoPayment
    i32.const 0
    local.set 1
    i32.const 0
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_eq17hb6cfff90ed14e47cE
    call $_ZN50_$LT$C$u20$as$u20$ping_pong_test..PingPongTest$GT$11user_mapper17h29692d25e0d07d21E
    local.tee 2
    call $_ZN13multiversx_sc7storage7mappers11user_mapper24UserMapper$LT$SA$C$A$GT$14get_user_count17h7f4b629dafd192a7E
    local.set 3
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h1e279485930b6512E
    local.set 4
    i32.const 1
    local.set 5
    block ;; label = @1
      loop ;; label = @2
        local.get 1
        i32.const 1
        i32.and
        br_if 1 (;@1;)
        local.get 5
        local.get 3
        i32.gt_u
        br_if 1 (;@1;)
        block ;; label = @3
          block ;; label = @4
            local.get 2
            local.get 5
            call $_ZN13multiversx_sc7storage7mappers11user_mapper24UserMapper$LT$SA$C$A$GT$20get_user_address_key17h2ad72733154dc6e4E
            local.tee 6
            call $_ZN13multiversx_sc7storage11storage_get24StorageGetInput$LT$A$GT$23load_len_managed_buffer17h16e8cb9d1f3f2629E
            br_if 0 (;@4;)
            i32.const 131295
            i32.const 32
            call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$14new_from_bytes17h82e8fb451363e092E
            local.set 6
            br 1 (;@3;)
          end
          local.get 6
          call $_ZN141_$LT$multiversx_sc..storage..mappers..source..CurrentStorage$u20$as$u20$multiversx_sc..storage..mappers..source..StorageAddress$LT$SA$GT$$GT$19address_storage_get17h67add4529adee6d1E
          local.set 6
        end
        local.get 5
        local.get 3
        i32.ge_u
        local.set 1
        local.get 5
        local.get 5
        local.get 3
        i32.lt_u
        i32.add
        local.set 5
        local.get 0
        local.get 6
        i32.const 24
        i32.shl
        local.get 6
        i32.const 65280
        i32.and
        i32.const 8
        i32.shl
        i32.or
        local.get 6
        i32.const 8
        i32.shr_u
        i32.const 65280
        i32.and
        local.get 6
        i32.const 24
        i32.shr_u
        i32.or
        i32.or
        i32.store offset=12
        local.get 4
        local.get 0
        i32.const 12
        i32.add
        i32.const 4
        call $mBufferAppendBytes
        drop
        br 0 (;@2;)
      end
    end
    call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h1e279485930b6512E
    local.set 6
    local.get 0
    local.get 4
    call $mBufferGetLength
    i32.store offset=20
    local.get 0
    i32.const 0
    i32.store offset=16
    local.get 0
    local.get 4
    i32.store offset=12
    block ;; label = @1
      loop ;; label = @2
        local.get 0
        i32.const 27
        i32.add
        local.get 0
        i32.const 12
        i32.add
        call $_ZN163_$LT$multiversx_sc..types..managed..wrapped..managed_vec_iter_payload..ManagedVecPayloadIterator$LT$M$C$P$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17hc9b8e2d723e948cbE
        local.get 0
        i32.load8_u offset=27
        i32.const 1
        i32.ne
        br_if 1 (;@1;)
        local.get 0
        i32.load offset=28 align=1
        local.set 5
        call $_ZN13multiversx_sc5types7managed5basic14managed_buffer22ManagedBuffer$LT$M$GT$3new17h1e279485930b6512E
        drop
        local.get 6
        local.get 5
        i32.const 24
        i32.shl
        local.get 5
        i32.const 65280
        i32.and
        i32.const 8
        i32.shl
        i32.or
        local.get 5
        i32.const 8
        i32.shr_u
        i32.const 65280
        i32.and
        local.get 5
        i32.const 24
        i32.shr_u
        i32.or
        i32.or
        call $_ZN115_$LT$multiversx_sc..types..managed..basic..managed_buffer..ManagedBuffer$LT$M$GT$$u20$as$u20$core..clone..Clone$GT$5clone17h2a3c94b7e254c05cE
        call $_ZN13multiversx_sc5types7managed7wrapped11managed_vec23ManagedVec$LT$M$C$T$GT$4push17hf74ffcf752ff0ac8E
        br 0 (;@2;)
      end
    end
    local.get 0
    local.get 6
    call $mBufferGetLength
    i32.store offset=20
    local.get 0
    i32.const 0
    i32.store offset=16
    local.get 0
    local.get 6
    i32.store offset=12
    block ;; label = @1
      loop ;; label = @2
        local.get 0
        i32.const 27
        i32.add
        local.get 0
        i32.const 12
        i32.add
        call $_ZN163_$LT$multiversx_sc..types..managed..wrapped..managed_vec_iter_payload..ManagedVecPayloadIterator$LT$M$C$P$GT$$u20$as$u20$core..iter..traits..iterator..Iterator$GT$4next17hc9b8e2d723e948cbE
        local.get 0
        i32.load8_u offset=27
        i32.const 1
        i32.ne
        br_if 1 (;@1;)
        local.get 0
        i32.load offset=28 align=1
        local.tee 5
        i32.const 24
        i32.shl
        local.get 5
        i32.const 65280
        i32.and
        i32.const 8
        i32.shl
        i32.or
        local.get 5
        i32.const 8
        i32.shr_u
        i32.const 65280
        i32.and
        local.get 5
        i32.const 24
        i32.shr_u
        i32.or
        i32.or
        call $mBufferFinish
        drop
        br 0 (;@2;)
      end
    end
    local.get 0
    i32.const 32
    i32.add
    global.set $__stack_pointer
  )
  (func $getContractState (;112;) (type 11)
    (local i32 i32 i64 i64 i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 0
    global.set $__stack_pointer
    call $checkNoPayment
    i32.const 0
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_eq17hb6cfff90ed14e47cE
    call $_ZN50_$LT$C$u20$as$u20$ping_pong_test..PingPongTest$GT$11ping_amount17haa8f64fbf059fe9bE
    call $_ZN13multiversx_sc7storage7mappers19single_value_mapper35SingleValueMapper$LT$SA$C$T$C$A$GT$3get17h0391073f973cf385E
    local.set 1
    call $_ZN50_$LT$C$u20$as$u20$ping_pong_test..PingPongTest$GT$8deadline17heaa721fc0bdc2faeE
    call $_ZN13multiversx_sc7storage7mappers19single_value_mapper35SingleValueMapper$LT$SA$C$T$C$A$GT$3get17h656de0b911e2d985E
    local.set 2
    call $_ZN50_$LT$C$u20$as$u20$ping_pong_test..PingPongTest$GT$20activation_timestamp17hb2a0cc51c935e510E
    call $_ZN13multiversx_sc7storage7mappers19single_value_mapper35SingleValueMapper$LT$SA$C$T$C$A$GT$3get17h656de0b911e2d985E
    local.set 3
    local.get 0
    call $_ZN50_$LT$C$u20$as$u20$ping_pong_test..PingPongTest$GT$9max_funds17h620f745426f6a455E
    call $_ZN13multiversx_sc7storage7mappers19single_value_mapper35SingleValueMapper$LT$SA$C$T$C$A$GT$3get17hf795bca050ba19baE
    local.get 0
    i32.load offset=4
    local.set 4
    local.get 0
    i32.load
    local.set 5
    call $_ZN50_$LT$C$u20$as$u20$ping_pong_test..PingPongTest$GT$18pong_all_last_user17h68d135167e2486bdE
    call $_ZN141_$LT$multiversx_sc..storage..mappers..source..CurrentStorage$u20$as$u20$multiversx_sc..storage..mappers..source..StorageAddress$LT$SA$GT$$GT$19address_storage_get17hecf8779266aedeeaE
    local.set 6
    local.get 1
    call $_ZN133_$LT$multiversx_sc..io..finish..ApiOutputAdapter$LT$FA$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$19start_nested_encode17h827d95c24a3d29c9E
    local.tee 7
    call $_ZN139_$LT$multiversx_sc..types..managed..wrapped..big_uint..BigUint$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en..NestedEncode$GT$24dep_encode_or_handle_err17h89cb528c5accd023E
    local.get 2
    local.get 7
    call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned86_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$u64$GT$24dep_encode_or_handle_err17h4b95e3cdd95f77b7E
    local.get 3
    local.get 7
    call $_ZN19multiversx_sc_codec14impl_for_types17impl_num_unsigned86_$LT$impl$u20$multiversx_sc_codec..single..nested_en..NestedEncode$u20$for$u20$u64$GT$24dep_encode_or_handle_err17h4b95e3cdd95f77b7E
    block ;; label = @1
      block ;; label = @2
        local.get 5
        i32.const 1
        i32.and
        i32.eqz
        br_if 0 (;@2;)
        local.get 7
        i32.const 1
        call $_ZN19multiversx_sc_codec6single16nested_en_output18NestedEncodeOutput9push_byte17h1eaed3347978f1d5E
        local.get 4
        local.get 7
        call $_ZN139_$LT$multiversx_sc..types..managed..wrapped..big_uint..BigUint$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en..NestedEncode$GT$24dep_encode_or_handle_err17h89cb528c5accd023E
        br 1 (;@1;)
      end
      local.get 7
      i32.const 0
      call $_ZN19multiversx_sc_codec6single16nested_en_output18NestedEncodeOutput9push_byte17h1eaed3347978f1d5E
    end
    local.get 0
    local.get 6
    i32.const 24
    i32.shl
    local.get 6
    i32.const 65280
    i32.and
    i32.const 8
    i32.shl
    i32.or
    local.get 6
    i32.const 8
    i32.shr_u
    i32.const 65280
    i32.and
    local.get 6
    i32.const 24
    i32.shr_u
    i32.or
    i32.or
    i32.store offset=12
    local.get 7
    local.get 0
    i32.const 12
    i32.add
    i32.const 4
    call $mBufferAppendBytes
    drop
    local.get 7
    call $mBufferFinish
    drop
    local.get 0
    i32.const 16
    i32.add
    global.set $__stack_pointer
  )
  (func $getPingAmount (;113;) (type 11)
    call $checkNoPayment
    i32.const 0
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_eq17hb6cfff90ed14e47cE
    call $_ZN50_$LT$C$u20$as$u20$ping_pong_test..PingPongTest$GT$11ping_amount17haa8f64fbf059fe9bE
    call $_ZN13multiversx_sc7storage7mappers19single_value_mapper35SingleValueMapper$LT$SA$C$T$C$A$GT$3get17h0391073f973cf385E
    call $bigIntFinishUnsigned
  )
  (func $getDeadline (;114;) (type 11)
    call $checkNoPayment
    i32.const 0
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_eq17hb6cfff90ed14e47cE
    call $_ZN50_$LT$C$u20$as$u20$ping_pong_test..PingPongTest$GT$8deadline17heaa721fc0bdc2faeE
    call $_ZN13multiversx_sc2io6finish12finish_multi17h2e9b232a1f462d67E
  )
  (func $getActivationTimestamp (;115;) (type 11)
    call $checkNoPayment
    i32.const 0
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_eq17hb6cfff90ed14e47cE
    call $_ZN50_$LT$C$u20$as$u20$ping_pong_test..PingPongTest$GT$20activation_timestamp17hb2a0cc51c935e510E
    call $_ZN13multiversx_sc2io6finish12finish_multi17h2e9b232a1f462d67E
  )
  (func $getMaxFunds (;116;) (type 11)
    (local i32 i32 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 0
    global.set $__stack_pointer
    call $checkNoPayment
    i32.const 0
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_eq17hb6cfff90ed14e47cE
    local.get 0
    i32.const 8
    i32.add
    call $_ZN50_$LT$C$u20$as$u20$ping_pong_test..PingPongTest$GT$9max_funds17h620f745426f6a455E
    call $_ZN13multiversx_sc7storage7mappers19single_value_mapper35SingleValueMapper$LT$SA$C$T$C$A$GT$3get17hf795bca050ba19baE
    block ;; label = @1
      block ;; label = @2
        local.get 0
        i32.load offset=8
        i32.const 1
        i32.and
        i32.eqz
        br_if 0 (;@2;)
        local.get 0
        i32.load offset=12
        local.set 1
        call $_ZN133_$LT$multiversx_sc..io..finish..ApiOutputAdapter$LT$FA$GT$$u20$as$u20$multiversx_sc_codec..single..top_en_output..TopEncodeOutput$GT$19start_nested_encode17h827d95c24a3d29c9E
        local.tee 2
        i32.const 1
        call $_ZN19multiversx_sc_codec6single16nested_en_output18NestedEncodeOutput9push_byte17h1eaed3347978f1d5E
        local.get 1
        local.get 2
        call $_ZN139_$LT$multiversx_sc..types..managed..wrapped..big_uint..BigUint$LT$M$GT$$u20$as$u20$multiversx_sc_codec..single..nested_en..NestedEncode$GT$24dep_encode_or_handle_err17h89cb528c5accd023E
        local.get 2
        call $mBufferFinish
        drop
        br 1 (;@1;)
      end
      i32.const 1
      i32.const 0
      call $finish
    end
    local.get 0
    i32.const 16
    i32.add
    global.set $__stack_pointer
  )
  (func $getUserStatus (;117;) (type 11)
    call $checkNoPayment
    i32.const 1
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_eq17hb6cfff90ed14e47cE
    call $_ZN13multiversx_sc2io16arg_nested_tuple15load_single_arg17h5c97185c1560416fE
    call $_ZN50_$LT$C$u20$as$u20$ping_pong_test..PingPongTest$GT$11user_status17h0d02f78b111ba8eeE
    call $_ZN13multiversx_sc7storage7mappers19single_value_mapper35SingleValueMapper$LT$SA$C$T$C$A$GT$3get17h1c0ceedad7ce9c02E
    i32.const 255
    i32.and
    i64.extend_i32_u
    call $smallIntFinishUnsigned
  )
  (func $pongAllLastUser (;118;) (type 11)
    call $checkNoPayment
    i32.const 0
    call $_ZN13multiversx_sc2io16arg_nested_tuple22check_num_arguments_eq17hb6cfff90ed14e47cE
    call $_ZN50_$LT$C$u20$as$u20$ping_pong_test..PingPongTest$GT$18pong_all_last_user17h68d135167e2486bdE
    call $_ZN141_$LT$multiversx_sc..storage..mappers..source..CurrentStorage$u20$as$u20$multiversx_sc..storage..mappers..source..StorageAddress$LT$SA$GT$$GT$19address_storage_get17hecf8779266aedeeaE
    i64.extend_i32_u
    call $smallIntFinishUnsigned
  )
  (func $callBack (;119;) (type 11))
  (data $.rodata (;0;) (i32.const 131072) "invalid valuefunction does not accept ESDT paymentincorrect number of transfersargument decode error (): too few argumentstoo many argumentswrong number of argumentsinput too longinput too shortManagedVec index out of range\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00EGLD-000000_address_to_id_count_id_to_addressstorage decode error (key: can't pong, never pingedunknown useralready withdrawnthe payment must match the fixed sumsmart contract not active yetdeadline has passedsmart contract fullcan only ping oncecan't withdraw before deadlineopt_activation_timestampuser_idbad array lengthpingAmountuseruserStatuspongAllLastUseractivationTimestampdeadlinemaxFundscompletedinterrupted")
  (data $.data (;1;) (i32.const 131744) "8\ff\ff\ff")
  (@producers
    (language "Rust" "")
    (processed-by "rustc" "1.87.0-nightly (ecade534c 2025-03-14)")
  )
  (@custom "target_features" (after data) "\08+\0bbulk-memory+\0fbulk-memory-opt+\16call-indirect-overlong+\0amultivalue+\0fmutable-globals+\13nontrapping-fptoint+\0freference-types+\08sign-ext")
)
