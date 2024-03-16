import Foundation
import Papyrus

// MARK: - Issuer

@API
@Authorization(.basic(username: "primary", password: "yI0LPJwOF5HqwHC3LnICdX5b6sqXIw2RppFNkWa2l1NuiAfAVMb9IeH6iPIC5o3F"))
@Headers([
  "Content-Type": "application/json",
])
protocol Issuer {

  @JSON(decoder: .iso8601)
  @GET("/medical")
  func getCredentials() async throws -> [Credential]

  @JSON(decoder: .standard)
  @GET("/insurance")
  func getInsurance() async throws -> InsuranceCredential

}

// MARK: - Verifier

@API
@Headers([
  "Content-Type": "application/json",
])
protocol Verifier {

  @JSON(encoder: .presentationEncoder)
  @POST("/present")
  func sendCredentials(_ credentials: Body<[Credential]>) async throws

  @JSON(decoder: .presentationDecoder)
  @GET("/doctorRequest")
  func doctorRequest() async throws -> PresentationRequest

  @JSON(decoder: .presentationDecoder)
  @GET("/pharmacyRequest")
  func pharmacyRequest() async throws -> PresentationRequest

}

extension JSONDecoder {
  static var iso8601: JSONDecoder {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return decoder
  }

  static var presentationDecoder: JSONDecoder {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return decoder
  }

  static var standard: JSONDecoder {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-mm-dd"

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(dateFormatter)
    return decoder
  }
}

extension JSONEncoder {
  static var presentationEncoder: JSONEncoder {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    return encoder
  }

}
