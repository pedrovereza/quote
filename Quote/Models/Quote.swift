//
//  Quote.swift
//  Quote
//
//  Created by Pedro Vereza on 24/02/19.
//  Copyright © 2019 Pedro Vereza. All rights reserved.
//

import Foundation

struct Quote : Decodable {
    let message: String
    let author: String

    private enum CodingKeys : String, CodingKey {
        case message = "quoteText"
        case author = "quoteAuthor"
    }
}
