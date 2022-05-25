//
//  File.swift
//  VendorHub
//
//  Created by Nana Bonsu on 4/27/22.
//

import Foundation
import Nuke


extension UIImageView {
    func setImage(_ imageUrl: String?) {
        if imageUrl == nil {
            return
        }
        if let url = URL(string: imageUrl!) {
            Nuke.loadImage(with: url, into: self)
        }
    }
}
