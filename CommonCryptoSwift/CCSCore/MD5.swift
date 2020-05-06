//
//  MD5.swift
//  CommonCryptoSwift
//
//  Created by jintao on 2019/8/16.
//  Copyright © 2019 jintao. All rights reserved.
//

import Foundation
import CommonCrypto

// *** Just For 64-bit platforms

public extension String {
    var ccsMD5: String? {
        return ccsMD5String(self)
    }
}

public extension Data {
    var ccsMD5: String {
        return ccsMD5Data(self)
    }
}

public enum MD5OutputCount: Int {
    case bits256 = 32
    case bits128 = 16
    case bits64 = 8
    
    static let maxOutputBytesCount = 16
}

public func ccsMD5String(_ str: String, outuptBitCount: MD5OutputCount = .bits256) -> String? {
    guard let str_pointer = str.cString(using: .utf8) else { return nil }
    
    let char_pointer = UnsafeMutablePointer<UInt8>.allocate(capacity: MD5OutputCount.maxOutputBytesCount)
    defer {
        char_pointer.deinitialize(count: MD5OutputCount.maxOutputBytesCount)
        char_pointer.deallocate()
    }
    
    CC_MD5(str_pointer, CC_LONG(str.utf8.count), char_pointer)
    
    let count = outuptBitCount.rawValue / 2
    let offset = (MD5OutputCount.maxOutputBytesCount - count) / 2
    var result_str = ""
    
    for i in 0..<count {
        result_str += String(format: "%02x", (char_pointer + offset + i).pointee)
    }
    return result_str
}

public func ccsMD5Data(_ data: Data, outuptBitCount: MD5OutputCount = .bits256) -> String {
    var _data = data
    let data_pointer = _data.valuePointer
    
    let char_pointer = UnsafeMutablePointer<UInt8>.allocate(capacity: MD5OutputCount.maxOutputBytesCount)
    defer {
        char_pointer.deinitialize(count: MD5OutputCount.maxOutputBytesCount)
        char_pointer.deallocate()
    }
    
    CC_MD5(data_pointer.baseAddress, CC_LONG(data_pointer.count), char_pointer)
    
    let count = outuptBitCount.rawValue / 2
    let offset = (MD5OutputCount.maxOutputBytesCount - count) / 2
    var result_str = ""
    
    for i in 0..<count {
        result_str += String(format: "%02x", (char_pointer + offset + i).pointee)
    }
    return result_str
}
