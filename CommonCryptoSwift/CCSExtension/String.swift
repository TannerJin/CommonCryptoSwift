//
//  String.swift
//  CommonCryptoSwift
//
//  Created by jintao on 2019/8/16.
//  Copyright © 2019 jintao. All rights reserved.
//

public extension String {
    var valuePointer: UnsafeMutablePointer<UInt8>? {
        mutating get {
            #if arch(i386) || arch(arm)
            // 32-bit platforms
            return nil
            #else
            // Swift5 ABI
            if self.count <= 15 {
                // - Small strings
                return withUnsafePointer(to: &self) { UnsafeMutableRawPointer(mutating: $0).assumingMemoryBound(to: UInt8.self) }
            } else {
                // - Large strings
                let _object = unsafeBitCast(self, to: (UInt64, UInt64).self).1
                let pointerMask = 1 << 56 - 1                       // 56 bits => 111...111
                let pointerValue = _object & UInt64(pointerMask)
                return UnsafeMutableRawPointer(bitPattern: UInt(pointerValue))?.advanced(by: 32).assumingMemoryBound(to: UInt8.self)
            }
            #endif
        }
    }
}
