//
//  Character.swift
//  Marvel
//
//  Created by Vasiliy Munenko on 22.03.2021.
//

import SwiftUI

struct APIResult : Codable {
    var data: APICharacterData
}

struct APICharacterData : Codable{
    var count :Int
    var results : [Character]
}

//Model
struct Character : Identifiable , Codable {
    var id : Int
    var name : String
    var description : String
    var thumbnail : [String:String]
    var urls : [[String:String]]
    
}
