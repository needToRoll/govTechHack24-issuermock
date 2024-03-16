import SwiftUI

struct HeaderView: View {

  // MARK: Internal

  var body: some View {
    content()
  }

  // MARK: Private

  @ViewBuilder
  private func content() -> some View {
    HStack(spacing: 20) {
      Image(systemName: "person.circle")
        .font(.system(size: 80, weight: .ultraLight))

      VStack(alignment: .leading) {
        Text("John Doe")
          .font(.title)
        HStack {
          Text("Insurance:").bold()
          Text("Helsana")
        }
        HStack {
          Text("Contract number:").bold()
          Text("A876111")
        }
      }

      VStack(alignment: .leading) {
        Text(" ")
          .font(.title)
        HStack {
          Text("Age:").bold()
          Text("43 yo")
        }
        HStack {
          Text("AVS/AHV:").bold()
          Text("756.1234.5678.97")
        }
      }

//      VStack(alignment: .leading) {
//        Text(" ")
//          .font(.title)
//        HStack {
//          Text("Adress:").bold()
//          Text("Schlossstrasse 12")
//        }
//        HStack {
//          Text("Locality:").bold()
//          Text("Bern")
//        }
//      }
      Spacer()
    }
  }
}

#Preview {
  VStack {
    HeaderView().padding(EdgeInsets(.init(top: 70, leading: 70, bottom: 0, trailing: 0)))
    Spacer()
  }
  .padding(0)
}
