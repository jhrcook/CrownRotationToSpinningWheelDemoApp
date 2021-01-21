//
//  ContentView.swift
//  CrownRotationToSpinningWheelDemoApp
//
//  Created by Joshua on 1/21/21.
//

import SwiftUI

struct ContentView: View {
    @State private var sliderValue: Double = 0.0

    var body: some View {
        VStack {
            LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .leading, endPoint: .trailing)
                .clipShape(Circle())
                .padding(5)

            RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                .foregroundColor(.gray)
                .padding()

            HStack {
                Image(systemName: "minus")
                Slider(value: $sliderValue, in: 0 ... 1, step: 0.01).accentColor(.green)
                Image(systemName: "plus")
            }
            .foregroundColor(.green)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(lineWidth: 2.0)
                    .foregroundColor(.green)
            )
            .padding()

            Text("Damping: \(sliderValue, specifier: "%.2f")")
                .padding(.top, 0)
                .padding(.bottom)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
