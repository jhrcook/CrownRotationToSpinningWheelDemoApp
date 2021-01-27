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
    @State var damping: Double = 0.1

    @StateObject var spinningWheel = SpinningWheel(damping: 0.07, crownVelocityMemory: 2.0)

    @State var springStiffness: Double = 5.0
    @State var springDamping: Double = 5.0

    var body: some View {
        let drag = DragGesture()
            .onChanged { value in
                gestureValue = value.translation
                crownRotation = Double(value.translation.width)
                spinningWheel.crownInput(angle: crownRotation / 3, at: Date())
            }
            .onEnded { _ in
                self.gestureValue = .zero
            }

        return VStack {
            ZStack {
                GradientCircle()
                    //  .rotationEffect(.degrees(Double(gestureValue.width)))
                    .rotationEffect(.degrees(spinningWheel.wheelRotation))
                    .animation(.interpolatingSpring(stiffness: springStiffness, damping: springDamping))

                HStack {
                    VStack {
                        Text("crown rotation:\n\(crownRotation, specifier: "%.2f")").font(.footnote).opacity(0.7)
                        Spacer()
                    }
                    Spacer()
                }
                .padding(.horizontal)
            }

            ZStack {
                GreenRoundedRect()
                    .gesture(drag)

                VStack {
                    Spacer()
                    Text("x: \(gestureValue.width, specifier: "%.2f"), y: \(gestureValue.height, specifier: "%.2f")")
                        .font(.footnote)
                        .padding(3)
                }
            }
            .padding(10)

            HStack {
                Image(systemName: "minus")
                Slider(value: $damping, in: 0 ... 1, step: 0.01).accentColor(.green)
                Image(systemName: "plus")
            }
            .greenSliderOverlay()

            Text("Damping: \(damping, specifier: "%.2f")")
                .font(.footnote)
                .padding(.bottom, 5)

            VStack {
                Stepper(value: $springStiffness, in: 0 ... 10, step: 0.5, onEditingChanged: { _ in }) {
                    Text("Spring stiffness: \(springStiffness, specifier: "%.2f")")
                }.accentColor(.green)

                Stepper(value: $springDamping, in: 0 ... 10, step: 0.5, onEditingChanged: { _ in }) {
                    Text("Spring damping: \(springDamping, specifier: "%.2f")")
                }.accentColor(.green)
            }
            .greenSliderOverlay()
        }
    }
}

struct GradientCircle: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .leading, endPoint: .trailing)
            .clipShape(Circle())
            .padding(5)
    }
}

struct GreenRoundedRect: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10, style: .continuous)
            .foregroundColor(.green)
            .opacity(0.1)
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(Color.green, lineWidth: 2)
            )
    }
}

struct GreenSliderOverlay: ViewModifier {
    var insidePadding: CGFloat = 10
    var outsidePadding: CGFloat = 10

    func body(content: Content) -> some View {
        content
            .foregroundColor(.green)
            .padding(insidePadding)
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(lineWidth: 2.0)
                    .foregroundColor(.green)
            )
            .padding(.horizontal, outsidePadding)
            .padding(.top, outsidePadding / 2)
    }
}

extension View {
    func greenSliderOverlay() -> some View {
        modifier(GreenSliderOverlay())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
