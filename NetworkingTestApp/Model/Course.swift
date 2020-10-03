//
//  File.swift
//  NetworkingTestApp
//
//  Created by Admin on 21.09.2020.
//

import Foundation


struct Course: Codable {
    var id: Int
    var name: String
    var link: String
    var imageUrl: String
    var numberOfLessons: Int
    var numberOfTests: Int
    
    var imageData: Data?
}


//"id": 1,
//"name": "Our first iOS apps",
//"link": "https://swiftbook.ru/contents/our-first-applications/",
//"imageUrl": "https://swiftbook.ru/wp-content/uploads/2018/03/2-courselogo.jpg",
//"number_of_lessons": 20,
//"number_of_tests": 10
