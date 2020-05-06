//
//  Crypt.swift
//  CommonCryptoSwift
//
//  Created by jintao on 2020/4/20.
//  Copyright © 2020 jintao. All rights reserved.
//

import Foundation
import CommonCrypto

public func ccsAESEncrypt(key: String, iv: String, str: String) -> Data? {
    guard let keyPointer = key.cString(using: .utf8),
        let inputDataPointer = str.cString(using: .utf8),
        let ivPointer = iv.cString(using: .utf8)
        else { return nil }
    
    var outDataSize = ((str.utf8.count + 16) >> 4) << 4  // 取16整数
    var outData = calloc(1, outDataSize)
    defer {
        free(outData)
    }
    
    var dataOutMoved = 0
    let result = CCCrypt(CCOperation(kCCEncrypt), CCAlgorithm(kCCAlgorithmAES), CCOptions(kCCOptionPKCS7Padding), keyPointer, key.utf8.count, ivPointer, inputDataPointer, str.utf8.count, outData, outDataSize, &dataOutMoved)
        
    if result == kCCSuccess, let resultData = outData {
        let encryptData = Data(bytes: resultData, count: outDataSize)
        return encryptData
    }
    print(result, dataOutMoved)
    return nil
}

public func ccsAESDecrypt(key: String, iv: String, base64Data: Data) -> String? {
    guard var data = Data(base64Encoded: base64Data),
        let keyPointer = key.cString(using: .utf8),
        let inputDataPointer = data.valuePointer.baseAddress,
        let ivPointer = iv.cString(using: .utf8)
        else { return nil }
     
    var outDataSize = ((data.count + 16) >> 4) << 4  // 取16整数
    var outData = calloc(1, outDataSize)    // 这里必须调用calloc, 因为calloc会将分配的内存空间清0 (cleared_requested = 1), 避免CString转换成Swift.String出现问题(遇到00字节才停止)
    defer {
        free(outData)
    }
     
    var dataOutMoved = 0
    let result = CCCrypt(CCOperation(kCCDecrypt), CCAlgorithm(kCCAlgorithmAES), CCOptions(kCCOptionPKCS7Padding), keyPointer, key.utf8.count, ivPointer, inputDataPointer, data.count, outData, outDataSize, &dataOutMoved)
         
    if result == kCCSuccess, let resultData = outData {
        let decryptString = String(cString: resultData.assumingMemoryBound(to: UInt8.self))
        return decryptString
    }
    print(result, dataOutMoved)
    return nil
}

public func ccsAESDecrypt(key: String, iv: String, base64String: String) -> String? {
    if let base64Data = base64String.data(using: .utf8) {
       return ccsAESDecrypt(key: key, iv: iv, base64Data: base64Data)
    }
    return nil    
}
