//
//  DocumentModel.swift
//  JoyFill
//
//

import Foundation

public struct Document: Codable, Hashable {
    public static func == (lhs: Document, rhs: Document) -> Bool {
        lhs.id == rhs.id
    }
    
    public var _id: String
    public var type: String
    public var identifier: String
    public var source: String?
    public var name: String
    public var stage: String
    public var createdOn: Int
    public var files: [Files] = []
    public var deleted: Bool
    
    public struct Files: Codable, Hashable {
        public let _id: String
        public let version: Int
        public let name: String
        public let pageOrder: [String]
        public let pages: [Pages]
    }
    
    public struct Pages: Codable, Hashable {
        public let _id: String
        public let name: String
        public let width: Int
        public let height: Int
        public let cols: Int
        public let rowHeight: Int
        public let layout: String
        public let presentation: String
        public let margin: Double
        public let padding: Double
        public let borderWidth: Double
    }
}

extension Document: Identifiable {
    public var id: String { _id }
}

public struct DocumentListResponse: Codable {
    public let data: [Document]
}

// MARK: - GroupData
public struct GroupData: Codable {
    public let id, identifier, title: String

    public enum CodingKeys: String, CodingKey {
        case id = "_id"
        case identifier, title
    }
}

public struct GroupResponse: Codable {
    public let data: [GroupData]
}

// MARK: - RetrieveGroup
public struct RetrieveGroup: Codable {
    public let id, organization, identifier, title: String
    public let identifiers: [String]
    public let createdOn: Int
    public let deleted: Bool
    public let v: Int

    public enum CodingKeys: String, CodingKey {
        case id = "_id"
        case organization, identifier, title, identifiers, createdOn, deleted
        case v = "__v"
    }
}

public struct ListAllUsers: Codable {
    public let id, organization, type, identifier: String
    public let createdOn: Int
    public let firstName, lastName, email: String

    public enum CodingKeys: String, CodingKey {
        case id = "_id"
        case organization, type, identifier, createdOn, firstName, lastName, email
    }
}

public struct ListAllUsersResponse: Codable {
    public let data: [ListAllUsers]
}

public struct RetrieveUsers: Codable {
    public let id, organization, type, identifier: String
    public let createdOn: Int
    public let firstName, lastName, email: String

    public enum CodingKeys: String, CodingKey {
        case id = "_id"
        case organization, type, identifier, createdOn, firstName, lastName, email
    }
}

public enum FieldTypes: String, Codable {
    case text
    case multiSelect
    case dropdown
    case textarea
    case date
    case signature
    case block
    case number
    case chart
    case richText
    case table
    case image
}

public enum DateFormatType: String {
    case dateOnly = "MM/DD/YYYY"
    case timeOnly = "hh:mma"
    case dateTime = "MM/DD/YYYY hh:mma"
    case empty = ""
    
   public var dateFormat: String {
        switch self {
        case .dateOnly:
            return "MMMM d, yyyy"
        case .timeOnly:
            return "hh:mm a"
        case .dateTime:
            return "MMMM d, yyyy h:mm a"
        case .empty:
            return "MMMM d, yyyy h:mm a"
        }
    }
}

public extension ValueUnion {
    var text: String? {
        switch self {
        case .string(let string):
            return string
        default:
            return nil
        }
    }

    var bool: Bool? {
        switch self {
        case .bool(let bool):
            return bool
        case .double(let double):
            return double != 0
        default:
            return nil
        }
    }

    var displayText: String? {
        switch self {
        case .string(let string):
            return string
        default:
            return nil
        }
    }
    var imageURLs: [String]? {
        switch self {
        case .valueElementArray(let valueElements):
            var imageURLArray: [String] = []
            for element in valueElements {
                imageURLArray.append(element.url ?? "")
            }
            return imageURLArray
        default:
            return nil
        }
    }
    
    var signatureURL: String? {
        switch self {
        case .string(let string):
            return string
        default:
            return nil
        }
    }
    
    var multilineText: String? {
        switch self {
        case .string(let string):
            return string
        default:
            return nil
        }
    }
    
    var number: Double? {
        switch self {
        case .double(let int):
            return int
        case .bool(let value):
            if value {
                return 1
            }
            return 0
        default:
            return nil
        }
    }

    var dropdownValue: String? {
        switch self {
        case .string(let string):
            return string
        default:
            return nil
        }
    }
    var selector: String? {
        switch self {
        case .string(let string):
            return string
        default:
            return nil
        }
    }
    var multiSelector: [String]? {
        switch self {
        case .array(let array):
            return array
        default:
            return nil
        }
    }
    func dateTime(format: String) -> String? {
        switch self {
        case .string(let string):
            let date = getTimeFromISO8601Format(iso8601String: string)
            return date
        case .double(let integer):
            let date = timestampMillisecondsToDate(value: Int(integer), format: format)
            return date
        default:
            return nil
        }
    }
    
    var valueElements: [ValueElement]? {
        switch self {
        case .valueElementArray(let valueElements):
            return valueElements
        default:
            return nil
        }
    }
}

public func getTimeFromISO8601Format(iso8601String: String) -> String {
    let dateFormatter = ISO8601DateFormatter()
    let instant = dateFormatter.date(from: iso8601String)
    
    let timeZone = TimeZone.current
    let zonedDateTime = instant ?? Date()
    
    let formatter = DateFormatter()
    formatter.dateFormat = "hh:mm a"
    formatter.timeZone = timeZone
    
    let timeString = formatter.string(from: zonedDateTime)
    return timeString
}

public func timestampMillisecondsToDate(value: Int, format: String) -> String {
    let timestampMilliseconds: TimeInterval = TimeInterval(value)
    let date = Date(timeIntervalSince1970: timestampMilliseconds / 1000.0)
    let dateFormatter = DateFormatter()
    
    if format == "MM/DD/YYYY" {
        dateFormatter.dateFormat = "MMMM d, yyyy"
    } else if format == "hh:mma" {
        dateFormatter.dateFormat = "hh:mm a"
    } else {
        dateFormatter.dateFormat = "MMMM d, yyyy h:mm a"
    }
    
    let formattedDate = dateFormatter.string(from: date)
    return formattedDate
}

public func dateToTimestampMilliseconds(date: Date) -> Double {
    let timestampSeconds = date.timeIntervalSince1970
    let timestampMilliseconds = Double(timestampSeconds * 1000)
    return timestampMilliseconds
}

public struct FieldEvent {
    public let field: JoyDocField?
    public var page: Page?
    public var file: File?
    
    public init(field: JoyDocField? = nil, page: Page? = nil, file: File? = nil) {
        self.field = field
        self.page = page
        self.file = file
    }
}

public struct UploadEvent {
    public var field: JoyDocField
    public var page: Page?
    public var file: File?
    public var uploadHandler: ([String]) -> Void
    
    public init(field: JoyDocField, page: Page? = nil, file: File? = nil, uploadHandler: @escaping ([String]) -> Void) {
        self.field = field
        self.page = page
        self.file = file
        self.uploadHandler = uploadHandler
      }
}

public enum Mode {
    case fill
    case readonly
}

public protocol FormInterface {
    var document: JoyDoc { get }
    var mode: Mode { get }
    var events: FormChangeEvent? { get set}
}

public struct FieldChangeEvent {
    public let fieldPosition: FieldPosition
    public let field: JoyDocField?
    public var page: Page?
    public var file: File?
    
    public init(fieldPosition: FieldPosition, field: JoyDocField?, page: Page? = nil, file: File? = nil) {
        self.fieldPosition = fieldPosition
        self.field = field
        self.page = page
        self.file = file
    }
}

public struct Change {
    public var dictionary = [String: Any]()

    public init(dictionary: [String: Any]) {
        self.dictionary = dictionary
    }

    public var id: String? {
        get { dictionary["_id"] as? String }
        set { dictionary["_id"] = newValue }
    }

    public var v: Int? {
        dictionary["v"] as? Int
    }

    public var sdk: String? {
        dictionary["sdk"] as? String
    }

    public var target: String? {
        dictionary["target"] as? String
    }

    public var identifier: String? {
        dictionary["identifier"] as? String
    }

    public var fileId: String? {
        dictionary["fileId"] as? String
    }

    public var pageId: String? {
        dictionary["pageId"] as? String
    }

    public var fieldId: String? {
        dictionary["fieldId"] as? String
    }

    public var fieldIdentifier: String? {
        dictionary["fieldIdentifier"] as? String
    }

    public var fieldPositionId: String? {
        dictionary["fieldPositionId"] as? String
    }

    public var change: [String: Any]? {
        dictionary["change"] as? [String: Any]
    }

    public var createdOn: Double? {
        dictionary["createdOn"] as? Double
    }
    
    public var xTitle: String? {
        dictionary["xTitle"] as? String
    }

    public init(v: Int, sdk: String, target: String, _id: String, identifier: String?, fileId: String, pageId: String, fieldId: String, fieldIdentifier: String, fieldPositionId: String, change: [String: Any], createdOn: Double) {
        dictionary["v"] = v
        dictionary["sdk"] = sdk
        dictionary["target"] = target
        dictionary["_id"] = _id
        dictionary["identifier"] = identifier
        dictionary["fileId"] = fileId
        dictionary["pageId"] = pageId
        dictionary["fieldId"] = fieldId
        dictionary["fieldIdentifier"] = fieldIdentifier
        dictionary["fieldPositionId"] = fieldPositionId
        dictionary["change"] = change
        dictionary["createdOn"] = createdOn
    }
}

public protocol FormChangeEvent {
    /**
     `Text`, `Textarea`, `Number`, `Date`, `Dropdown`, `Chart`, `Signature` - onChange  is fired when the field value is modified.

     `Mulitselect` - onChange is fired when an option is selected or unselected in the field.

     `Image` - onChange is fired when the field images are uploaded or removed.
     */
    func onChange(changes: [Change], document: JoyDoc)

    /**
     `Text`, `Textarea`, `Number` - onFocus(params: object, e: object) is fired when the field is focused.

     `Date` , `Dropdown` - onFocus is fired when the field is pressed and selection modal is displayed.

     `Mulitselect` - is fired when an option is selected or unselected for the first time on the field.

     `Chart` - onFocus is fired when “view” button is pressed and modal is displayed.

     `Image` - onFocus is fired when “view” button is pressed and modal is displayed.
     - An empty image field that is focused will also trigger the onUploadAsync request.
     - A populated image field that is focused will trigger the image modal to open.

     `Signature` - onFocus is fired when open modal button is pressed and modal is displayed.
     */
    func onFocus(event: FieldEvent)

    /**
     `Text`, `Textarea`, `Number` - onBlur is fired when the field is blurred.

     `Date` , `Dropdown` - onBlur is fired when the field is blurred and the selection modal is closed.

     `Mulitselect` - onChange is fired when an option is selected or unselected in the field.

     `Image` - onChange is fired when the field images are uploaded or removed.
     */
    func onBlur(event: FieldEvent)

    /**
     `Text`, `Textarea`, `Number`, `Date`, `Dropdown`, `Chart`, `Signature` - onChange  is fired when the field value is modified.

     `Mulitselect` - onChange is fired when an option is selected or unselected in the field.

     `Image` - onChange is fired when the field images are uploaded or removed.
     */
    func onUpload(event:UploadEvent)
}

public protocol FormChangeEventInternal {
    func onChange(event: FieldChangeEvent)
    func addRow(event: FieldChangeEvent)
    func onFocus(event: FieldEvent)
    func onBlur(event: FieldEvent)
    func onUpload(event:UploadEvent)
}

public protocol FieldChangeEvents {
    func onChange(event: FieldChangeEvent)
    func addRow(event: FieldChangeEvent)
    func onFocus(event: FieldEvent)
    func onUpload(event:UploadEvent)
}
