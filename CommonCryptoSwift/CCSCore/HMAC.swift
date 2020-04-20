//
//  HMAC.swift
//  CommonCryptoSwift
//
//  Created by jintao on 2019/8/16.
//  Copyright © 2019 jintao. All rights reserved.
//

import Foundation
import CommonCrypto

// *** Just For 64-bit platforms

public extension String {
    func hmac(algorithm: HmaclAgorithm, key: String) -> String? {
        return ccs_hmac(str: self, algorithm: algorithm, key: key)
    }
}

public extension Data {
    func hmac(algorithm: HmaclAgorithm, key: String, keyEncoding: String.Encoding = .utf8) -> String? {
        return ccs_hmac(data: self, algorithm: algorithm, key: key, keyEncoding: keyEncoding)
    }
}

public enum HmaclAgorithm: Int {
    case MD5 = 16
    case SHA1 = 20
    case SHA224 = 28
    case SHA256 = 32
    case SHA384 = 48
    case SHA512 = 64
}

public func ccs_hmac(str: String, algorithm: HmaclAgorithm, key: String) -> String? {
    guard let str_pointer = str.cString(using: .utf8), let key_pointer = key.cString(using: .utf8) else { return nil }
    
    let count = algorithm.rawValue
    let char_pointer = UnsafeMutablePointer<UInt8>.allocate(capacity: count)
    defer {
        char_pointer.deinitialize(count: count)
        char_pointer.deallocate()
    }
    
    var hmac_algorithm: CCHmacAlgorithm
    switch algorithm {
    case .MD5: hmac_algorithm = UInt32(kCCHmacAlgMD5)
    case .SHA1: hmac_algorithm = UInt32(kCCHmacAlgSHA1)
    case .SHA224: hmac_algorithm = UInt32(kCCHmacAlgSHA224)
    case .SHA256: hmac_algorithm = UInt32(kCCHmacAlgSHA256)
    case .SHA384: hmac_algorithm = UInt32(kCCHmacAlgSHA384)
    case .SHA512: hmac_algorithm = UInt32(kCCHmacAlgSHA512)
    }
    
    CCHmac(hmac_algorithm, key_pointer, key.utf8.count, str_pointer, str.utf8.count, char_pointer)
    
    var result_str = ""
    for i in 0..<count {
        result_str += String(format: "%02x", (char_pointer + i).pointee)
    }
    return result_str
}

public func ccs_hmac(data: Data, algorithm: HmaclAgorithm, key: String, keyEncoding: String.Encoding = .utf8) -> String? {
    guard let key_pointer = key.cString(using: keyEncoding) else { return nil }
    var _data = data
    let data_pointer = _data.valuePointer
    
    let count = algorithm.rawValue
    let char_pointer = UnsafeMutablePointer<UInt8>.allocate(capacity: count)
    defer {
        char_pointer.deinitialize(count: count)
        char_pointer.deallocate()
    }
    
    var hmac_algorithm: CCHmacAlgorithm
    switch algorithm {
    case .MD5: hmac_algorithm = UInt32(kCCHmacAlgMD5)
    case .SHA1: hmac_algorithm = UInt32(kCCHmacAlgSHA1)
    case .SHA224: hmac_algorithm = UInt32(kCCHmacAlgSHA224)
    case .SHA256: hmac_algorithm = UInt32(kCCHmacAlgSHA256)
    case .SHA384: hmac_algorithm = UInt32(kCCHmacAlgSHA384)
    case .SHA512: hmac_algorithm = UInt32(kCCHmacAlgSHA512)
    }
    
    CCHmac(hmac_algorithm, key_pointer, key.utf8.count, data_pointer.baseAddress, data_pointer.count, char_pointer)
    
    var result_str = ""
    for i in 0..<count {
        result_str += String(format: "%02x", (char_pointer + i).pointee)
    }
    return result_str
}
