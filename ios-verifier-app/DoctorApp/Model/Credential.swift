import Foundation
import SwiftData
import SwiftUI

// MARK: - Credential

final class Credential: Identifiable, Codable {

  // MARK: Lifecycle

  init(id: UUID = .init(), name: String, type: CredentialType, issuedAt: Date = Date(), content: [String: String] = [:]) {
    self.id = id
    self.type = type
    self.issuedAt = issuedAt
    self.content = content
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(UUID.self, forKey: .id)
    type = try container.decode(CredentialType.self, forKey: .type)
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

  var id: UUID
  var type: CredentialType
  var issuedAt: Date
  let content: [String: String]

  var displayName: String {
    switch type {
    case .insurance: "Helsana"
    case .allergy: content["allergyDescription"] ?? ""
    case .diagnosis: content["diagnosisDescription"] ?? ""
    case .medication: content["medicationName"] ?? ""
    }
  }

  var displayCode: String {
    switch type {
    case .insurance: "BASIC"
    case .allergy: content["allergyCode"] ?? ""
    case .diagnosis: content["diagnosisCode"] ?? ""
    case .medication: content["medicationCode"] ?? ""
    }
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
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
  case insurance = "Insurance"
  case allergy = "AllergyIntolerance"
  case diagnosis = "Diagnosis"
  case medication = "Medication"

  // MARK: Internal

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
    }
  }

  var image: Image {
    switch self {
    case .insurance: Image(systemName: "timelapse")
    case .allergy: Image(systemName: "allergens")
    case .diagnosis: Image(systemName: "checkmark.seal")
    case .medication: Image(systemName: "hazardsign")
    }
  }
}

extension Credential {
  static func sample() -> Credential {
    .init(name: "test", type: .allergy, content: [
      "allergyCode": "L50.0",
      "allergyDescription": "UrtikariaUrtikaria UrtikariaUrtikariaUrtikaria Urtikaria",
      "reactionCode": "R20",
      "severity": "3",
    ])
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

extension Date {
  fileprivate static func generateRandomDate() -> Date? {
    let calendar = Calendar.current
    let startYear = 2020
    let endYear = 2023

    // Start date components
    var startDateComponents = DateComponents()
    startDateComponents.year = startYear

    // End date components
    var endDateComponents = DateComponents()
    endDateComponents.year = endYear
    endDateComponents.month = 12
    endDateComponents.day = 31

    guard
      let startDate = calendar.date(from: startDateComponents),
      let endDate = calendar.date(from: endDateComponents) else
    {
      return nil
    }

    let timeIntervalStart = startDate.timeIntervalSince1970
    let timeIntervalEnd = endDate.timeIntervalSince1970

    let randomTimeInterval = Double.random(in: timeIntervalStart...timeIntervalEnd)

    return Date(timeIntervalSince1970: randomTimeInterval)
  }
}
