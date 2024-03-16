import Foundation
import SwiftData
import SwiftUI

// MARK: - Credential

@Model
final class Credential: Identifiable, Codable {

  // MARK: Lifecycle

  init(id: UUID = .init(), type: CredentialType, issuedAt: Date = Date(), content: [String: String] = [:]) {
    self.id = id
    self.type = type.rawValue
    self.issuedAt = issuedAt
    self.content = content
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(UUID.self, forKey: .id)
    type = try container.decode(String.self, forKey: .type)
    issuedAt = try container.decode(Date.self, forKey: .issuedAt)

    let contentContainer = try container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .content)
    var contentDict = [String: String]()

    for key in contentContainer.allKeys {
      if let boolValue = try? contentContainer.decode(Bool.self, forKey: key) {
        contentDict[key.stringValue] = String(boolValue)
      } else if let intValue = try? contentContainer.decode(Int.self, forKey: key) {
        contentDict[key.stringValue] = String(intValue)
      } else if let doubleValue = try? contentContainer.decode(Double.self, forKey: key) {
        contentDict[key.stringValue] = String(doubleValue)
      } else if let stringValue = try? contentContainer.decode(String.self, forKey: key) {
        contentDict[key.stringValue] = stringValue
      } else {
        // Handle other types or skip
        print("Warning: Skipping key \(key.stringValue) due to unexpected type")
      }
    }

    content = contentDict
  }

  // MARK: Internal

  @Attribute(.unique) var id: UUID
  var type: String
  var issuedAt: Date
  let content: [String: String]

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(type, forKey: .type)
    try container.encode(issuedAt, forKey: .issuedAt)
    try container.encode(content, forKey: .content)
  }

  // MARK: Private

  private enum CodingKeys: String, CodingKey {
    case id
    case type
    case issuedAt = "issueDate"
    case content
  }

}

// MARK: - CredentialType

enum CredentialType: String, Codable, CaseIterable {
  case all = "All"
  case insurance = "Insurance"
  case allergy = "AllergyIntolerance"
  case diagnosis = "Diagnosis"
  case medication = "Medication"
  case unknown

  // MARK: Internal

  static var allowedCases: [CredentialType] {
    [.allergy, .diagnosis, .medication]
  }

  static var searchableCases: [CredentialType] {
    [.all, .allergy, .diagnosis, .medication]
  }

  var displayName: String {
    switch self {
    case .allergy: "Allergy"
    default: rawValue
    }
  }

  var backgroundColor: Color {
    switch self {
    case .insurance: .green
    case .allergy: .orange
    case .diagnosis: .purple
    case .medication: .blue
    default: .red
    }
  }

  var image: Image {
    switch self {
    case .insurance: Image(systemName: "timelapse")
    case .allergy: Image(systemName: "allergens")
    case .diagnosis: Image(systemName: "checkmark.seal")
    case .medication: Image(systemName: "hazardsign")
    default: Image(systemName: "questionmark.circle")
    }
  }

}

// MARK: - DynamicCodingKeys

fileprivate struct DynamicCodingKeys: CodingKey {
  var stringValue: String
  var intValue: Int?

  init?(stringValue: String) {
    self.stringValue = stringValue
    intValue = nil
  }

  init?(intValue: Int) {
    stringValue = String(intValue)
    self.intValue = intValue
  }
}
