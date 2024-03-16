import SwiftUI

@main
struct DoctorAppApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView(viewModel: ContentViewModel())
    }
  }
}
