//
//  Book.swift
//  MyExecutable
//
//  Created by 力石優武 on 2025/01/06.
//

import Foundation

struct Book {
    let id: String?
    let name: String?
    let authorName: String?
    let price: Int?
    let searchKeyWord: [String]
    let image: URL?
    let caption: String?
    
    func displayedPrice() -> String {
        guard let price else { return "this is priceless..." }
        return price.formatted(.currency(code: "JPY"))
    }
}
