//
//  ContentView.swift
//  CrownRotationToSpinningWheelDemoApp
//
//  Created by Joshua on 1/21/21.
//

import CrownRotationToSpinningWheel
import SwiftUI

struct ContentView: View {
    @State private var gestureValue: CGSize = .zero
    @State private var crownRotation: Double = 0.0
    @State private var damping: Double = 0.1

    @StateObject var spinningWheel = SpinningWheel(damping: 0.07, publishingFrequency: 0.1, crownVelocityMemory: 1.0)

    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        let drag = DragGesture()
            .onChanged { value in
                gestureValue = value.translation
                crownRotation = Double(value.translation.width)
                spinningWheel.crownInput(angle: crownRotation * 200, at: Date())
            }
            .onEnded { _ in
                self.gestureValue = .zero
            }

        return VStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .leading, endPoint: .trailing)
                    .clipShape(Circle())
                    .padding(5)
                    .onReceive(timer) { _ in
                        spinningWheel.update()
                    }
                    .rotationEffect(.degrees(Double(spinningWheel.wheelRotation)))
                    .animation(.interactiveSpring())

                HStack {
                    VStack {
                        Spacer()
                        Text("crown rotation: \(crownRotation, specifier: "%.2f")").font(.body).opacity(0.7)
                    }
                    Spacer()
                }
                .padding(.horizontal)
            }

            ZStack {
                RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                    .foregroundColor(.green)
                    .opacity(0.1)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25.0, style: .continuous).stroke(Color.green, lineWidth: 2)
                    )
                    .gesture(drag)

                VStack {
                    Spacer()
                    Text("x: \(gestureValue.width, specifier: "%.2f"), y: \(gestureValue.height, specifier: "%.2f")")
                        .font(.caption)
                        .padding(3)
                }
            }
            .padding(10)

            HStack {
                Image(systemName: "minus")
                Slider(value: $damping, in: 0 ... 1, step: 0.01).accentColor(.green)
                Image(systemName: "plus")
            }
            .foregroundColor(.green)
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(lineWidth: 2.0)
                    .foregroundColor(.green)
            )
            .padding()

            Text("Damping: \(damping, specifier: "%.2f")")
                .padding(.top, 0)
                .padding(.bottom, 8)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
