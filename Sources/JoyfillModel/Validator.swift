//
//  File.swift
//  
//
//  Created by Vishnu Dutt on 14/07/24.
//

import Foundation

public enum ValidationStatus: String {
    case valid
    case invalid
}

public struct Validation {
    public let status: ValidationStatus
    public let fieldValidations: [FieldValidation]
}

public struct FieldValidation {
    public let field: JoyDocField
    public let status: ValidationStatus
}
