import Foundation
import Papyrus
import SwiftData
import SwiftUI

struct PresentationView: View {

  // MARK: Lifecycle

  init(request: PresentationRequest) {
    self.request = request

    _credentials = Query(
      FetchDescriptor<Credential>(
        predicate: request.predicate,
        sortBy: [SortDescriptor(\.issuedAt, order: .reverse)]),
      animation: .smooth)
    predicate = request.predicate
  }

  // MARK: Internal

  var body: some View {
    ZStack(alignment: .bottom) {
      ScrollView {
        VStack {
          CredentialListView(predicate: predicate)
        }
        .padding()
        .padding(.bottom, 100)
      }

      VStack {
        Button(action: {
          navigation.root()
        }, label: {
          Text("Cancel")
            .frame(maxWidth: .infinity)
            .padding(8)
        })
        .buttonStyle(.borderedProminent)
        .background(.white)

        Button(action: {
          send(request: request)
        }, label: {
          Text("Send")
            .frame(maxWidth: .infinity)
            .padding(8)
        })
        .buttonStyle(.borderedProminent)
      }
      .padding()
    }
    .navigationTitle("Share")
  }

  // MARK: Private

  @Query private var credentials: [Credential]

  private var request: PresentationRequest
  private var predicate: Predicate<Credential>?
  @EnvironmentObject private var navigation: WalletNavigation

  private func send(request: PresentationRequest) {
    Task {
      guard let url = URL(string: "https://vcs-api.gentleisland-c311affe.switzerlandnorth.azurecontainerapps.io/present") else { return }
      let api = VerifierAPI(provider: .init(baseURL: url.deletingLastPathComponent().absoluteString))
      do {
        try await api.sendCredentials(credentials)
        navigation.root()
      } catch {
        print(error.localizedDescription)
        if let error = error as? PapyrusError {
          print("Error making request \(error.request): \(error.message). Response was: \(error.response)")
        }

        navigation.root()
      }
    }
  }

}
