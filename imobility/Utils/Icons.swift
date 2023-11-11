import SwiftUI

struct Home: View {
    var body: some View {
        VStack {
            Image(systemName: "house")
                .font(.title)
                .foregroundStyle(.black)
            Text("Início")
              .font(
                Font.custom("Montserrat", size: 16)
                  .weight(.medium)
              )
              .multilineTextAlignment(.center)
              .foregroundColor(.black)
              .frame(height: 17, alignment: .center)
        }
    }
}

struct Rank: View {
    var body: some View {
        VStack{
            Image(systemName: "chart.bar")
                .font(.title)
                .foregroundStyle(.black)
            Text("Rank")
              .font(
                Font.custom("Montserrat", size: 16)
                  .weight(.medium)
              )
              .multilineTextAlignment(.center)
              .foregroundColor(.black)
              .frame(alignment: .center)
        }
    }
}

struct Account: View {
    var body: some View {
        VStack{
            Image(systemName: "person")
                .font(.title)
                .foregroundStyle(.black)
            Text("Conta")
              .font(
                Font.custom("Montserrat", size: 16)
                  .weight(.medium)
              )
              .multilineTextAlignment(.center)
              .foregroundColor(.black)
              .frame(height: 17, alignment: .center)
        }
    }
}

struct Report: View {
    var body: some View {
        VStack{
            Image(systemName: "doc")
                .font(.title)
                .foregroundStyle(.black)
            Text("Reportar")
              .font(
                Font.custom("Montserrat", size: 16)
                  .weight(.medium)
              )
              .multilineTextAlignment(.center)
              .foregroundColor(.black)
              .frame(height: 17, alignment: .center)
        }
    }
}

struct UserAccount: View {
    var body: some View {
        VStack{
            Image(systemName: "person")
                .font(.title)
                .foregroundStyle(.black)
            Text("Perfil")
              .font(
                Font.custom("Montserrat", size: 16)
                  .weight(.medium)
              )
              .multilineTextAlignment(.center)
              .foregroundColor(.black)
              .frame(height: 17, alignment: .center)
        }
    }
}

struct DeleteDatabase: View {
    var body: some View {
        VStack{
            Image(systemName: "x.circle.fill")
                .font(.title)
                .foregroundStyle(.black)
            Text("Delete")
              .font(
                Font.custom("Montserrat", size: 16)
                  .weight(.medium)
              )
              .multilineTextAlignment(.center)
              .foregroundColor(.black)
              .frame(height: 17, alignment: .center)
        }
    }
}

struct MapPinMaker: View {
    var body: some View {
        VStack {
            Image(systemName: "mappin")
                .font(.title)
                .foregroundStyle(.purple)
                .frame(width: 18, height: 18)
        }
    }
}

struct AnimatedGradientLoadingView: View {
    @State private var gradientLocation: Double = 0.0

    var body: some View {
        VStack {
            LinearGradient(gradient: Gradient(stops: [
                Gradient.Stop(color: Color(red: 0.64, green: 0.28, blue: 0.88), location: gradientLocation),
                Gradient.Stop(color: Color(red: 0.36, green: 0.47, blue: 0.96), location: 1.0)
            ]), startPoint: .leading, endPoint: .trailing)
            .frame(height: 10)
            .mask(
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 300, height: 10)
                    .overlay(GeometryReader { geo in
                        Color.clear.onAppear {
                            withAnimation(Animation.linear(duration: 0.2).repeatForever(autoreverses: false)) {
                                self.gradientLocation = 0.3
                            }
                        }
                    })
            )
        }
    }
}
