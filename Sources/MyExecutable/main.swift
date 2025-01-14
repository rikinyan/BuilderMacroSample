// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

var book = Book(
    id: "123"
)

book.setprice(value: 1200)

print(book.displayedPrice())
assert(book.displayedPrice() == "¥1,200")
