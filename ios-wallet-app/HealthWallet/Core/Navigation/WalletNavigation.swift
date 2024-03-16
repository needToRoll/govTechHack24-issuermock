import Foundation
import SwiftUI

// MARK: - WalletNavigation

class WalletNavigation: Navigable {
  @Published var path: NavigationPath = .init()
}

// MARK: - WalletRoute

enum WalletRoute: Routable {
  case scanner
  case presentation(_ request: PresentationRequest)

  static func destination(_ route: WalletRoute) -> some View {
    switch route {
    case .scanner:
      AnyView(ScannerView())
    case .presentation(let request):
      AnyView(PresentationView(request: request))
    }
  }
}
