//: Playground - noun: a place where people can play

import Foundation

var str = "1,000.2"

let formatter = NumberFormatter()
formatter.numberStyle = .decimal
let thousandSeparator = Locale.current.groupingSeparator
str = str.replacingOccurrences(of: thousandSeparator!, with: "")
let number = formatter.number(from: str)

