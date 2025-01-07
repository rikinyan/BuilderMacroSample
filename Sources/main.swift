// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

let book = Book(
    id: "123",
    name: "clean architecture",
    authorName: "uncle bob",
    price: 1200,
    searchKeyWord: ["architecture", "programming", "IT"],
    image: URL(string: "https://bookimage.com/sample.png"),
    caption: "this is good book for all architects to learn the representive theories of architecture."
)

print(book.displayedPrice())
assert(book.displayedPrice() == "¥1,200")
