//
//  Data.swift
//  CommonCryptoSwift
//
//  Created by jintao on 2019/8/16.
//  Copyright © 2019 jintao. All rights reserved.
//

import Foundation

public extension Data {
    var valuePointer: UnsafeMutableRawBufferPointer {
        get {
            return self.withUnsafeBytes{ UnsafeMutableRawBufferPointer(mutating: $0) }
        }
    }
}
