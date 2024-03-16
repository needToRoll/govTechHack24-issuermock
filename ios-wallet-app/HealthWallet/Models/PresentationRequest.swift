import Foundation
import SwiftUI

struct PresentationRequest: Hashable, Codable {

  enum CodingKeys: String, CodingKey {
    case type
    case dateFrom
    case dateTo
    case url = "presentUrl"
  }

  var type: String?
  var dateFrom: Date?
  var dateTo: Date?
  var url: URL?

  var predicate: Predicate<Credential>? {
    if let type, let dateFrom, let dateTo {
      return #Predicate<Credential> {
        $0.type == type && $0.issuedAt >= dateFrom && $0.issuedAt <= dateTo
      }
    } else if let type, let dateFrom {
      return #Predicate<Credential> {
        $0.type == type && $0.issuedAt >= dateFrom
      }
    } else if let type, let dateTo {
      return #Predicate<Credential> {
        $0.type == type && $0.issuedAt <= dateTo
      }
    } else if let dateTo {
      return #Predicate<Credential> {
        $0.issuedAt <= dateTo
      }
    } else if let dateFrom {
      return #Predicate<Credential> {
        $0.issuedAt >= dateFrom
      }
    } else {
      return nil
    }
  }

}
