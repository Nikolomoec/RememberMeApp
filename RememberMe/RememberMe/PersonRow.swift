//
//  PersonRow.swift
//  RememberMe
//
//  Created by Nikita Kolomoec on 21.05.2023.
//

import SwiftUI

struct PersonRow: View {
    let person: Person
    
    var body: some View {
        HStack {
            if person.imageData != nil {
                Image(uiImage: person.unWrappedUIImage)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.fill.questionmark")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .padding(10)
                    .accessibilityLabel("Image for user is not provided")
            }
            VStack(alignment: .leading) {
                Text(person.name)
                    .font(.title3.bold())
                if !person.desctiption.isEmpty {
                    Text(person.desctiption)
                        .font(.callout)
                }
            }
            Spacer()
        }
    }
}

struct PersonRow_Previews: PreviewProvider {
    static var previews: some View {
        PersonRow(person: Person.example)
    }
}
