//
//  LocationView.swift
//  RememberMe
//
//  Created by Nikita Kolomoec on 22.05.2023.
//

import SwiftUI

struct LocationView: View {
    let name: String
    
    var body: some View {
        ZStack {
            Image("earth")
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 13))
                .padding(40)
            Text(name)
                .foregroundColor(.white)
                .font(.title2.bold())
                .shadow(radius: 3)
                .padding(10)
                .background(
                    LinearGradient(colors: [.blue, .black, .blue], startPoint: .bottom, endPoint: .top)
                        .opacity(0.5)
                        .clipShape(RoundedRectangle(cornerRadius: 13))
                )
        }
        .shadow(radius: 5)
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(name: "Connect Location")
    }
}
