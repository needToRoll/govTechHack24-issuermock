import Foundation

extension Date {

  static func randomBetween(start: String, end: String, format: String = "yyyy-MM-dd") -> String {
    let date1 = Date.parse(start, format: format)
    let date2 = Date.parse(end, format: format)
    return Date.randomBetween(start: date1, end: date2).dateString(format)
  }

  static func randomBetween(start: Date, end: Date) -> Date {
    let date1 = min(start, end)
    var date2 = max(start, end)

    if date1 == date2 {
      date2 = date1.addingTimeInterval(120)
    }

    let span = TimeInterval.random(in: date1.timeIntervalSinceNow...date2.timeIntervalSinceNow)
    return Date(timeIntervalSinceNow: span)
  }

  static func parse(_ string: String, format: String = "yyyy-MM-dd") -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = NSTimeZone.default
    dateFormatter.dateFormat = format

    let date = dateFormatter.date(from: string)!
    return date
  }

  func dateString(_ format: String = "yyyy-MM-dd") -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: self)
  }

}
