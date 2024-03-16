import Papyrus
import SwiftData
import SwiftUI

// MARK: - WalletView

struct WalletView: View {

  // MARK: Internal

  var body: some View {
    ZStack(alignment: .bottom) {
      ScrollView {
        if let insurance = insurances.first {
          InsuranceCard(credential: insurance)
            .padding()
        } else {
          Color(uiColor: .tertiarySystemGroupedBackground)
            .blur(radius: 3.0)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .frame(maxWidth: .infinity, minHeight: 225, maxHeight: 225)
            .overlay {
              VStack(spacing: 24) {
                Image(systemName: "qrcode")
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .frame(width: 70, height: 70)
                Text("Scan your insurance card QRCode or request one at your insurance company.")
                  .frame(maxWidth: 300)
                  .multilineTextAlignment(.center)
              }
            }
            .padding()
            .onTapGesture {
              navigation.push(WalletRoute.scanner)
            }
        }

        VStack {
          CredentialListView(predicate: selectedCategory == .all ? nil : #Predicate {
            $0.type == selectedCategory.rawValue
          })
        }
        .padding()
        .padding(.bottom, 72)
      }
      .refreshable {
        await refresh()
      }

      actionBar()
    }
    .alert("Wipe database ?", isPresented: $presentDeleteConfirmation, actions: {
      Button(role: .destructive) {
        wipeDatabase()
      } label: {
        Text("Confirm")
      }

      Button(role: .cancel) {} label: {
        Text("Cancel")
      }
    })
    .onShake {
      presentDeleteConfirmation = true
    }
    .navigationTitle("HealthWallet")
    .navigationBarTitleDisplayMode(.large)
    .navigationDestination(for: WalletRoute.self, destination: WalletRoute.destination(_:))
  }

  // MARK: Private

  @State private var selectedCategory: CredentialType = .all
  @State private var dates: Set<DateComponents> = .init()
  @State private var presentDeleteConfirmation = false

  @Query private var insurances: [InsuranceCredential]

  @Environment(\.modelContext) private var modelContext
  @EnvironmentObject private var navigation: WalletNavigation

  private func refresh() async {
    try? await Task.sleep(for: .seconds(1))
  }

  private func wipeDatabase() {
    do {
      try modelContext.delete(model: Credential.self)
      try modelContext.delete(model: InsuranceCredential.self)
    } catch {
      print(error.localizedDescription)
      print("Failed to clear DB.")
    }
  }

  @ViewBuilder
  private func actionBar() -> some View {
    Group {
      HStack {
        Picker("Filter", selection: $selectedCategory) {
          ForEach(CredentialType.searchableCases, id: \.self) {
            Text($0.displayName)
          }
        }
        .pickerStyle(.menu)
        .padding(8)
        .background(Color.white)
        .clipShape(.capsule)
        .foregroundStyle(.white)

        Spacer()

        NavigationLink(value: WalletRoute.scanner) {
          Image(systemName: "qrcode")
            .resizable()
            .frame(width: 24, height: 24, alignment: .center)
            .foregroundColor(.white)
        }
        .padding()
        .background(Color.accentColor)
        .clipShape(.circle)
      }
      .padding(8)
    }
    .background(.ultraThinMaterial)
    .background(Color.white.opacity(0.2))
    .clipShape(.capsule)
    .padding(.horizontal, 10)
    .shadow(color: .black.opacity(0.2), radius: 10, y: 6)
  }

}

// MARK: - CredentialListView

struct CredentialListView: View {

  // MARK: Lifecycle

  init(predicate: Predicate<Credential>? = nil, sortBy: [SortDescriptor<Credential>] = [SortDescriptor(\.issuedAt, order: .reverse)]) {
    _credentials = Query(
      FetchDescriptor<Credential>(
        predicate: predicate,
        sortBy: [SortDescriptor(\.issuedAt, order: .reverse)]),
      animation: .smooth)
  }

  // MARK: Internal

  @Query var credentials: [Credential]

  var body: some View {
    VStack(alignment: .leading) {
      ForEach(credentials) { credential in
        CredentialCard(credential: credential)
          .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
              print("Deleting conversation")
            } label: {
              Label("Delete", systemImage: "trash.fill")
            }
          }
      }
    }
  }

}

#Preview {
  WalletView()
    .modelContainer(Seeds.previewContainer)
}
