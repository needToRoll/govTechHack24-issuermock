import SwiftUI

// MARK: - ContentView

struct ContentView: View {

  // MARK: Lifecycle

  init(viewModel: ContentViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  // MARK: Internal

  var body: some View {
    content()
      .ignoresSafeArea(.container, edges: .bottom)
  }

  // MARK: Private

  @StateObject private var viewModel: ContentViewModel
  @State private var selectedCredential: Credential?
  @State private var opacity = 0.0
  @State private var opacityProgressView = 0.0
  @State private var isLoading = false

  @ViewBuilder
  private func content() -> some View {
    if viewModel.verifableCredentialsByMonth.isEmpty {
      HStack {
        Spacer()
        VStack {
          Button("Refresh") {
            isLoading = true
            Task {
              viewModel.refresh()
            }
          }.padding(.top, 70)
          if isLoading {
            ProgressView()
              .opacity(opacityProgressView)
              .animation(.easeInOut(duration: 0.3), value: opacityProgressView)
              .onAppear {
                opacityProgressView = 1.0
              }
          }
          Spacer()
        }
        Spacer()
      }
    } else {
      medicalPatientView()
        .opacity(opacity)
        .animation(.easeInOut(duration: 0.5), value: opacity)
        .onAppear {
          opacity = 1.0
          isLoading = false
        }

    }
  }

  private func medicalPatientView() -> some View {
    VStack {
      HeaderView().padding(EdgeInsets(.init(top: 70, leading: 60, bottom: 0, trailing: 0)))
      patientHistoryView().padding(.top, 50)
      Spacer()
    }
    .sheet(item: $selectedCredential) { credential in
      CredentialDetailView(credential: credential)
    }
    .padding(0)
  }

  @ViewBuilder
  private func patientHistoryView() -> some View {
    ScrollView(.horizontal, showsIndicators: false) {
      VStack {
        HStack(alignment: .top, spacing: 20) {
          ForEach(viewModel.verifableCredentialsByMonth.keys.sorted(), id: \.self) { key in

            VStack(alignment: .leading, spacing: 0) {
              Text(key.convertDateForHeader())
                .font(.headline)
                .padding(.bottom, 20)
                .padding(.leading, 20)
              VStack(spacing: 0) {
                let credentials = viewModel.verifableCredentialsByMonth[key] ?? []
                let columns = Array(
                  repeating: GridItem(.flexible(), spacing: 20),
                  count: max(1, Int(ceil(Double(credentials.count) / 3.0))))
                LazyVGrid(columns: columns, spacing: 20) {
                  ForEach(viewModel.verifableCredentialsByMonth[key] ?? [], id: \.id) { credential in
                    CredentialCard(credential: credential)
                      .onTapGesture {
                        selectedCredential = credential
                      }
                  }
                }
                .padding(.horizontal)
                Spacer()
              }
            }
          }
        }
      }.padding(.horizontal, 50)
    }
  }

}

// MARK: - SeparatorView

struct SeparatorView: View {
  var body: some View {
    Rectangle()
      .frame(width: 1, height: 300)
      .foregroundColor(.gray)
      .padding(.top, 10)
  }
}

extension String {
  fileprivate func convertDateForHeader() -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM"

    if let date = inputFormatter.date(from: self) {
      let outputFormatter = DateFormatter()
      outputFormatter.dateFormat = "yyyy MMMM"

      let formattedDateString = outputFormatter.string(from: date)
      return formattedDateString
    } else {
      return "Invalid date"
    }
  }
}

#Preview {
  ContentView(
    viewModel: ContentViewModel(verifableCredentialsByMonth: [
      "2024-02": [Credential.sample(), Credential.sample(), Credential.sample(), Credential.sample()],
      "2024-03": [Credential.sample()],
    ]))
}
