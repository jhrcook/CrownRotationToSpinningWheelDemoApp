//
//  ContentView.swift
//  CrownRotationToSpinningWheelDemoApp
//
//  Created by Joshua on 1/21/21.
//

import SwiftUI

struct ContentView: View {
    @State private var gestureValue: CGSize = .zero
    @State private var damping: Double = 0.0

    var body: some View {
        let drag = DragGesture()
            .onChanged { value in
                self.gestureValue = value.translation
            }
            .onEnded { _ in
                self.gestureValue = .zero
            }

        return VStack {
            LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .leading, endPoint: .trailing)
                .clipShape(Circle())
                .padding(5)
                .rotationEffect(.degrees(Double(gestureValue.width)))
                .animation(.interactiveSpring())

            ZStack {
                RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                    .foregroundColor(.gray)
                    .gesture(drag)

                VStack {
                    Spacer()
                    Text("x: \(gestureValue.width, specifier: "%.2f"), y: \(gestureValue.height, specifier: "%.2f")")
                        .font(.caption)
                        .padding(3)
                }
            }
            .padding()

            HStack {
                Image(systemName: "minus")
                Slider(value: $damping, in: 0 ... 1, step: 0.01).accentColor(.green)
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

            Text("Damping: \(damping, specifier: "%.2f")")
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
