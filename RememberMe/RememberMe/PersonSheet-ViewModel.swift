//
//  PersonSheet-ViewModel.swift
//  RememberMe
//
//  Created by Nikita Kolomoec on 21.05.2023.
//

import SwiftUI
import MapKit
import CoreLocation

@MainActor class PersonViewModel: ObservableObject {
    
    @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 100, longitude: 20), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    
    @Published var name: String
    @Published var description: String
    @Published var image: UIImage?
    
    @Published var showingAlert = false
    @Published var showingPhotoPicker = false
    
    @Published var showingMap = false
    
    @Published var latitude: Double?
    @Published var longitude: Double?
    
    @Published var showingMapEditAlert = false
    
    let locationFetcher = LocationFetcher()
    
    var isNameEmpty: Bool {
        name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    var isPersonNameEmpty: Bool {
        person.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var mapAnnotationLatitude: Double {
        latitude ?? locationFetcher.lastKnownLocation?.latitude ?? 0.0
    }
    var mapAnnotationLongitude: Double {
        longitude ?? locationFetcher.lastKnownLocation?.longitude ?? 0.0
    }
    
    var person: Person
    
    // Create new person
    init() {
        name = ""
        description = ""
        image = nil
        
        person = Person(name: "", desctiption: "", imageData: UIImage(systemName: "person.fill.questionmark")!.jpegData(compressionQuality: 0.8)!, longitude: nil, latitude: nil)
    }
    
    // Edit existing person
    init(person: Person) {
        self.person = person
        
        name = person.name
        description = person.desctiption
        if person.imageData != nil {
            self.image = person.unWrappedUIImage
        } else {
            self.image = nil
        }
        longitude = person.longitude
        latitude = person.latitude
        
        mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: person.latitude ?? 50, longitude: person.longitude ?? 30), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    }
    
    func createNewPerson() -> Person {
        var newPerson = person
        newPerson.id = UUID()
        newPerson.name = name
        newPerson.desctiption = description
        newPerson.latitude = latitude
        newPerson.longitude = longitude
        if let image = image {
            newPerson.imageData = image.jpegData(compressionQuality: 0.8)!
        } else {
            newPerson.imageData = nil
        }
        return newPerson
    }
    
    func showMap() {
        locationFetcher.start()
        showingMap = true
    }
    
    func configMap() {
        if let longitude = longitude, let latitude = latitude {
            mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        } else {
            latitude = locationFetcher.lastKnownLocation?.latitude
            longitude = locationFetcher.lastKnownLocation?.longitude
            
            mapRegion = MKCoordinateRegion(center: locationFetcher.lastKnownLocation ?? CLLocationCoordinate2D(), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        }
    }
    
    func locationEdit() {
        latitude = locationFetcher.lastKnownLocation?.latitude
        longitude = locationFetcher.lastKnownLocation?.longitude
        person = createNewPerson()
        mapRegion = MKCoordinateRegion(center: locationFetcher.lastKnownLocation ?? CLLocationCoordinate2D(), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    }
    
}
