//
//  ContentView.swift
//  RememberMe
//
//  Created by Nikita Kolomoec on 21.05.2023.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        Group {
            if viewModel.isUnlocked {
                NavigationView {
                    List {
                        ForEach(viewModel.people) { person in
                            Button {
                                viewModel.selectedPerson = person
                            } label: {
                                PersonRow(person: person)
                            }
                            .tint(.black)
                        }
                        .onDelete { indexSet in
                            viewModel.deletePerson(at: indexSet)
                        }
                    }
                    .navigationTitle("Remember Me")
                    .toolbar {
                        Button {
                            viewModel.newPersonSheetShowing = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                    .sheet(item: $viewModel.selectedPerson) { selectedPerson in
                        PersonSheet(person: selectedPerson) { newPerson in
                            viewModel.updatePerson(newPerson: newPerson)
                        }
                    }
                    .fullScreenCover(isPresented: $viewModel.newPersonSheetShowing) {
                        PersonSheet { person in
                            viewModel.createNewPerson(newPerson: person)
                        }
                    }
                    .alert("Authentication Error!",isPresented: $viewModel.failedUnlock) {
                        
                    } message: {
                        Text(viewModel.failedAuthMsg)
                    }
                }
            } else {
                Button {
                    viewModel.authenticate()
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: 130, height: 130)
                            .foregroundColor(.blue)
                            .opacity(0.9)
                        Circle()
                            .stroke(.blue, lineWidth: 2)
                            .frame(width: 130, height: 130)
                            .opacity(2 - viewModel.animationAmount)
                            .scaleEffect(viewModel.animationAmount)
                            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: false), value: viewModel.animationAmount)
                        Text("Unlock People")
                            .foregroundColor(.white)
                            .bold()
                    }
                }
            }
        }
        .onAppear {
            viewModel.animationAmount = 2
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
