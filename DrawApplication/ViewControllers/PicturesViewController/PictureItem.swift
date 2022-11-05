//
//  PictureItem.swift
//  DrawApplication
//
//  Created by Рамил Гаджиев on 05.11.2022.
//

import UIKit

struct PictureItem: Identifiable {
    let id: UUID
    var image: UIImage?
    var layout: Layout?
}
