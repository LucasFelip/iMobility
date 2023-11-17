import SwiftUI
import MapKit

struct LocationSelectionView: View {
    @EnvironmentObject private var locationManager: LocationManager
    
    @State private var isShowingInitView = false
    @State private var isShowingButtonBack = true
    
    @State private var isConfirmButtonVisible = false
    @State var longPressLocation = CGPoint.zero
    
    @Binding var selectLocation: MapLocation
    @Binding var isConfirmLocation: Bool
    @Binding var insertLocal: Bool
    
    @State private var mapRegion: MKCoordinateRegion = .init(.null)
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .frame(width: geometry.size.width, height: 30)
                    .foregroundColor(Color.gray.opacity(0.5))
                Text("Clique aqui para cancelar")
                    .font(.caption)
                    .foregroundColor(.white)
                    .bold()
            }
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
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onEnded { _ in
                        isConfirmButtonVisible = false
                        isConfirmLocation = false
                        insertLocal = false
                    }
            )
        }
        .frame(height: 20)
        GeometryReader { proxy in
            Map(coordinateRegion: $mapRegion,
                showsUserLocation: true,
                annotationItems: [selectLocation],
                annotationContent: { location in
                MapMarker(coordinate: location.coordinate, tint: .purple)
            })
            .onReceive(locationManager.$region, perform: { region in
                self.mapRegion = region
            })
            .accentColor(.purple)
            .edgesIgnoringSafeArea(.all)
            .gesture(LongPressGesture(
                minimumDuration: 0.15)
                .sequenced(before: DragGesture(
                    minimumDistance: 0,
                    coordinateSpace: .local))
                    .onEnded { value in
                        switch value {
                        case .second(true, let drag):
                            longPressLocation = drag?.location ?? .zero
                            selectLocation = convertTap(
                                at: longPressLocation,
                                for: proxy.size)
                            isConfirmButtonVisible = true
                        default:
                            break
                        }
                    })
            .highPriorityGesture(DragGesture(minimumDistance: 10))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(
            VStack {
                Spacer()
                if isConfirmButtonVisible {
                    ButtonRetangularSimple(buttonText: "Confirmar") {
                        isConfirmButtonVisible = false
                        isConfirmLocation = false
                        insertLocal = true
                    }
                }
            }
        )
        
    }
    
    func convertTap(at point: CGPoint, for mapSize: CGSize) -> MapLocation {
        let mapCenter = CGPoint(x: mapSize.width/2, y: mapSize.height/2)
        let xValue = (point.x - mapCenter.x) / mapCenter.x
        let yValue = (point.y - mapCenter.y) / mapCenter.y
        
        let xSpan = xValue * mapRegion.span.longitudeDelta/2
        let ySpan = yValue * mapRegion.span.latitudeDelta/2
        
        return MapLocation(latitude: mapRegion.center.latitude - ySpan, longitude: mapRegion.center.longitude + xSpan)
    }
}
