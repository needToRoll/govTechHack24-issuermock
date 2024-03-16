import SwiftUI

// MARK: - CredentialDetailView

struct CredentialDetailView: View {

  // MARK: Lifecycle

  init(credential: Credential) {
    self.credential = credential
  }

  // MARK: Internal

  var body: some View {
    content()
  }

  // MARK: Private

  private var credential: Credential

  private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter
  }()

  @ViewBuilder
  private func content() -> some View {
    VStack(alignment: .leading, spacing: 20) {
      header().padding(EdgeInsets(top: 40, leading: 20, bottom: 20, trailing: 20))
      divider()
      credentialValues().padding(.leading, 20)
      credentialContentValues().padding(.leading, 20)
      Spacer()
    }
    .background(Color(uiColor: .tertiarySystemGroupedBackground))
  }

  @ViewBuilder
  private func divider() -> some View {
    Divider()
      .padding(EdgeInsets(top: -8, leading: 16, bottom: 16, trailing: 0))
  }

  @ViewBuilder
  private func header() -> some View {
    HStack {
      credential.type.image
        .font(.system(size: 30))
        .foregroundStyle(credential.type.backgroundColor)
      Text(credential.type.displayName)
        .font(.title)
        .lineLimit(1)
      Spacer()
      Image(systemName: "shield.lefthalf.filled.badge.checkmark")
        .renderingMode(.original)
        .font(.system(size: 30))
        .foregroundColor(.primary)
    }
  }

  @ViewBuilder
  private func credentialValues() -> some View {
    HStack {
      Text("Issued At:")
        .fontWeight(.bold)
      Text("\(credential.issuedAt, formatter: itemFormatter)")
    }
  }

  @ViewBuilder
  private func credentialContentValues() -> some View {
    ForEach(credential.content.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
      HStack {
        Text("\(key.keyFormatted):")
          .fontWeight(.bold)
        Text(value)
      }
    }
  }

}

// MARK: - CredentialDetailView_Previews

struct CredentialDetailView_Previews: PreviewProvider {
  static var previews: some View {
    // Use a sample credential for preview
    CredentialDetailView(credential: Credential(id: UUID(), name: "Sample Credential", type: .insurance))
  }
}

extension String {
  fileprivate var keyFormatted: String {
    let mapping: [String: String] = [
      "allergyDescription": "Allergy Description",
      "allergyCode": "Allergy code",
      "reactionCode": "Allergy reaction code",
      "severity": "Allergy severity",
      "medicationName": "Medication name",
      "medicationCode": "Medication code",
      "dosageInstruction": "Dosage instruction",
      "diagnosisDescription": "Diagnosis Description",
      "diagnosisCode": "Diagnosis code",
    ]
    return mapping[self] ?? self
  }
}
