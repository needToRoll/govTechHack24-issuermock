import Foundation
import SwiftUI

@MainActor
class ContentViewModel: ObservableObject {

  // MARK: Lifecycle

  init() {
  }

  init(verifableCredentialsByMonth: [String: [Credential]]) {
    self.verifableCredentialsByMonth = verifableCredentialsByMonth
  }

  func refresh() {
    verifableCredentialsByMonth = loadVerifiableCredentials()
  }

  // MARK: Internal

  @Published var verifableCredentialsByMonth: [String: [Credential]] = [:]

  // MARK: Private

  private func loadVerifiableCredentials() -> [String: [Credential]] {
    guard let url = Bundle.main.url(forResource: "verifiableCredentials", withExtension: "json") else {
      print("VerifiableCredentials JSON file not found")
      return [:]
    }

    do {
      let data = try Data(contentsOf: url)
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .iso8601
      let credentials = try decoder.decode([Credential].self, from: data)
      return groupByMonth(credentials)
    } catch {
      print("Error decoding VerifiableCredentials JSON: \(error)")
      return [:]
    }
  }

  private func getVerifiableCredentials() async throws -> [String: [Credential]] {
    let urlString = "https://spring-springbackend-rla.test.azuremicroservices.io/govtech24-springbackend/default/api/v1/mock/vc/medical"
    guard let url = URL(string: urlString) else {
      throw URLError(.badURL)
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"

    let loginString = "primary:yI0LPJwOF5HqwHC3LnICdX5b6sqXIw2RppFNkWa2l1NuiAfAVMb9IeH6iPIC5o3F"
    guard let loginData = loginString.data(using: .utf8) else {
      throw URLError(.userAuthenticationRequired)
    }
    let base64LoginString = loginData.base64EncodedString()

    request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")

    let (data, _) = try await URLSession.shared.data(for: request)

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601

    let credentials = try decoder.decode([Credential].self, from: data)
    return groupByMonth(credentials)
  }

  private func groupByMonth(_ credentials: [Credential]) -> [String: [Credential]] {
    let groupedCredentials = Dictionary(grouping: credentials) { credential -> String in
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM"
      return formatter.string(from: credential.issuedAt)
    }
    let sortedGroupedCredentials = groupedCredentials.mapValues { credentials in
      credentials.sorted { $0.issuedAt < $1.issuedAt }
    }
    return sortedGroupedCredentials
  }

}
