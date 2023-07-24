//
//  ProfilePictureDocument.swift
//  Gardner
//
//  Created by Rashid Khan on 22/07/2023.
//

import Foundation

struct ProfilePictureDocument: DocumentDataConvertible {
    var data: Data
    var name: String
    var fileName: String
    var mimeType: String
}
