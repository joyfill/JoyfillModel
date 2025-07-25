import Foundation

/// `Document` is a struct that represents a document with its associated metadata and content.
///
/// It conforms to `Codable` and `Hashable` protocols.
public struct Document: Codable, Hashable {
    
    /// Compares two `Document` instances for equality.
    /// - Parameters:
    ///   - lhs: The left-hand side `Document` instance.
    ///   - rhs: The right-hand side `Document` instance.
    /// - Returns: `true` if the two instances have the same `id`, `false` otherwise.
    public static func == (lhs: Document, rhs: Document) -> Bool {
        lhs.id == rhs.id
    }
    
    /// The unique identifier of the document.
    public var _id: String
    
    /// The type of the document.
    public var type: String
    
    /// The identifier of the document.
    public var identifier: String
    
    /// The source of the document.
    public var source: String?
    
    /// The name of the document.
    public var name: String
    
    /// The stage of the document.
    public var stage: String
    
    /// The creation timestamp of the document.
    public var createdOn: Int
    
    /// The files associated with the document.
    public var files: [Files] = []
    
    /// Indicates whether the document is deleted or not.
    public var deleted: Bool
    
    /// `Files` is a struct that represents a file in the document.
    ///
    /// It contains the file's unique identifier, version, name, page order and pages.
    public struct Files: Codable, Hashable {
        public let _id: String
        public let version: Int
        public let name: String?
        public let pageOrder: [String]
        public let pages: [Pages]
    }
    
    /// `Pages` is a struct that represents a page in the document.
    ///
    /// It contains the page's unique identifier, name, dimensions, layout, presentation, margin, padding and border width.
    public struct Pages: Codable, Hashable {
        public let _id: String
        public let name: String
        public let width: Int
        public let height: Int
        public let cols: Int
        public let rowHeight: Int
        public let layout: String?
        public let presentation: String?
        public let margin: Double
        public let padding: Double
        public let borderWidth: Double
    }
}

/// An extension of `Document` that conforms to the `Identifiable` protocol.
///
/// This allows `Document` to be used in SwiftUI views that require identifiable data, such as `List` and `ForEach`.
extension Document: Identifiable {
    /// The unique identifier of the document. This is the same as `_id`.
    public var id: String { _id }
}

/// `DocumentListResponse` is a struct that represents a response containing a list of documents.
///
/// It conforms to the `Codable` protocol, allowing it to be encoded to and decoded from a serialized format (e.g., JSON).
public struct DocumentListResponse: Codable {
    /// The array of `Document` objects contained in the response.
    public let data: [Document]
}

// MARK: - GroupData
/// `GroupData` is a struct that represents the data of a group.
///
/// It contains the unique id, identifier, and title of the group.
public struct GroupData: Codable {
    public let id, identifier, title: String

    public enum CodingKeys: String, CodingKey {
        case id = "_id"
        case identifier, title
    }
}

/// `GroupResponse` is a struct that represents a response containing a list of group data.
///
/// It contains an array of `GroupData` objects.
public struct GroupResponse: Codable {
    public let data: [GroupData]
}

// MARK: - RetrieveGroup
/// `RetrieveGroup` is a struct that represents a group to be retrieved.
///
/// It contains the unique id, organization, identifier, title, identifiers, creation timestamp, deletion flag, and version of the group.
public struct RetrieveGroup: Codable {
    public let id, organization, identifier, title: String
    public let identifiers: [String]
    public let createdOn: Int
    public let deleted: Bool
    public let v: Int

    /// Coding keys to map the JSON keys to the properties.
    public enum CodingKeys: String, CodingKey {
        case id = "_id"
        case organization, identifier, title, identifiers, createdOn, deleted
        case v = "__v"
    }
}

/// `ListAllUsers` is a structure that represents a user.
///
/// It includes properties for the user's id, organization, type, identifier, creation date, first name, last name, and email.
public struct ListAllUsers: Codable {
    public let id, organization, type, identifier: String
    public let createdOn: Int
    public let firstName, lastName, email: String

    /// Coding keys for the `ListAllUsers` structure.
    public enum CodingKeys: String, CodingKey {
        case id = "_id"
        case organization, type, identifier, createdOn, firstName, lastName, email
    }
}

/// `ListAllUsersResponse` is a structure that represents a response containing a list of users.
///
/// It includes a property for the data which is an array of `ListAllUsers`.
public struct ListAllUsersResponse: Codable {
    /// The data of the response which is an array of `ListAllUsers`.
    public let data: [ListAllUsers]
}

/// `RetrieveUsers` is a structure that represents a user to be retrieved.
///
/// It includes properties for the user's id, organization, type, identifier, creation date, first name, last name, and email.
public struct RetrieveUsers: Codable {
    public let id, organization, type, identifier: String
    public let createdOn: Int
    public let firstName, lastName, email: String

    /// Coding keys for the `RetrieveUsers` structure.
    public enum CodingKeys: String, CodingKey {
        case id = "_id"
        case organization, type, identifier, createdOn, firstName, lastName, email
    }
}

/// `FieldTypes` is an enumeration that represents the types of fields.
///
/// It includes cases for text, multiSelect, dropdown, textarea, date, signature, block, number, chart, richText, table, and image.
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
    case unknown

    public init(_ value: String?) {
        if let value = value {
            self = FieldTypes(rawValue: value) ?? .unknown
            return
        }
        self = .unknown
    }
}

/// `DateFormatType` is an enumeration that represents the types of date formats.
///
/// It includes cases for dateOnly, timeOnly, dateTime, and empty. Each case has a corresponding date format.
public enum DateFormatType: String {
    case dateOnly = "MM/DD/YYYY"
    case timeOnly = "hh:mma"
    case dateTime = "MM/DD/YYYY hh:mma"
    case empty = ""
    
    /// The date format corresponding to the `DateFormatType`.
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

/// Extension on `ValueUnion` to provide computed properties and methods for different types of values.
public extension ValueUnion {
    
    /// Returns the text value if the `ValueUnion` is a string, otherwise returns `nil`.
    var text: String? {
        switch self {
        case .string(let string):
            return string
        default:
            return nil
        }
    }

    /// Returns the boolean value if the `ValueUnion` is a boolean, otherwise returns `nil`.
    /// If the `ValueUnion` is a double, it returns `true` if the double value is not equal to 0, otherwise returns `false`.
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

    /// Returns the display text value if the `ValueUnion` is a string, otherwise returns `nil`.
    var displayText: String? {
        switch self {
        case .string(let string):
            return string
        default:
            return nil
        }
    }

    /// Returns the display text value if the `ValueUnion` is a array of string, otherwise returns `nil`.
    var stringArray: [String]? {
        switch self {
        case .array(let stringArray):
            return stringArray
        default:
            return nil
        }
    }

    /// Returns an array of image URLs if the `ValueUnion` is an array of `ValueElement`, otherwise returns `nil`.
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
    
    /// Returns the signature URL value if the `ValueUnion` is a string, otherwise returns `nil`.
    var signatureURL: String? {
        switch self {
        case .string(let string):
            return string
        default:
            return nil
        }
    }
    
    /// Returns the multiline text value if the `ValueUnion` is a string, otherwise returns `nil`.
    var multilineText: String? {
        switch self {
        case .string(let string):
            return string
        default:
            return nil
        }
    }
    
    /// Returns the number value if the `ValueUnion` is a numeric type.
    /// Handles .double, .int, .bool, and .string (if convertible to Int64 or Double).
    var number: Double? {
        switch self {
        case .double(let int):
            return int
        case .bool(let value):
            if value {
                return 1
            }
            return 0
        case .int(let value):
            return Double(value)
        case .string(let str):
            if let intVal = Int64(str) {
                return Double(intVal)
            }
            if let doubleVal = Double(str) {
                return doubleVal
            }
            return nil
        default:
            return nil
        }
    }

    /// Returns the dropdown value if the `ValueUnion` is a string, otherwise returns `nil`.
    var dropdownValue: String? {
        switch self {
        case .string(let string):
            return string
        default:
            return nil
        }
    }
    
    /// Returns the selector value if the `ValueUnion` is a string, otherwise returns `nil`.
    var selector: String? {
        switch self {
        case .string(let string):
            return string
        default:
            return nil
        }
    }
    
    /// Returns an array of strings if the `ValueUnion` is an array, otherwise returns `nil`.
    var multiSelector: [String]? {
        switch self {
        case .array(let array):
            return array
        default:
            return nil
        }
    }
    
    /// Returns a formatted date and time string based on the `format` parameter.
    /// If the `ValueUnion` is a string, it assumes the string is in ISO8601 format and converts it to the specified format.
    /// If the `ValueUnion` is a double, it assumes the double value represents a timestamp in milliseconds and converts it to the specified format.
    /// Returns `nil` if the `ValueUnion` is neither a string nor a double.
    func dateTime(format: String) -> String? {
        switch self {
        case .string(let string):
            let date = getTimeFromISO8601Format(iso8601String: string)
            return date
        case .double(let integer):
            let date = timestampMillisecondsToDate(value: Int(integer), format: format)
            return date
        case .int(let intValue):
            let date = timestampMillisecondsToDate(value: Int(intValue), format: format)
            return date
            
        default:
            return nil
        }
    }
    
    /// Returns an array of `ValueElement` if the `ValueUnion` is an array of `ValueElement`, otherwise returns `nil`.
    var valueElements: [ValueElement]? {
        switch self {
        case .valueElementArray(let valueElements):
            return valueElements
        default:
            return nil
        }
    }
}

/// Converts an ISO8601 formatted string to a time string.
///
/// - Parameters:
///   - iso8601String: The ISO8601 formatted string representing a date and time.
///
/// - Returns: A formatted time string in the format "hh:mm a".
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

/// Converts a timestamp value in milliseconds to a formatted date string.
///
/// - Parameters:
///   - value: The timestamp value in milliseconds.
///   - format: The desired format for the date string. Supported formats are "MM/DD/YYYY", "hh:mma", and any other custom format.
///
/// - Returns: A formatted date string based on the provided timestamp value and format.
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

/// Converts a given `Date` object to a timestamp in milliseconds.
///
/// - Parameter date: The `Date` object to be converted.
/// - Returns: The timestamp in milliseconds.
public func dateToTimestampMilliseconds(date: Date) -> Double {
    let timestampSeconds = date.timeIntervalSince1970
    let timestampMilliseconds = Double(timestampSeconds * 1000)
    return timestampMilliseconds
}

public struct FieldIdentifier: Equatable {
    public let fieldID: String
    public var pageID: String?
    public var fileID: String?

    public init(fieldID: String, pageID: String? = nil, fileID: String? = nil) {
        self.fieldID = fieldID
        self.pageID = pageID
        self.fileID = fileID
    }
}

public struct UploadEvent {
    public var fieldEvent: FieldIdentifier
    public let multi: Bool
    public var uploadHandler: ([String]) -> Void
    
    public init(fieldEvent: FieldIdentifier, multi: Bool, uploadHandler: @escaping ([String]) -> Void) {
        self.fieldEvent = fieldEvent
        self.uploadHandler = uploadHandler
        self.multi = multi
    }
}

public enum Mode {
    case fill
    case readonly
}

public protocol FormInterface {
    var document: JoyDoc { get }
    var mode: Mode { get }
    var events: FormChangeEvent? { get set }
}

/// A struct representing a change in a document.
public struct Change {
    /// The dictionary representation of the change.
    public var dictionary = [String: Any]()

    /// Initializes a `Change` instance with a dictionary.
    /// - Parameter dictionary: The dictionary representation of the change.
    public init(dictionary: [String: Any]) {
        self.dictionary = dictionary
    }

    /// The ID of the change.
    public var id: String? {
        get { dictionary["_id"] as? String }
        set { dictionary["_id"] = newValue }
    }

    /// The version of the change.
    public var v: Int? {
        dictionary["v"] as? Int
    }

    /// The SDK used for the change.
    public var sdk: String? {
        dictionary["sdk"] as? String
    }

    /// The target of the change.
    public var target: String? {
        dictionary["target"] as? String
    }

    /// The identifier of the change.
    public var identifier: String? {
        dictionary["identifier"] as? String
    }

    /// The file ID associated with the change.
    public var fileId: String? {
        dictionary["fileId"] as? String
    }

    /// The page ID associated with the change.
    public var pageId: String? {
        dictionary["pageId"] as? String
    }

    /// The field ID associated with the change.
    public var fieldId: String? {
        dictionary["fieldId"] as? String
    }

    /// The field identifier associated with the change.
    public var fieldIdentifier: String? {
        dictionary["fieldIdentifier"] as? String
    }

    /// The field position ID associated with the change.
    public var fieldPositionId: String? {
        dictionary["fieldPositionId"] as? String
    }

    /// The details of the change.
    public var change: [String: Any]? {
        dictionary["change"] as? [String: Any]
    }

    /// The timestamp when the change was created.
    public var createdOn: Double? {
        dictionary["createdOn"] as? Double
    }
    
    /// The title of the change.
    public var xTitle: String? {
        dictionary["xTitle"] as? String
    }
    
    /// The view of the change.
    public var view: String? {
        dictionary["view"] as? String
    }
    
    /// The viewId of the change.
    public var viewId: String? {
        dictionary["viewId"] as? String
    }

    /// Initializes a `Change` instance with the provided values.
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
    
    // instance for page.create and field.create
    public init(v: Int, sdk: String, id: String, identifier: String, target: String, fileId: String, change: [String: Any], createdOn: Double) {
        dictionary["v"] = v
        dictionary["sdk"] = sdk
        dictionary["target"] = target
        dictionary["_id"] = id
        dictionary["identifier"] = identifier
        dictionary["fileId"] = fileId
        dictionary["change"] = change
        dictionary["createdOn"] = createdOn
    }
    
    // instance for page.create with views
    public init(v: Int, sdk: String, id: String, identifier: String, target: String, fileId: String, viewType: String, viewId: String, change: [String: Any], createdOn: Double) {
        dictionary["v"] = v
        dictionary["sdk"] = sdk
        dictionary["target"] = target
        dictionary["_id"] = id
        dictionary["identifier"] = identifier
        dictionary["fileId"] = fileId
        dictionary["view"] = viewType
        dictionary["viewId"] = viewId
        dictionary["change"] = change
        dictionary["createdOn"] = createdOn
    }    
}

/// `FormChangeEvent` is a protocol that defines methods for listening to form change events.
public protocol FormChangeEvent {
    
    /// Used to listen to any field change events.
    ///
    /// (changelogs: object_array, doc: object) => {}
    ///
    /// - changelogs: object_array :
    ///   - Can contain one ore more of the changelog object types supported.
    ///
    /// - doc: object :
    ///    - Fully updated JoyDoc JSON structure with changes applied.
    func onChange(changes: [Change], document: JoyDoc)
    
    /// Used to listen to field focus events.
    ///
    /// (params: object, e: object) => {}
    ///
    ///  params: object :
    /// - Specifies information about the focused field.
    ///
    /// e: object :
    ///  - Element helper methods.
    ///  - blur: Function :
    ///     - Triggers the field blur event for the focused field.
    ///     - If there are pending changes in the field that have not triggered the `onChange` event yet then the `e.blur()` function will trigger both the change and blur events in the following order: 1) `onChange` 2) `onBlur`.
    ///     - If the focused field utilizes a modal for field modification, ie. signature, image, tables, etc. the `e.blur()` will close the modal.
    func onFocus(event: FieldIdentifier)
    
    /// Used to listen to field focus events.
    ///
    ///  (params: object) => {}
    ///
    ///  params: object :
    ///  - Specifies information about the blurred field.
    func onBlur(event: FieldIdentifier)
    
    /// Used to listen to file upload events.
    ///
    /// (params: object) => {} :
    /// - Specifies information about the uploaded file.
    func onUpload(event:UploadEvent)
}

public struct TargetRowModel {
    public let id: String
    public let index: Int

    public init(id: String, index: Int) {
        self.id = id
        self.index = index
    }
}
