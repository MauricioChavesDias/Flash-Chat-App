//
//  Constants.swift
//  Flash Chat iOS13
//
//  Created by Mauricio Dias on 21/4/21.
//  Copyright © 2021 Angela Yu. All rights reserved.
//

import Foundation

struct K {
    // static - faz a property ser acessada como um type, sem precisar instanciar o objecto Constants.
    static let titleApp = "⚡️FlashChat"
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}
