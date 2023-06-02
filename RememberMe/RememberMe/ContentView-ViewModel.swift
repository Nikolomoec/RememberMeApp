//
//  ContentView-ViewModel.swift
//  RememberMe
//
//  Created by Nikita Kolomoec on 21.05.2023.
//

import Foundation
import LocalAuthentication

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        
        @Published private(set) var people: [Person]
        
        @Published var newPersonSheetShowing = false
        
        @Published var selectedPerson: Person?
        
        @Published var isUnlocked = false
        
        @Published var failedAuthMsg = ""
        @Published var failedUnlock = false
        
        @Published var animationAmount = 1.0
        
        let strUrl = "peopleSave"
        
        init() {
            do {
                let data = try Data(contentsOf: FileManager.documentsDirectory.appendingPathComponent(strUrl))
                people = try JSONDecoder().decode([Person].self, from: data).sorted()
            } catch {
                people = []
            }
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(people)
                try data.write(to: FileManager.documentsDirectory.appendingPathComponent(strUrl))
                people.sort()
            } catch {
                print("Error saving the data: \(error.localizedDescription)")
            }
        }
        
        func updatePerson(newPerson: Person) {
            guard let selectedPerson = selectedPerson else { return }
            
            if let index = people.firstIndex(of: selectedPerson) {
                people[index] = newPerson
            }
            
            save()
        }
        
        func createNewPerson(newPerson: Person) {
            people.append(newPerson)
            save()
        }
        
        func deletePerson(at offsets: IndexSet) {
            people.remove(atOffsets: offsets)
            save()
        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your people."
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authError in
                    Task { @MainActor in
                        if success {
                            self.isUnlocked = true
                        } else {
                            self.failedAuthMsg = "There was a problem authenticating you, please try again"
                            self.failedUnlock = true
                        }
                    }
                }
            } else {
                failedAuthMsg = "Sorry your device does not support biometric authentication."
                failedUnlock = true
            }
        }
    }
}
