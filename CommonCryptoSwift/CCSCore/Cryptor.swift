//
//  Crypt.swift
//  CommonCryptoSwift
//
//  Created by jintao on 2020/4/20.
//  Copyright © 2020 jintao. All rights reserved.
//

import Foundation
import CommonCrypto

public enum AESOperation: Int {
    case Encrypt   // 加密
    case Decrypt   // 解密
}

public func ccs_crypt(operation: AESOperation, key: String, iv: String, data: String) -> Data? {
    guard let key_pointer = key.cString(using: .utf8),
        let data_pointer = data.cString(using: .utf8),
        let iv_pointer = iv.cString(using: .utf8)
        else { return nil }
    
    var keySize = kCCKeySizeAES128
    var cryptOperation = CCOperation(kCCEncrypt)
    
    switch operation {
    case .Encrypt:
        cryptOperation = CCOperation(kCCEncrypt)
    case .Decrypt:
        cryptOperation = CCOperation(kCCDecrypt)
    }
    
    var dataOutSize = ((data.utf8.count + 16) >> 4) << 4  // 取16整数
    var dataOut = malloc(dataOutSize)
    defer {
        free(dataOut)
    }
    
    var dataOutMoved = 0
    let result = CCCrypt(cryptOperation, CCAlgorithm(kCCAlgorithmAES), CCOptions(kCCOptionPKCS7Padding), key_pointer, key.utf8.count, iv_pointer, data_pointer, data.utf8.count, dataOut, dataOutSize, &dataOutMoved)
        
    if result == kCCSuccess, let resultData = dataOut {
        let encrypt_data = Data(bytes: resultData, count: dataOutSize)
        return encrypt_data
    }
    return nil
}
