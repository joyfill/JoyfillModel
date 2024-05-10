import Foundation

// MARK: - JoyDoc
public struct JoyDoc {
    public var dictionary: [String: Any]

    public init(dictionary: [String: Any] = [:]) {
        self.dictionary = dictionary
    }

    public var id: String? {
        get { dictionary["_id"] as? String }
        set { dictionary["_id"] = newValue }
    }
    public var type: String? {
        get { dictionary["type"] as? String }
        set { dictionary["type"] = newValue }
    }
    public var stage: String? {
        get { dictionary["stage"] as? String }
        set { dictionary["stage"] = newValue }
    }
    public var source: String? {
        get { dictionary["source"] as? String }
        set { dictionary["source"] = newValue }
    }
    public var identifier: String? {
        get { dictionary["identifier"] as? String }
        set { dictionary["identifier"] = newValue }
    }
    public var name: String? {
        get { dictionary["name"] as? String }
        set { dictionary["name"] = newValue }
    }
    public var createdOn: Int? {
        get { dictionary["createdOn"] as? Int }
        set { dictionary["createdOn"] = newValue }
    }

    public var metadata: Metadata? {
        get { Metadata.init(dictionary: dictionary["metadata"] as? [String: Any])}
        set { dictionary["metadata"] = newValue?.dictionary }
    }
    public var files: [File] {
        get { (dictionary["files"] as? [[String: Any]])?.compactMap(File.init) ?? [] }
        set { dictionary["files"] = newValue.compactMap { $0.dictionary } }
    }
    public var fields: [JoyDocField] {
        get { (dictionary["fields"] as? [[String: Any]])?.compactMap(JoyDocField.init) ?? [] }
        set { dictionary["fields"] = newValue.compactMap { $0.dictionary } }
    }
    public var categories: [JSONAny]? {
        mutating get { getValue(key: "categories") }
        mutating set { setValue(newValue, key: "categories") }
    }
    public var deleted: Bool? {
        get { dictionary["deleted"] as? Bool }
        set { dictionary["deleted"] = newValue }
    }
}

extension JoyDoc {
    mutating private func setValue(_ value: [JSONAny]?, key: String) {
        guard let value = value else {
            return
        }
        guard let data = try? JSONEncoder().encode(value) else {
            return
        }
        self.dictionary[key] = try? JSONDecoder().decode(JSONAny.self, from: data)
    }
    mutating private func getValue(key: String) -> [JSONAny]? {
        guard let value = dictionary[key] as? [String: Any] else {
            return nil
        }
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted) else {
            return nil
        }
        return try? JSONDecoder().decode([JSONAny].self, from: data)
    }
}

// MARK: - File
public struct File {
    public var dictionary: [String: Any]

    public init(dictionary: [String: Any] = [:]) {
        self.dictionary = dictionary
    }

    public var id: String? {
        get { dictionary["_id"] as? String }
        set { dictionary["_id"] = newValue }
    }

    public var metadata: Metadata? {
        get { Metadata.init(dictionary: dictionary["metadata"] as? [String: Any])}
        set { dictionary["metadata"] = newValue?.dictionary }
    }

    public var name: String? {
        get { dictionary["name"] as? String }
        set { dictionary["name"] = newValue }
    }

    public var version: Int? {
        get { dictionary["version"] as? Int }
        set { dictionary["version"] = newValue }
    }

    public var styles: Metadata? {
        get { Metadata.init(dictionary: dictionary["styles"] as? [String: Any])}
        set { dictionary["styles"] = newValue?.dictionary }
    }

    public var pages: [Page]? {
        get { (dictionary["pages"] as? [[String: Any]])?.compactMap(Page.init) }
        set { dictionary["pages"] = newValue?.compactMap{ $0.dictionary } }
    }

    public var pageOrder: [String]? {
        get { dictionary["pageOrder"] as? [String] }
        set { dictionary["pageOrder"] = newValue }
    }

    public var views: [ModelView]? {
        get { (dictionary["views"] as? [[String: Any]])?.compactMap(ModelView.init) ?? [] }
        set { dictionary["views"] = newValue?.compactMap{ $0.dictionary } }
    }
}

// MARK: - JoyDocField
public struct JoyDocField: Equatable {
    public static func == (lhs: JoyDocField, rhs: JoyDocField) -> Bool {
        lhs.id == rhs.id
    }
    public var dictionary: [String: Any]

    public init(field: [String: Any] = [:]) {
        self.dictionary = field
    }

    public var type: String? {
        get { dictionary["type"] as? String }
        set { dictionary["type"] = newValue }
    }

    public var id: String? {
        get { dictionary["_id"] as? String }
        set { dictionary["_id"] = newValue }
    }

    public var identifier: String? {
        get { dictionary["identifier"] as? String }
        set { dictionary["identifier"] = newValue }
    }

    public var title: String? {
        get { dictionary["title"] as? String }
        set { dictionary["title"] = newValue }
    }

    public var description: String? {
        get { dictionary["description"] as? String }
        set { dictionary["description"] = newValue }
    }

    public var value: ValueUnion? {
        get { ValueUnion.init(valueFromDcitonary: dictionary)}
        set { dictionary["value"] = newValue?.dictionary }
    }

    public var required: Bool? {
        get { dictionary["required"] as? Bool }
        set { dictionary["required"] = newValue }
    }

    public var disabled: Bool? {
        get { dictionary["disabled"] as? Bool }
        set { dictionary["disabled"] = newValue }
    }

    public var metadata: Metadata? {
        get { Metadata.init(dictionary: dictionary["metadata"] as? [String: Any])}
        set { dictionary["metadata"] = newValue?.dictionary }
    }

    public var file: String? {
        get { dictionary["file"] as? String }
        set { dictionary["file"] = newValue }
    }

    public var options: [Option]? {
        get { (dictionary["options"] as? [[String: Any]])?.compactMap(Option.init) ?? [] }
        set { dictionary["options"] = newValue?.compactMap{ $0.dictionary } }
    }

    public var tipTitle: String? {
        get { dictionary["tipTitle"] as? String }
        set { dictionary["tipTitle"] = newValue }
    }

    public var tipDescription: String? {
        get { dictionary["tipDescription"] as? String }
        set { dictionary["tipDescription"] = newValue }
    }

    public var tipVisible: Bool? {
        get { dictionary["tipVisible"] as? Bool }
        set { dictionary["tipVisible"] = newValue }
    }

    public var multi: Bool? {
        get { dictionary["multi"] as? Bool }
        set { dictionary["multi"] = newValue }
    }

    public var yTitle: String? {
        get { dictionary["yTitle"] as? String }
        set { dictionary["yTitle"] = newValue }
    }

    public var yMax: Int? {
        get { dictionary["yMax"] as? Int }
        set { dictionary["yMax"] = newValue }
    }

    public var yMin: Int? {
        get { dictionary["yMin"] as? Int }
        set { dictionary["yMin"] = newValue }
    }

    public var xTitle: String? {
        get { dictionary["xTitle"] as? String }
        set { dictionary["xTitle"] = newValue }
    }

    public var xMax: Int? {
        get { dictionary["xMax"] as? Int }
        set { dictionary["xMax"] = newValue }
    }

    public var xMin: Int? {
        get { dictionary["xMin"] as? Int }
        set { dictionary["xMin"] = newValue }
    }

    public var rowOrder: [String]? {
        get { dictionary["rowOrder"] as? [String] }
        set { dictionary["rowOrder"] = newValue }
    }

    public var tableColumns: [FieldTableColumn]? {
        get { (dictionary["tableColumns"] as? [[String: Any]])?.compactMap(FieldTableColumn.init) ?? [] }
        set { dictionary["tableColumns"] = newValue?.compactMap{ $0.dictionary } }
    }

    public var tableColumnOrder: [String]? {
        get { dictionary["tableColumnOrder"] as? [String] }
        set { dictionary["tableColumnOrder"] = newValue }
    }

    enum CodingKeys: String, CodingKey {
        case type
        case id = "_id"
        case identifier, title, value
        case fieldRequired = "required"
        case disabled, metadata, file, options, multi, yTitle, yMax, yMin, xTitle, xMax, xMin, rowOrder, tableColumns, tableColumnOrder
        case tipTitle, tipDescription, tipVisible
    }

    public var valueToValueElements: [ValueElement]? {
        switch value {
        case .valueElementArray(let array):
            return array
        default:
            return nil
        }
    }

    public mutating func deleteRow(id: String) {
        guard var elements = valueToValueElements, let index = elements.firstIndex(where: { $0.id == id }) else {
            return
        }

        var element = elements[index]
        element.setDeleted()
        elements[index] = element

        self.value = ValueUnion.valueElementArray(elements)
    }

    public mutating func addRow(id: String) {
        guard var elements = valueToValueElements else {
            return
        }

        elements.append(ValueElement(id: id))
        self.value = ValueUnion.valueElementArray(elements)
        rowOrder?.append(id)
    }

    public mutating func cellDidChange(rowId: String, colIndex: Int, editedCell: FieldTableColumn) {
        guard var elements = valueToValueElements, let index = elements.firstIndex(where: { $0.id == rowId }) else {
            return
        }

        switch editedCell.type {
        case "text":
            changeCell(elements: elements, index: index, editedCellId: editedCell.id, newCell: ValueUnion.string(editedCell.title ?? ""))
        case "dropdown":
            changeCell(elements: elements, index: index, editedCellId: editedCell.id, newCell: ValueUnion.string(editedCell.defaultDropdownSelectedId ?? ""))
        case "image":
            changeCell(elements: elements, index: index, editedCellId: editedCell.id, newCell: ValueUnion.valueElementArray(editedCell.images ?? []))
        default:
            return
        }
    }

    private mutating func changeCell(elements: [ValueElement], index: Int, editedCellId: String?, newCell: ValueUnion) {
        var elements = elements
        if var cells = elements[index].cells {
            cells[editedCellId ?? ""] = newCell
            elements[index].cells = cells
        } else {
            elements[index].cells = [editedCellId ?? "" : newCell]
        }

        self.value = ValueUnion.valueElementArray(elements)
    }

}

public struct ChartAxisConfiguration: Equatable{
    public var yTitle: String?
    public var yMax, yMin: Int?
    public var xTitle: String?
    public var xMax, xMin: Int?

    enum CodingKeys: String, CodingKey {
        case yTitle, yMax, yMin, xTitle, xMax, xMin
    }
    public init(yTitle: String? = nil, yMax: Int? = nil, yMin: Int? = nil, xTitle: String? = nil, xMax: Int? = nil, xMin: Int? = nil) {
        self.yTitle = yTitle
        self.yMax = yMax
        self.yMin = yMin
        self.xTitle = xTitle
        self.xMax = xMax
        self.xMin = xMin
    }
}

// MARK: - Metadata
public struct Metadata {
    public var dictionary: [String: Any]

    public init?(dictionary: [String: Any]?) {
        guard let metadata = dictionary else { return nil}
        self.dictionary = metadata
    }

    public var deficiencies: Bool? {
        get { dictionary["deficiencies"] as? Bool }
        set { dictionary["deficiencies"] = newValue }
    }

    public var blockImport: Bool? {
        get { dictionary["blockImport"] as? Bool }
        set { dictionary["blockImport"] = newValue }
    }

    public var blockAutoPopulate: Bool? {
        get { dictionary["blockAutoPopulate"] as? Bool }
        set { dictionary["blockAutoPopulate"] = newValue }
    }

    public var requireDeficiencyTitle: Bool? {
        get { dictionary["requireDeficiencyTitle"] as? Bool }
        set { dictionary["requireDeficiencyTitle"] = newValue }
    }

    public var requireDeficiencyDescription: Bool? {
        get { dictionary["requireDeficiencyDescription"] as? Bool }
        set { dictionary["requireDeficiencyDescription"] = newValue }
    }

    public var requireDeficiencyPhoto: Bool? {
        get { dictionary["requireDeficiencyPhoto"] as? Bool }
        set { dictionary["requireDeficiencyPhoto"] = newValue }
    }

    public var list: String? {
        get { dictionary["list"] as? String }
        set { dictionary["list"] = newValue }
    }

    public var listColumn: String? {
        get { dictionary["listColumn"] as? String }
        set { dictionary["listColumn"] = newValue }
    }
}

// MARK: - Option
public struct Option: Identifiable {
    var dictionary: [String: Any]

    public init(dictionary: [String: Any] = [:]) {
        self.dictionary = dictionary
    }

    public var value: String? {
        get { dictionary["value"] as? String }
        set { dictionary["value"] = newValue }
    }

    public var deleted: Bool? {
        get { dictionary["deleted"] as? Bool }
        set { dictionary["deleted"] = newValue }
    }

    public var id: String? {
        get { dictionary["_id"] as? String }
        set { dictionary["_id"] = newValue }
    }

    public var width: Int? {
        get { dictionary["width"] as? Int }
        set { dictionary["width"] = newValue }
    }
}

// MARK: - FieldTableColumn
public struct FieldTableColumn {
    var dictionary: [String: Any]

    public init(dictionary: [String: Any] = [:]) {
        self.dictionary = dictionary
    }

    public var id: String? {
        get { dictionary["_id"] as? String }
        set { dictionary["_id"] = newValue }
    }

    public var type: String? {
        get { dictionary["type"] as? String }
        set { dictionary["type"] = newValue }
    }

    public var title: String? {
        get { dictionary["title"] as? String }
        set { dictionary["title"] = newValue }
    }

    public var width: Int? {
        get { dictionary["width"] as? Int }
        set { dictionary["width"] = newValue }
    }

    public var identifier: String? {
        get { dictionary["identifier"] as? String }
        set { dictionary["identifier"] = newValue }
    }

    public var options: [Option]? {
        get { (dictionary["options"] as? [[String: Any]])?.compactMap(Option.init) ?? [] }
        set { dictionary["options"] = newValue?.compactMap{ $0.dictionary } }
    }

    public var value: String? {
        get { dictionary["value"] as? String }
        set { dictionary["value"] = newValue }
    }

    public var defaultDropdownSelectedId: String? {
        get { dictionary["defaultDropdownSelectedId"] as? String }
        set { dictionary["defaultDropdownSelectedId"] = newValue }
    }

    public var images: [ValueElement]? {
        get { (dictionary["images"] as? [[String: Any]])?.compactMap(ValueElement.init) ?? [] }
        set { dictionary["images"] = newValue?.compactMap{ $0.dictionary } }
    }
}

public enum ValueUnion: Codable, Hashable {
    case double(Double)
    case string(String)
    case array([String])
    case valueElementArray([ValueElement])
    case dictionary([String: ValueUnion])
    case bool(Bool)
    case null

    public init(dcitonary: [String: ValueUnion]) {
        self = .dictionary(dcitonary)
    }

    public init(dcitonary: [String: Any]) {
        var dictionary = [String : ValueUnion]()
        dcitonary.forEach { dict in
            dictionary[dict.key] = ValueUnion(value: dict.value)
        }
        self = .dictionary(dictionary)
    }

    public init?(valueFromDcitonary: [String: Any]) {
        guard let value = valueFromDcitonary["value"] else { return nil }
        self.init(value: value)
    }

    public init?(value: Any) {
        if let doubleValue = value as? Double {
            self = .double(doubleValue)
            return
        }

        if let boolValue = value as? Bool {
            self = .bool(boolValue)
            return
        }

        if let valueUnion = value as? ValueUnion {
            self = valueUnion
            return
        }

        if let strValue = value as? String {
            self = .string(strValue)
            return
        }

        if let arrayValue = value as? [String] {
            self = .array(arrayValue)
            return
        }

        if let valueElementArray = value as? [[String: Any]] {
            self = .valueElementArray(valueElementArray.map(ValueElement.init))
            return
        }

        if let valueElementArray = value as? [ValueElement] {
            self = .valueElementArray(valueElementArray)
            return
        }

        if let valueDictonary = value as? [String: Any] {
            self = ValueUnion.init(dcitonary: valueDictonary)
            return
        }

        if let valueDictonary = value as? NSNull {
            self = .null
            return
        }
#if DEBUG
        fatalError()
#else
        self = .null
#endif
    }

    public var dictionary: Any? {
        switch self {
        case .double(let double):
            return double
        case .string(let string):
            return string
        case .array(let stringArray):
            return stringArray
        case .valueElementArray(let valueElementArray):
            return valueElementArray.map { $0.anyDictionary }
        case .bool(let bool):
            return bool
        case .null:
            return nil
        case .dictionary(let dictionary):
            var anyDict = [String: Any]()
            dictionary.forEach { (key: String, value: ValueUnion) in
                anyDict[key] = value.dictionary
            }
            return anyDict
        }
    }

    var dictionaryWithValueUnionTypes: Any? {
        switch self {
        case .double(let double):
            return double
        case .string(let string):
            return string
        case .array(let stringArray):
            return stringArray
        case .valueElementArray(let valueElementArray):
            return valueElementArray
        case .bool(let bool):
            return bool
        case .null:
            return nil
        case .dictionary(let dictionary):
            return dictionary
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Double.self) {
            self = .double(x)
            return
        }
        if let x = try? container.decode([ValueElement].self) {
            self = .valueElementArray(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode([String].self) {
            self = .array(x)
            return
        }
        if let x = try? container.decode(Bool.self) {
            self = .bool(x)
            return
        }
        if container.decodeNil() {
            self = .null
            return
        }
        throw DecodingError.typeMismatch(ValueUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ValueUnion"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .double(let x):
            if x.truncatingRemainder(dividingBy: 1) == 0 {
                try container.encode(Double(x))
            } else {
                try container.encode(x)
            }
        case .string(let x):
            try container.encode(x)
        case .valueElementArray(let x):
            try container.encode(x)
        case .array(let x):
            try container.encode(x)
        case .bool(let x):
            try container.encode(x)
        case .null:
            try container.encodeNil()
        case .dictionary(let dictionary):
            try container.encode(dictionary)
        }
    }
}

// MARK: - ValueElement
public struct ValueElement: Codable, Equatable, Hashable, Identifiable {
    var dictionary = [String: ValueUnion]()

    public var anyDictionary: [String: Any] {
        var dict = [String: Any]()
        dictionary.forEach { (key: String, value: ValueUnion) in
            dict[key] = value.dictionary
        }
        return dict
    }

    public static func == (lhs: ValueElement, rhs: ValueElement) -> Bool {
        lhs.id == rhs.id
    }

    public init(dictionary: [String: Any] = [:]) {
        dictionary.forEach { (key: String, value: Any) in
            self.dictionary[key] = ValueUnion(value: value)
        }
    }

    public init(from decoder: Decoder) throws {
        guard let container = try? decoder.container(keyedBy: CodingKeys.self) else {
            // Handle the error or return an appropriate value
            return
        }
        let allKeys = container.allKeys
        for key in allKeys {
            dictionary[key.stringValue] = try container.decodeIfPresent(ValueUnion.self, forKey: key)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        for (key, value) in dictionary {
            if let value = value as? ValueUnion {
                guard let codingKey = CodingKeys(stringValue: key) else { return }
                try container.encode(value, forKey: codingKey)
            }
        }
    }

    enum CodingKeys: String, CodingKey {
        case _id, url, fileName, filePath, deleted, title, description, points, cells
    }

    public init(id: String, deleted: Bool = false, description: String = "", title: String = "", points: [Point]?) {
        self.id = id
        self.points = points
        self.deleted = false
        self.description = ""
        self.title = ""
    }

    public init(id: String, url: String? = nil) {
        self.id = id
        self.url = url
    }

    mutating func setValue(_ value: String?, key: String) {
        guard let value = value else {
            return
        }
        self.dictionary[key] = .string(value)
    }

    mutating func setValue(_ value: Bool?, key: String) {
        guard let value = value else {
            return
        }
        self.dictionary[key] = .bool(value)
    }

    public var id: String? {
        get { (dictionary["_id"] as? ValueUnion)?.text}
        set { setValue(newValue, key: "_id") }
    }

    public var url: String? {
        get { (dictionary["url"] as? ValueUnion)?.text}
        set { setValue(newValue, key: "url") }
    }

    public var fileName: String? {
        get { (dictionary["fileName"] as? ValueUnion)?.text}
        set { setValue(newValue, key: "fileName") }
    }

    public var filePath: String? {
        get { (dictionary["filePath"] as? ValueUnion)?.text}
        set { setValue(newValue, key: "filePath") }
    }

    public var deleted: Bool? {
        get { (dictionary["deleted"] as? ValueUnion)?.bool}
        set { setValue(newValue, key: "deleted") }

    }

    public var title: String? {
        get { (dictionary["title"] as? ValueUnion)?.text}

        set { setValue(newValue, key: "title") }
    }

    public var description: String? {
        get { (dictionary["description"] as? ValueUnion)?.text}

        set { setValue(newValue, key: "description") }
    }

    public var points: [Point]? {
        get {
            let value = ((dictionary["points"] as? ValueUnion)?.dictionaryWithValueUnionTypes as? [ValueElement])
            return value?.compactMap(Point.init)
        }

        set {
            guard let value = newValue else {
                return
            }
            let dictValueUnion = value.flatMap { point in
                var dictAny = [String: ValueUnion]()
                let dict = point.dictionary.forEach { (key, value) in
                    dictAny[key] = ValueUnion(value: value)
                }
                return ValueElement(dictionary: dictAny)
            } as? [ValueElement]

            guard let dictValueUnion else {
                fatalError()
                return
            }
            self.dictionary["points"] = .valueElementArray(dictValueUnion)
        }
    }

    public var cells: [String: ValueUnion]? {
        get {
            let value = dictionary["cells"] as? ValueUnion
            return value?.dictionaryWithValueUnionTypes as? [String: ValueUnion]
        }
        set {
            guard let value = newValue else { return }
            self.dictionary["cells"] = ValueUnion.dictionary(value)
        }
    }

    public mutating func setDeleted() {
        deleted = true
    }
}

// MARK: - Point
public struct Point: Codable {
    var dictionary = [String: ValueUnion]()

    public init(from decoder: Decoder) throws {
        guard let container = try? decoder.container(keyedBy: CodingKeys.self) else {
            // Handle the error or return an appropriate value
            return
        }
        let allKeys = container.allKeys
        for key in allKeys {
            dictionary[key.stringValue] = try container.decodeIfPresent(ValueUnion.self, forKey: key)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        for (key, value) in dictionary {
            if let value = value as? ValueUnion {
                try container.encode(value, forKey: CodingKeys(stringValue: key)!)
            }
        }
    }

    enum CodingKeys: String, CodingKey {
        case _id, label, y, x
    }

    public init(dictionary: [String: Any] = [:]) {
        dictionary.forEach { (key: String, value: Any) in
            self.dictionary[key] = ValueUnion(value: value)
        }
    }

    init(valueElement: ValueElement) {
        self.dictionary = valueElement.dictionary
    }

    public init(id: String) {
        self.id = id
        self.x = 0
        self.y = 0
        self.label = ""
    }

    mutating func setValue(_ value: String?, key: String) {
        guard let value = value else {
            return
        }

        self.dictionary[key] = .string(value)
    }

    mutating func setValue(_ value: CGFloat?, key: String) {
        guard let value = value else {
            return
        }
        self.dictionary[key] = .double(value)
    }

    public var id: String? {
        get { (dictionary["_id"] as? ValueUnion)?.text }
        set { setValue(newValue, key: "_id") }
    }

    public var label: String? {
        get { (dictionary["label"] as? ValueUnion)?.text }
        set { setValue(newValue, key: "label") }
    }

    public var y: CGFloat? {
        get {
            guard let valueUnion = (dictionary["y"] as? ValueUnion)?.number else { return nil }
            return CGFloat(valueUnion)
        }
        set { setValue(newValue, key: "y") }
    }

    public var x: CGFloat? {
        get {
            guard let valueUnion = (dictionary["x"] as? ValueUnion)?.number else { return nil }
            return CGFloat(valueUnion)
        }
        set { setValue(newValue, key: "x") }
    }
}

// MARK: - Page
public struct Page {
    var dictionary: [String: Any]

    public init(dictionary: [String: Any] = [:]) {
        self.dictionary = dictionary
    }

    public var name: String? {
        get { dictionary["name"] as? String }
        set { dictionary["name"] = newValue }
    }

    public var fieldPositions: [FieldPosition]? {
        get { (dictionary["fieldPositions"] as? [[String: Any]])?.compactMap(FieldPosition.init) ?? [] }
        set { dictionary["fieldPositions"] = newValue?.compactMap{ $0.dictionary } }
    }

    public var metadata: Metadata? {
        get { Metadata.init(dictionary: dictionary["metadata"] as? [String: Any])}
        set { dictionary["metadata"] = newValue?.dictionary }
    }

    public var width: Double? {
        get { dictionary["width"] as? Double }
        set { dictionary["width"] = newValue }
    }

    public var height: Double? {
        get { dictionary["height"] as? Double }
        set { dictionary["height"] = newValue }
    }

    public var cols: Double? {
        get { dictionary["cols"] as? Double }
        set { dictionary["cols"] = newValue }
    }

    public var rowHeight: Double? {
        get { dictionary["rowHeight"] as? Double }
        set { dictionary["rowHeight"] = newValue }
    }

    public var layout: String? {
        get { dictionary["layout"] as? String }
        set { dictionary["layout"] = newValue }
    }

    public var presentation: String? {
        get { dictionary["presentation"] as? String }
        set { dictionary["presentation"] = newValue }
    }

    public var margin: Double? {
        get { dictionary["margin"] as? Double }
        set { dictionary["margin"] = newValue }
    }

    public var padding: Double? {
        get { dictionary["padding"] as? Double }
        set { dictionary["padding"] = newValue }
    }

    public var borderWidth: Double? {
        get { dictionary["borderWidth"] as? Double }
        set { dictionary["borderWidth"] = newValue }
    }

    public var id: String? {
        get { dictionary["_id"] as? String }
        set { dictionary["_id"] = newValue }
    }

    public var backgroundImage: String? {
        get { dictionary["backgroundImage"] as? String }
        set { dictionary["backgroundImage"] = newValue }
    }

    public var hidden: Bool? {
        get { dictionary["hidden"] as? Bool }
        set { dictionary["hidden"] = newValue }
    }
}

// MARK: - FieldPosition
public struct FieldPosition {
    public var dictionary: [String: Any]

    public init(dictionary: [String: Any] = [:]) {
        self.dictionary = dictionary
    }

    public var field: String? {
        get { dictionary["field"] as? String }
        set { dictionary["field"] = newValue }
    }

    public var displayType: String? {
        get { dictionary["displayType"] as? String }
        set { dictionary["displayType"] = newValue }
    }

    public var width: Double? {
        get { dictionary["width"] as? Double }
        set { dictionary["width"] = newValue }
    }

    public var height: Double? {
        get { dictionary["height"] as? Double }
        set { dictionary["height"] = newValue }
    }

    public var x: Double? {
        get { dictionary["x"] as? Double }
        set { dictionary["x"] = newValue }
    }

    public var y: Double? {
        get { dictionary["y"] as? Double }
        set { dictionary["y"] = newValue }
    }

    public var lineHeight: Double? {
        get { dictionary["lineHeight"] as? Double }
        set { dictionary["lineHeight"] = newValue }
    }

    public var id: String? {
        get { dictionary["_id"] as? String }
        set { dictionary["_id"] = newValue }
    }

    public var targetValue: String? {
        get { dictionary["targetValue"] as? String }
        set { dictionary["targetValue"] = newValue }
    }

    public var condition: String? {
        get { dictionary["condition"] as? String }
        set { dictionary["condition"] = newValue }
    }

    public var targetValueDisplayType: String? {
        get { dictionary["targetValueDisplayType"] as? String }
        set { dictionary["targetValueDisplayType"] = newValue }
    }

    public var titleDisplay: String? {
        get { dictionary["titleDisplay"] as? String }
        set { dictionary["titleDisplay"] = newValue }
    }

    public var type: FieldTypes {
        get { FieldTypes(rawValue: dictionary["type"] as! String)! }
        set { dictionary["type"] = newValue.rawValue }
    }

    public var fontSize: Double? {
        get { dictionary["fontSize"] as? Double }
        set { dictionary["fontSize"] = newValue }
    }

    public var fontColor: String? {
        get { dictionary["fontColor"] as? String }
        set { dictionary["fontColor"] = newValue }
    }

    public var fontStyle: String? {
        get { dictionary["fontStyle"] as? String }
        set { dictionary["fontStyle"] = newValue }
    }

    public var fontWeight: String? {
        get { dictionary["fontWeight"] as? String }
        set { dictionary["fontWeight"] = newValue }
    }

    public var textAlign: String? {
        get { dictionary["textAlign"] as? String }
        set { dictionary["textAlign"] = newValue }
    }

    public var primaryDisplayOnly: Bool? {
        get { dictionary["primaryDisplayOnly"] as? Bool }
        set { dictionary["primaryDisplayOnly"] = newValue }
    }

    public var format: String? {
        get { dictionary["format"] as? String }
        set { dictionary["format"] = newValue }
    }

    public var column: String? {
        get { dictionary["column"] as? String }
        set { dictionary["column"] = newValue }
    }

    public var backgroundColor: String? {
        get { dictionary["backgroundColor"] as? String }
        set { dictionary["backgroundColor"] = newValue }
    }

    public var borderColor: String? {
        get { dictionary["borderColor"] as? String }
        set { dictionary["borderColor"] = newValue }
    }

    public var textDecoration: String? {
        get { dictionary["textDecoration"] as? String }
        set { dictionary["textDecoration"] = newValue }
    }

    public var borderWidth: Double? {
        get { dictionary["borderWidth"] as? Double }
        set { dictionary["borderWidth"] = newValue }
    }

    public var borderRadius: Double? {
        get { dictionary["borderRadius"] as? Double }
        set { dictionary["borderRadius"] = newValue }
    }
}

/// MARK: - ModelView
public struct ModelView {
    var dictionary: [String: Any]

    public init(dictionary: [String: Any] = [:]) {
        self.dictionary = dictionary
    }

    public var type: String? {
        get { dictionary["type"] as? String }
        set { dictionary["type"] = newValue }
    }

    public var pageOrder: [String]? {
        get { dictionary["pageOrder"] as? [String] }
        set { dictionary["pageOrder"] = newValue }
    }

    public var pages: [Page]? {
        get { (dictionary["pages"] as? [[String: Any]])?.compactMap(Page.init) ?? [] }
        set { dictionary["pages"] = newValue?.compactMap({ $0.dictionary}) }
    }

    public var id: String? {
        get { dictionary["_id"] as? String }
        set { dictionary["_id"] = newValue }
    }
}

public func generateObjectId() -> String {
    // Get the current timestamp in seconds and convert to a hexadecimal string
    let timestamp = Int(Date().timeIntervalSince1970)
    let timestampHex = String(format: "%08x", timestamp)

    // Generate a random string of 16 hexadecimal characters
    var randomHex = ""
    for _ in 0..<8 {
        let randomValue = UInt32.random(in: 0..<UInt32.max)
        randomHex += String(format: "%08x", randomValue)
    }

    // Concatenate the timestamp hex and a portion of the random hex string to match the desired length
    return timestampHex + randomHex.prefix(16)
}
