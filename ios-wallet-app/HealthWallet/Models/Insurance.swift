import Foundation
import SwiftData

@Model
final class InsuranceCredential: Codable, Identifiable {

  // MARK: Lifecycle

  init(id: UUID = .init(), cardNumber: String, holderName: String, dateOfBirth: Date, gender: String, insuranceCompany: String) {
    self.id = id
    self.cardNumber = cardNumber
    self.holderName = holderName
    self.dateOfBirth = dateOfBirth
    self.gender = gender
    self.insuranceCompany = insuranceCompany
  }

  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = .init()
    cardNumber = try container.decode(String.self, forKey: .cardNumber)
    holderName = try container.decode(String.self, forKey: .holderName)
    dateOfBirth = try container.decode(Date.self, forKey: .dateOfBirth)
    gender = try container.decode(String.self, forKey: .gender)
    insuranceCompany = try container.decode(String.self, forKey: .insuranceCompany)
  }

  // MARK: Internal

  enum CodingKeys: String, CodingKey {
    case cardNumber
    case holderName
    case dateOfBirth
    case gender
    case insuranceCompany
  }

  @Attribute(.unique) var id: UUID
  var cardNumber: String
  var holderName: String
  var dateOfBirth: Date
  var gender: String
  var insuranceCompany: String

  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(cardNumber, forKey: .cardNumber)
    try container.encode(holderName, forKey: .holderName)
    try container.encode(dateOfBirth, forKey: .dateOfBirth)
    try container.encode(gender, forKey: .gender)
    try container.encode(insuranceCompany, forKey: .insuranceCompany)
  }

}
