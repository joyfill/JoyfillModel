//
//  File.swift
//  
//
//  Created by Vishnu Dutt on 14/07/24.
//

import Foundation

class Validator {
    func validate(document: JoyDoc) -> Validation {
        var fieldValidations = [FieldValidation]()
        var isValid = true
        for field in document.fields {
            guard !field.hidden else {
                fieldValidations.append(FieldValidation(field: field, status: .valid))
                continue
            }

            guard DocumentEngine.shouldShowItem(fields: document.fields, logic: fieldData?.logic,isItemHidden: fieldData?.hidden) else {
                fieldValidations.append(FieldValidation(field: field, status: .valid))
                continue
            }

            guard field.required else {
                fieldValidations.append(FieldValidation(field: field, status: .valid))
                continue
            }

            guard let value = field.value, !value.isEmpty {
                isValid = false
                fieldValidations.append(FieldValidation(field: field, status: .invalid))
                continue
            }
            fieldValidations.append(FieldValidation(field: field, status: .valid))
        }
        return Validation(status: isValid ? .valid: .invalid, fieldValidations: fieldValidations)
    }
}

enum ValidationStatus: String {
    case valid
    case invalid
}

struct Validation {
    let status: ValidationStatus
    let fieldValidations: [FieldValidation]
}

struct FieldValidation {
    let field: JoyDocField
    let status: ValidationStatus
}
