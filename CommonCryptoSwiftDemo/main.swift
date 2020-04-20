//
//  main.swift
//  CommonCryptoSwift
//
//  Created by jintao on 2019/8/16.
//  Copyright © 2019 jintao. All rights reserved.
//

import Foundation

let key = "jfifjirjrjieie21"
var iv = "1234567890abcde"

if let data = ccs_crypt(operation: .Encrypt, key: key, iv: iv, data: "TannerJin") {
    let str = data.base64EncodedString()
    print(data.count, str)
}
