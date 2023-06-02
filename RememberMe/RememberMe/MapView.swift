//
//  MapView.swift
//  RememberMe
//
//  Created by Nikita Kolomoec on 22.05.2023.
//

import SwiftUI
import MapKit

struct MapView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel: PersonViewModel
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                Map(coordinateRegion: $viewModel.mapRegion, annotationItems: [viewModel.person]) { item in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: viewModel.mapAnnotationLatitude, longitude: viewModel.mapAnnotationLongitude)) {
                        VStack {
                            if let image = viewModel.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: geo.size.width / 7, height: geo.size.height / 16)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "person.fill.questionmark")
                                    .resizable()
                                    .frame(width: geo.size.width / 8, height: geo.size.height / 17)
                            }
                            Text(viewModel.isNameEmpty ? "New Person" : viewModel.name)
                                .bold()
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(.white.opacity(0.5))
                                        .shadow(radius: 5)
                                )
                        }
                    }
                }
            }
            .ignoresSafeArea()
            .navigationTitle("Person Location")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close", role: .cancel) {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                    .bold()
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Edit", role: .destructive) {
                        viewModel.showingMapEditAlert = true
                    }
                    .foregroundColor(.blue)
                    .bold()
                }
            }
            .alert("Are you sure?", isPresented: $viewModel.showingMapEditAlert) {
                Button("Cancel", role: .cancel) { }
                Button("OK", role: .destructive) { viewModel.locationEdit() }
            } message: {
                Text("If you press 'OK', last person location will be overwritten with current one.")
            }
            .onAppear { viewModel.configMap() }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(viewModel: PersonViewModel(person: Person.example))
    }
}
