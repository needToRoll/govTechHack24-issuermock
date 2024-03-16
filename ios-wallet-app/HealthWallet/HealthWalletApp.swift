import SwiftData
import SwiftUI

@main
struct HealthWalletApp: App {

  var sharedModelContainer: ModelContainer = {
    let schema = Schema([
      Credential.self,
      InsuranceCredential.self,
    ])

    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

    do {
      return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }()

  @StateObject var walletNavigation: WalletNavigation = .init()

  var body: some Scene {
    WindowGroup {
      NavigationStack(path: $walletNavigation.path) {
        WalletView()
      }
    }
    .environmentObject(walletNavigation)
    .modelContainer(sharedModelContainer)
  }
}
