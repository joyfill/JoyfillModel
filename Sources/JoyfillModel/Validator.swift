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

    public init(status: ValidationStatus, fieldValidations: [FieldValidation]) {
        self.status = status
        self.fieldValidations = fieldValidations
    }
}

public struct FieldValidation {
    public let field: JoyDocField
    public let status: ValidationStatus

    public init(field: JoyDocField, status: ValidationStatus) {
        self.field = field
        self.status = status
    }
}
