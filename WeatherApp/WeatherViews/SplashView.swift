//
//  SplashView.swift
//  WeatherApp
//
//  Created by Robert-Dumitru Oprea on 09/04/2023.
//

import SwiftUI

struct SplashView: View {
    @State private var rotation: Double = 0.0
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack(alignment: .center) {
                Text("Weather App")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .bold()
                Spacer()
                Image("splashIcon2")
                    .resizable()
                    .frame(width: 150.0, height: 150.0)
                    .cornerRadius(/*@START_MENU_TOKEN@*/40.0/*@END_MENU_TOKEN@*/)
                    .rotationEffect(Angle(degrees: rotation))
                    .onAppear {
                        withAnimation(.linear(duration: 2).repeatForever(autoreverses: false).speed(0.5)) {
                        rotation = 360
                    }
                }
                Spacer()
                Text("Made by Robert-Dumitru Oprea, w1772162")
                    .foregroundColor(.orange)
                    .font(.footnote)
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
