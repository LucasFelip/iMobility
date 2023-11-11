import SwiftUI

struct ButtonColorido: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 97, height: 43)
                  .background(
                    LinearGradient(
                      stops: [
                        Gradient.Stop(color: Color(red: 0.25, green: 0.55, blue: 1), location: 0.00),
                        Gradient.Stop(color: Color(red: 0.7, green: 0.23, blue: 0.86), location: 1.00),
                      ],
                      startPoint: UnitPoint(x: 0.96, y: 1),
                      endPoint: UnitPoint(x: -0.05, y: -0.21)
                    )
                  )
                  .cornerRadius(25)
                Text(title)
                  .font(Font.custom("Montserrat", size: 16))
                  .foregroundColor(.white)
                  .frame(alignment: .center)
            }
            .padding(.top, 50)
        }
    }
}

struct ButtonRetangularSimple: View {
    let buttonText: String
    let action: () -> Void
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 220, height: 60)
                .background(
                    LinearGradient(
                        gradient: Gradient(
                            stops: [
                                Gradient.Stop(color: Color(red: 0.64, green: 0.28, blue: 0.88), location: 0.0),
                                Gradient.Stop(color: Color(red: 0.36, green: 0.47, blue: 0.96), location: 1.0)
                            ]
                        ),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(15)

            HStack {
                Text(buttonText)
                    .font(Font.custom("Montserrat-Regular", size: 22))
                    .foregroundColor(.black)
            }
            .padding(.horizontal, 40)
        }
        .padding(.top, 10)
        .onTapGesture {
            action()
        }
    }
}

struct ButtonRetangular: View {
    let buttonText: String
    let action: () -> Void
    @Binding var isCheckmarkVisible: Bool
    @State private var isBaseColor = true

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 330, height: 70)
                .background(Color(red: 0.87, green: 0.87, blue: 0.87))
                .cornerRadius(15)

            HStack {
                Text(buttonText)
                    .font(Font.custom("Montserrat-Regular", size: 36))
                    .foregroundColor(.black)
                    .padding(.leading, 5)
                    .padding(.trailing, 30)

                Spacer()

                ZStack {
                    if isBaseColor {
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 40, height: 40)
                    } else {
                        Circle()
                            .fill(
                                LinearGradient(
                                    stops: [
                                        Gradient.Stop(color: Color(red: 0.64, green: 0.28, blue: 0.88), location: isCheckmarkVisible ? 0.0 : 1.0),
                                        Gradient.Stop(color: Color(red: 0.36, green: 0.47, blue: 0.96), location: isCheckmarkVisible ? 1.0 : 0.0),
                                    ],
                                    startPoint: UnitPoint(x: 0.5, y: 0),
                                    endPoint: UnitPoint(x: 0.5, y: 1)
                                )
                            )
                            .frame(width: 40, height: 40)
                    }

                    if isCheckmarkVisible {
                        Image(systemName: "checkmark")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                    }
                }
                .padding(.trailing, 5)
            }
            .padding(.horizontal, 40)
        }
        .padding(.top, 10)
        .onTapGesture {
            action()
            withAnimation {
                isBaseColor = false
            }
        }
    }
}

struct RegisterAppButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack(alignment: .center) {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 325, height: 53)
                    .background(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: Color(red: 0.25, green: 0.55, blue: 1), location: 0.00),
                                Gradient.Stop(color: Color(red: 0.7, green: 0.23, blue: 0.86), location: 1.00),
                            ],
                            startPoint: UnitPoint(x: 0.96, y: 1),
                            endPoint: UnitPoint(x: -0.05, y: -0.21)
                        )
                    )
                    .cornerRadius(25)
                Text("Se cadastre")
                    .font(Font.custom("Montserrat", size: 18))
                    .foregroundColor(.white)
            }
            .padding(.bottom, 10)
        }
    }
}

struct TypeLoginGoogleButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack(alignment: .center) {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 325, height: 53)
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(.purple, lineWidth: 1)
                    )
                HStack {
                    Text("Continue com Google")
                        .font(Font.custom("Montserrat", size: 18))
                        .foregroundColor(.primary)
                    Image("google_icon")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
            }
            .padding(.bottom, 10)
        }
    }
}

struct TypeLoginAppleButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack(alignment: .center) {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 325, height: 53)
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(.purple, lineWidth: 1)
                    )
                HStack {
                    Text("Continue com Apple")
                        .font(Font.custom("Montserrat", size: 18))
                        .foregroundColor(.primary)
                    Image(systemName: "apple.logo")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(.black, .background)
                }
            }
            .padding(.bottom, 10)
        }
    }
}

struct TypeLoginAppButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text("Faça o login")
                    .font(Font.custom("Montserrat", size: 18))
                    .frame(alignment: .center)
                    .foregroundColor(.primary)
            }
            .padding(.bottom, 10)
        }
    }
}

struct TypeLoginBackButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("Voltar")
                .font(Font.custom("Montserrat", size: 18))
                .frame(alignment: .center)
                .foregroundColor(.primary)
        }
    }
}
