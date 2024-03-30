//
//  File.swift
//  
//
//  Created by iMoe Nya on 2023/10/21.
//

import Foundation
import Ocicat

#Keys("custom")

final class TestClass {
    @Ocicated
    var object: Int?
    
    static let nonOptionalInitialValue = 40
    @Ocicated
    var nonOptional: Int = Self.nonOptionalInitialValue
    
    @Ocicated
    var unwrappedObject: Int!
    
    @Ocicated
    weak var weakRef: NSObject?
    
    @Ocicated(key: "Keys.custom")
    var customKeyedObject: Int?
}
