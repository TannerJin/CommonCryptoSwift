//
//  SHA.swift
//  CommonCryptoSwift
//
//  Created by jintao on 2019/8/16.
//  Copyright © 2019 jintao. All rights reserved.
//

import Foundation
import CommonCrypto

// *** Just For 64-bit platforms

public extension String {
    var ccsSHA256: String? {
        return ccsSHA(str: self, shaType: .SHA256)
    }
}

public extension Data {
    var ccsSHA256: String? {
        return ccsSHA(data: self, shaType: .SHA256)
    }
}

public enum SHAAlgorithm: Int {
    case SHA1 = 20
    case SHA224 = 28
    case SHA256 = 32
    case SHA384 = 48
    case SHA512 = 64
}

public func ccsSHA(str: String, shaType: SHAAlgorithm) -> String? {
    guard let str_pointer = str.cString(using: .utf8) else { return nil }
    
    let count = shaType.rawValue
    let char_pointer = UnsafeMutablePointer<UInt8>.allocate(capacity: count)
    defer {
        char_pointer.deinitialize(count: count)
        char_pointer.deallocate()
    }
    
    let length = CC_LONG(str.utf8.count)
    switch shaType {
    case .SHA1: CC_SHA1(str_pointer, length, char_pointer)
    case .SHA224: CC_SHA224(str_pointer, length, char_pointer)
    case .SHA256: CC_SHA256(str_pointer, length, char_pointer)
    case .SHA384: CC_SHA384(str_pointer, length, char_pointer)
    case .SHA512: CC_SHA512(str_pointer, length, char_pointer)
    }
    
    var result_str = ""
    for i in 0..<count {
        result_str += String(format: "%02x", (char_pointer + i).pointee)
    }
    return result_str
}

public func ccsSHA(data: Data, shaType: SHAAlgorithm) -> String {
    var _data = data
    let data_pointer = _data.valuePointer
    
    let count = shaType.rawValue
    let char_pointer = UnsafeMutablePointer<UInt8>.allocate(capacity: count)
    defer {
        char_pointer.deinitialize(count: count)
        char_pointer.deallocate()
    }
    
    let length = CC_LONG(data_pointer.count)
    switch shaType {
    case .SHA1: CC_SHA1(data_pointer.baseAddress, length, char_pointer)
    case .SHA224: CC_SHA224(data_pointer.baseAddress, length, char_pointer)
    case .SHA256: CC_SHA256(data_pointer.baseAddress, length, char_pointer)
    case .SHA384: CC_SHA384(data_pointer.baseAddress, length, char_pointer)
    case .SHA512: CC_SHA512(data_pointer.baseAddress, length, char_pointer)
    }
    
    var result_str = ""
    for i in 0..<count {
        result_str += String(format: "%02x", (char_pointer + i).pointee)
    }
    return result_str
}
