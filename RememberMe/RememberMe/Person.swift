//
//  Model.swift
//  RememberMe
//
//  Created by Nikita Kolomoec on 21.05.2023.
//

import SwiftUI

struct Person: Codable, Identifiable, Equatable, Comparable {
    var id = UUID()
    var name: String
    var desctiption: String
    var imageData: Data?
    var longitude: Double?
    var latitude: Double?
    
    var unWrappedUIImage: UIImage {
        guard let imageData = imageData else {
            return UIImage(systemName: "person.fill.questionmark")!
        }
        return UIImage(data: imageData)!
    }
    
    static let example = Person(name: "Nikita Kolomoiets", desctiption: "CEO of Apple", imageData: UIImage(named: "Example")!.jpegData(compressionQuality: 0.8)!, longitude: 30.523333, latitude: 50.450001)
    
    static func ==(lhs: Person, rhs: Person) -> Bool {
        lhs.id == rhs.id
    }
    
    static func <(lhs: Person, rhs: Person) -> Bool {
        lhs.name < rhs.name
    }
}
