// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

let book = Book(
    id: "123"
)

print(book.displayedPrice())
assert(book.displayedPrice() == "¥1,200")
