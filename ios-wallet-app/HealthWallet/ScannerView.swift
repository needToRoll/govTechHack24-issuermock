import Foundation
import QRScanner
import SwiftUI

struct ScannerView: View {

  // MARK: Internal

  var body: some View {
    ZStack(alignment: .center) {
      QRScannerView(metadataUrl: $url, isTorchAvailable: .constant(false), isTorchEnabled: .constant(false), qrScannerError: $error)

      Color.clear
        .frame(width: 64, height: 64)
        .background(.ultraThinMaterial)
        .mask(RoundedRectangle(cornerRadius: 16))
        .overlay {
          ProgressView()
            .padding()
        }
        .opacity(isLoading ? 1.0 : 0)
    }
    .navigationTitle("Scan")
    .onChange(of: url) {
      guard let url else { return }

      isLoading = true
      if url.lastPathComponent.contains("medical") {
        fetchCredentials()
      } else if url.lastPathComponent.contains("insurance") {
        fetchInsurance()
      } else if url.lastPathComponent.contains("doctorRequest") {
        fetchPresentation()
      } else if url.lastPathComponent.contains("pharmacy") {
        fetchPharmacyPresentation()
      }
    }
  }

  // MARK: Private

  @State private var url: URL?
  @State private var error: Error?
  @State private var isLoading = false

  @Environment(\.modelContext) private var modelContext
  @EnvironmentObject private var navigation: WalletNavigation

  private func fetchCredentials() {
    Task {
      let api = IssuerAPI(provider: .init(baseURL: Config.issuerBaseURL))
      do {
        let credentials = try await api.getCredentials()
        for credential in credentials {
          modelContext.insert(credential)
        }
        terminate()
      } catch {
        terminate()
      }
    }
  }

  private func fetchInsurance() {
    Task {
      let api = IssuerAPI(provider: .init(baseURL: Config.issuerBaseURL))
      do {
        let insurance = try await api.getInsurance()
        modelContext.insert(insurance)
        terminate()
      } catch {
        terminate()
      }
    }
  }

  private func fetchPresentation() {
    Task {
      let api = VerifierAPI(provider: .init(baseURL: Config.verifierBaseURL))
      do {
        let presentationRequest = try await api.doctorRequest()
        isLoading = false
        navigation.push(WalletRoute.presentation(presentationRequest))
      } catch {
        terminate()
      }
    }
  }

  private func fetchPharmacyPresentation() {
    Task {
      let api = VerifierAPI(provider: .init(baseURL: Config.pharmacyBaseURL))
      do {
        let presentationRequest = try await api.pharmacyRequest()
        isLoading = false
        navigation.push(WalletRoute.presentation(presentationRequest))
      } catch {
        terminate()
      }
    }
  }

  private func terminate() {
    isLoading = false
    navigation.pop()
  }

}
