//
//  ModelType.swift
//  Hassad
//
//  Created by gyda almohaimeed on 27/07/1444 AH.
//

import Foundation



enum ModalType: Identifiable {
    var id: String {
        switch self {
        case .add: return "add"
        case .update: return "update"
        }
    }
    
case add
case update(Product)
    
}
