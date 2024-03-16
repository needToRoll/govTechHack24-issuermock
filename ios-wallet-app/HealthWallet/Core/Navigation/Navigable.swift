import Foundation
import SwiftUI

// MARK: - Navigable

protocol Navigable: ObservableObject {
  typealias Route = NavigationPath

  var path: Route { get set }

  func push(_ route: any Hashable)
  func pop()
  func root()
}

extension Navigable {
  func push(_ route: any Hashable) {
    path.append(route)
  }

  func root() {
    path = .init()
  }

  func pop() {
    path.removeLast()
  }
}

// MARK: - Routable

protocol Routable: Hashable {
  associatedtype Content: View
  static func destination(_ route: Self) -> Content
}
