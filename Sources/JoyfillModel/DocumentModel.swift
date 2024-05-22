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
        public let name: String
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
        public let layout: String
        public let presentation: String
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
    func onFocus(event: FieldEvent)
    
    /// Used to listen to field focus events.
    ///
    ///  (params: object) => {}
    ///
    ///  params: object :
    ///  - Specifies information about the blurred field.
    func onBlur(event: FieldEvent)
    
    /// Used to listen to file upload events.
    ///
    /// (params: object) => {} :
    /// - Specifies information about the uploaded file.
    func onUpload(event:UploadEvent)
}

public protocol FormChangeEventInternal {
    
    /// A method that is called when a field's value changes.
    /// - Parameter event: The `FieldChangeEvent` object that contains information about the field change event.
    func onChange(event: FieldChangeEvent)
    
    /// Adds a row to the form with the specified field change event.
    ///
    /// - Parameters:
    ///   - event: The field change event containing the necessary information for adding a row.
    func addRow(event: FieldChangeEvent)
    
    /// Notifies the form view that it has received focus.
    ///
    /// - Parameter event: The field event associated with the focus.
    func onFocus(event: FieldEvent)
    
    /// Calls the `onBlur` event handler with the specified `event`.
    ///
    /// - Parameter event: The `FieldEvent` to pass to the `onBlur` event handler.
    func onBlur(event: FieldEvent)
    
    /// Calls the `onUpload` method of the `events` object, passing the provided `event`.
    ///
    /// - Parameter event: The `UploadEvent` to be passed to the `onUpload` method.
    func onUpload(event:UploadEvent)
}

public protocol FieldChangeEvents {
    func onChange(event: FieldChangeEvent)
    func addRow(event: FieldChangeEvent)
    func onFocus(event: FieldEvent)
    func onUpload(event:UploadEvent)
}
