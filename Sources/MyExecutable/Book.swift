//
//  Book.swift
//  MyExecutable
//
//  Created by 力石優武 on 2025/01/06.
//

import Foundation
import BuilderMacro

@Builder
struct Book {
    var id: String
    var name: String?
    var authorName: String?
    var price: Int?
    var image: URL?
    var caption: String?
    
    func displayedPrice() -> String {
        guard let price else { return "this is priceless..." }
        return price.formatted(.currency(code: "JPY"))
    }
}
