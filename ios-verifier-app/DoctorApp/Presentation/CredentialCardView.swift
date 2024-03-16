import Foundation
import SwiftUI

struct CredentialCard: View {

  // MARK: Lifecycle

  init(credential: Credential) {
    self.credential = credential
  }

  // MARK: Public

  public enum Defaults {

    static let characterSpacing: CGFloat = -0.5

    static let imageSize: CGFloat = 28
    static let cornerRadius: CGFloat = 6
    static let shadowColor: Color = .black.opacity(0.25)
    static let shadowRadius: CGFloat = 8
    static let shadowX: CGFloat = 0
    static let shadowY: CGFloat = 4

    static let gradientMaskStartPoint: UnitPoint = .top
    static let gradientMaskEndPoint: UnitPoint = .bottom

  }

  // MARK: Internal

  var body: some View {
    ZStack(alignment: .bottom) {
      VStack {
        HStack {
          credential.type.image
            .resizable()
            .frame(width: 24, height: 24)
            .foregroundStyle(credential.type.backgroundColor)
          Text(credential.type.displayName)
            .font(.headline)
            .lineLimit(1)

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

      HStack {
        VStack(alignment: .leading) {
          Spacer()
          VStack(alignment: .leading, spacing: -3) {
            Text(credential.displayName)
              .font(.caption)
              .bold()
              .padding(.bottom, 8)
            Text(credential.displayCode)
              .font(.caption2)
          }
          Spacer()
        }
        Spacer()
      }
      .padding(.top, 55)
      .padding()
    }
    .foregroundColor(.primary)
    .background(Color(uiColor: .tertiarySystemGroupedBackground))
    .clipShape(.rect(cornerSize: .init(width: 10, height: 10), style: .continuous))
    .frame(width: 300, height: 150)
  }

  // MARK: Private

  private var credential: Credential

}

#Preview {
  CredentialCard(credential: Credential.sample())
}
