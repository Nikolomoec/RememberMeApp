//
//  AddPerson.swift
//  RememberMe
//
//  Created by Nikita Kolomoec on 21.05.2023.
//

import SwiftUI
import MapKit

struct PersonSheet: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var viewModel: PersonViewModel
    var onSave: (Person) -> Void
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Button {
                        // Open users Photo libary
                        viewModel.showingPhotoPicker = true
                    } label: {
                        if let uiImage = viewModel.image {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(LinearGradient(colors: [.secondary.opacity(0.3), .yellow], startPoint: .topLeading, endPoint: .bottomTrailing))
                                )
                                .padding()
                        } else {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(LinearGradient(colors: [.secondary.opacity(0.3), .yellow], startPoint: .topLeading, endPoint: .bottomTrailing))
                                Text("Import a Photo")
                                    .foregroundColor(.primary)
                                    .font(.title.bold())
                            }
                            .padding()
                            .frame(height: 400)
                        }
                    }
                    
                    Group {
                        TextField("Name", text: $viewModel.name)
                            .padding(.bottom, 10)
                        TextField("Description (Optional)", text: $viewModel.description)
                    }
                    .textFieldStyle(CustomTextField())
                    .bold()
                    
                    Spacer()
                    
                    Button {
                        viewModel.showMap()
                    } label: {
                        LocationView(name: viewModel.longitude != nil && viewModel.latitude != nil ? "Last Location" : "Connect Current Location")
                    }
                }
                .navigationTitle(viewModel.isPersonNameEmpty ? "Add Person" : viewModel.person.name)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            if viewModel.isNameEmpty {
                                viewModel.showingAlert = true
                            } else {
                                onSave(viewModel.createNewPerson())
                                dismiss()
                            }
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel", role: .cancel) { dismiss() }
                    }
                }
                .alert("You can't save that!", isPresented: $viewModel.showingAlert) {
                    Button("OK") { }
                } message: {
                    Text("You need to provide a name for person.")
                }
                .sheet(isPresented: $viewModel.showingPhotoPicker) {
                    ImagePicker(image: $viewModel.image)
                }
                .sheet(isPresented: $viewModel.showingMap) {
                    MapView(viewModel: viewModel)
                }
            }
        }
    }
    
    // Init for existing person
    init(person: Person, onSave: @escaping (Person) -> Void) {
        _viewModel = StateObject(wrappedValue: PersonViewModel(person: person))
        self.onSave = onSave
    }
    
    // Init for new person
    init(onSave: @escaping (Person) -> Void) {
        _viewModel = StateObject(wrappedValue: PersonViewModel())
        self.onSave = onSave
    }
}

struct AddPerson_Previews: PreviewProvider {
    static var previews: some View {
        PersonSheet(person: Person.example) { _ in }
    }
}

struct CustomTextField: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal)
            .padding(.vertical, 15)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.secondary.opacity(0.2))
            )
            .padding(.horizontal)
    }
}
