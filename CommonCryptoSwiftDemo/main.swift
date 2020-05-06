//
//  main.swift
//  CommonCryptoSwift
//
//  Created by jintao on 2019/8/16.
//  Copyright © 2019 jintao. All rights reserved.
//

import Foundation

let key = "AD42F6697B035B7580E4FEF93BE20BAD"
var iv = "AD42F6697B035B7580E4FEF93BE20BAD"

// MARK: MD5
assert("Tanner Jin".ccsMD5 == "50ca3085332d9ab004070ebd01a0ad03")

// MARK: SHA
assert(ccsSHA(str: "Tanner Jin", shaType: .SHA256) == "73995b92194f049cb51ec4d91c9462d4ae92992823b0e43beebefc75001da2e0")

assert(ccsSHA(str: "Tanner Jin", shaType: .SHA384) == "c73e163b2e71125a61aa807360b619a455daead92e06684fe40fafe6790119c39c60678b150dfc5626c2ec8140c3d575")

assert(ccsSHA(str: "Tanner Jin", shaType: .SHA512) == "0cf4f9267d537f755d58466acae0cba290ab4411c76eb27da57a2a40315e8b8e18aff28442787376d592c024a023d5e6db6ca8c994ca8f71839c34a46c68bda3")


// MARK: HMAC
assert("Tanner Jin".ccsHMAC(algorithm: .MD5, key: key) == "8600b2d136c77614415479cb73e0c4f4")

assert("Tanner Jin".ccsHMAC(algorithm: .SHA256, key: key) == "fd0de55c42c420a78d50a43e95288e396f178b7b18fc054369cf0cd3ed6b32ec")

assert("Tanner Jin".ccsHMAC(algorithm: .SHA384, key: key) == "1f242b081840b122b0961be92aa4a471dc3bf4c4000daa7d3958ba18a961aa039f56422f72e0a190bdd3c68f8b95d063")

assert("Tanner Jin".ccsHMAC(algorithm: .SHA512, key: key) == "c576b8291697d3188ee7df63b90d00de4cea66c505eaa7ea177db79d4df50a669f69cb05dfa86d8ee0f23cceba1cc18fae7f2252178ddad4ee069d42217d687c")


// MARK: AES
if let data = ccsAESEncrypt(key: key, iv: iv, str: "hello world12345678") {
    let str = data.base64EncodedString()
    assert(str == "63MP0HiVSvMOCivmmKxJspuAjjfy73KwFN51zj4lWaY=")
}

if let str = ccsAESDecrypt(key: key, iv: iv, base64String: "63MP0HiVSvMOCivmmKxJspuAjjfy73KwFN51zj4lWaY=") {
    assert("hello world12345678" == str)
}



print("🚀🚀🚀。。。")
