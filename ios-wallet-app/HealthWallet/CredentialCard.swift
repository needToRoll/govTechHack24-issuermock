import Foundation
import SwiftUI

// MARK: - CredentialCard

struct CredentialCard: View {

  // MARK: Lifecycle

  init(credential: Credential) {
    self.credential = credential
  }

  // MARK: Internal

  var body: some View {
    ZStack(alignment: .bottom) {
      VStack {
        HStack {
          if let type = CredentialType(rawValue: credential.type) {
            type.image
              .resizable()
              .frame(width: 24, height: 24)
              .foregroundStyle(type.backgroundColor)
            Text(type.displayName)
              .font(.headline)
              .lineLimit(1)
          }

          Spacer()
          Image(systemName: "shield.lefthalf.filled.badge.checkmark")
            .renderingMode(.original)
            .foregroundColor(.primary)
        }
        .padding()

        Divider()
          .padding(.leading)
          .padding(.top, -8)

        Spacer()
      }

      VStack(alignment: .leading) {
        switch CredentialType(rawValue: credential.type) {
        case .allergy:
          HStack(alignment: .center) {
            if let severity = credential.content["severity"], let intSeverity = Int(severity) {
              Image(systemName: "gauge.with.dots.needle.50percent")
            }

            if let allergyDescription = credential.content["allergyDescription"] {
              Text(allergyDescription)
                .font(.caption)
                .bold()
            }
          }
        case .diagnosis:
          VStack(alignment: .leading, spacing: -3) {
            if let description = credential.content["diagnosisDescription"] {
              Text(description)
                .font(.caption)
                .bold()
            }

            if let code = credential.content["diagnosisCode"] {
              Text(code)
                .font(.caption2)
            }
          }
        case .medication:
          VStack(alignment: .leading, spacing: -3) {
            if let name = credential.content["medicationName"] {
              Text(name)
                .font(.caption)
                .bold()
            }

            if let instruction = credential.content["dosageInstruction"] {
              Text(instruction)
                .font(.caption2)
            }
          }
        default:
          EmptyView()
        }

        Spacer()
        HStack {
          Text(credential.id.uuidString)
            .lineLimit(1)
            .font(.caption2)
            .foregroundColor(.primary.opacity(0.5))
          Spacer()
          Text(credential.issuedAt.formatted(date: .numeric, time: .shortened))
            .font(.caption2)
        }
        .font(.subheadline)
      }
      .padding(.top, 55)
      .padding()
    }
    .foregroundColor(.primary)
    .frame(maxWidth: .infinity, minHeight: 150)
    .background(Color(uiColor: .tertiarySystemGroupedBackground))
    .clipShape(.rect(cornerSize: .init(width: 10, height: 10), style: .continuous))
  }

  // MARK: Private

  private var credential: Credential

}

// MARK: - InsuranceCard

struct InsuranceCard: View {

  // MARK: Lifecycle

  init(credential: InsuranceCredential) {
    self.credential = credential
  }

  // MARK: Internal

  @State var start = UnitPoint(x: 0, y: -2)
  @State var end = UnitPoint(x: 4, y: 0)

  let colors = [Color(#colorLiteral(red: 0.7244006991, green: 0.1691389382, blue: 0.152652204, alpha: 1)), Color(#colorLiteral(red: 0.0968445614, green: 0.3940534592, blue: 0.7540450692, alpha: 1)), Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))]
  let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()

  @State var isHelpPresented = false

  var body: some View {
    background
      .mask(RoundedRectangle(cornerRadius: 16))
      .frame(maxWidth: .infinity, minHeight: 225)
      .overlay {
        VStack(alignment: .leading) {
          HStack {
            Image(systemName: "checkmark.shield.fill")
            Text(credential.insuranceCompany)
              .font(.headline)
              .lineLimit(1)

            Spacer()

            Text(credential.cardNumber)
              .font(.caption.bold())
          }

          Spacer()

          HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: -2) {
              Text(credential.holderName)
                .font(.title2)
              Text(credential.dateOfBirth.formatted(date: .numeric, time: .omitted))
                .font(.caption)
              Text(credential.gender)
                .font(.caption)
            }

            Spacer()

            Menu {
              Button(role: .destructive) {
              } label: {
                Label("Delete", systemImage: "trash")
              }
            } label: {
              Image(systemName: "ellipsis.circle")
                .opacity(0.7)
            }
          }
        }
        .padding()
      }
      .foregroundStyle(.white)
  }

  var background: some View {
    LinearGradient(gradient: Gradient(colors: colors), startPoint: start, endPoint: end).edgesIgnoringSafeArea(.all)
  }

  // MARK: Private

  private var credential: InsuranceCredential

}

#Preview {
  InsuranceCard(credential: .init(cardNumber: "756.6420.4864.57", holderName: "Bryan Reymonenq", dateOfBirth: .parse("1990-12-03"), gender: "Male", insuranceCompany: "CSS"))
}
