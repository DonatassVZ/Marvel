//
//  Comic.swift
//  Marvel
//
//  Created by Vasiliy Munenko on 23.03.2021.
//


import SwiftUI

struct APIComicResult : Codable {
    var data: APIComicData
}

struct APIComicData : Codable{
    var count :Int
    var results : [Comic]
}

//Model
struct Comic : Identifiable , Codable {
    var id : Int
    var title : String
    var description : String?
    var thumbnail : [String:String]
    var urls : [[String:String]]
    
}
