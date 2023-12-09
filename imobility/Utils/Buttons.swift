import SwiftUI

struct ButtonColorido: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.height * 0.05)
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
                    .font(.system(size: UIScreen.main.bounds.width * 0.04))
                    .foregroundColor(.white)
            }
        }
        .padding(.top, 50)
    }
}

struct ButtonRetangularSimple: View {
    let buttonText: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
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
        }
    }
}

struct ButtonRectangular: View {
    let buttonText: String
    let action: () -> Void
    @Binding var isCheckmarkVisible: Bool

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, idealHeight: 70, maxHeight: 80, alignment: .center)
                .background(Color(red: 0.87, green: 0.87, blue: 0.87))
                .cornerRadius(15)

            HStack {
                Text(buttonText)
                    .font(.system(size: UIScreen.main.bounds.width * 0.08))
                    .foregroundColor(.black)
                    .padding(.leading, UIScreen.main.bounds.width * 0.02)
                    .padding(.trailing, UIScreen.main.bounds.width * 0.05)

                Spacer()

                ZStack {
                    Circle()
                        .fill(isCheckmarkVisible
                            ? LinearGradient(gradient: Gradient(colors: [Color(red: 0.64, green: 0.28, blue: 0.88), Color(red: 0.36, green: 0.47, blue: 0.96)]), startPoint: .top, endPoint: .bottom)
                            : LinearGradient(gradient: Gradient(colors: [Color.gray]), startPoint: .top, endPoint: .bottom))
                        .frame(width: min(UIScreen.main.bounds.width * 0.1, 60), height: min(UIScreen.main.bounds.width * 0.1, 60))
                    if isCheckmarkVisible {
                        Image(systemName: "checkmark")
                            .font(.system(size: UIScreen.main.bounds.width * 0.05))
                            .foregroundColor(.black)
                    }
                }
                .padding(.trailing, UIScreen.main.bounds.width * 0.02)
            }
            .padding(.horizontal, UIScreen.main.bounds.width * 0.05)
        }
        .onTapGesture {
            action()
            withAnimation {
                isCheckmarkVisible.toggle()
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
                    .frame(width: UIScreen.main.bounds.width * 0.85, height: UIScreen.main.bounds.height * 0.065)
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
                    .font(.system(size: UIScreen.main.bounds.width * 0.045))
                    .foregroundColor(.white)
            }
            .padding(.bottom, UIScreen.main.bounds.height * 0.01)
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
                    .frame(width: UIScreen.main.bounds.width * 0.85, height: UIScreen.main.bounds.height * 0.065)
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(.purple, lineWidth: 1)
                    )
                HStack {
                    Text("Continue com Google")
                        .font(.system(size: UIScreen.main.bounds.width * 0.045))
                        .foregroundColor(.primary)
                    Image("google_icon")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width * 0.06, height: UIScreen.main.bounds.width * 0.06)
                }
            }
            .padding(.bottom, UIScreen.main.bounds.height * 0.01)
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
                    .frame(width: UIScreen.main.bounds.width * 0.85, height: UIScreen.main.bounds.height * 0.065)
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(.purple, lineWidth: 1)
                    )
                HStack {
                    Text("Continue com Apple")
                        .font(.system(size: UIScreen.main.bounds.width * 0.045))
                        .foregroundColor(.primary)
                    Image("apple_icon")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width * 0.06, height: UIScreen.main.bounds.width * 0.07)
                }
            }
            .padding(.bottom, UIScreen.main.bounds.height * 0.01)
        }
    }
}

struct TypeLoginAppButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("Faça o login")
                .font(.system(size: UIScreen.main.bounds.width * 0.045))
                .foregroundColor(.primary)
        }
    }
}

struct TypeLoginBackButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("Voltar")
                .font(.system(size: UIScreen.main.bounds.width * 0.045))
                .foregroundColor(.primary)
        }
    }
}
