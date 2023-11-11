import SwiftUI
import MapKit

struct LocationSelectionView: View {
    @ObservedObject private var locationManager = LocationManager()
    
    @State private var isConfirmButtonVisible = false
    @State var longPressLocation = CGPoint.zero
    
    @Binding var selectLocation: MapLocation
    @Binding var isConfirmLocation: Bool
    
    var body: some View {
        GeometryReader { proxy in
            Map(coordinateRegion: $locationManager.region,
                showsUserLocation: true,
                annotationItems: [selectLocation],
                annotationContent: { location in
                MapMarker(coordinate: location.coordinate, tint: .purple)
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
                    }
                }
            }
        )
    }
    
    func convertTap(at point: CGPoint, for mapSize: CGSize) -> MapLocation {
        let lat = locationManager.region.center.latitude
        let lon = locationManager.region.center.longitude
            
        let mapCenter = CGPoint(x: mapSize.width/2, y: mapSize.height/2)
            
        let xValue = (point.x - mapCenter.x) / mapCenter.x
        let xSpan = xValue * locationManager.region.span.longitudeDelta/2
            
        let yValue = (point.y - mapCenter.y) / mapCenter.y
        let ySpan = yValue * locationManager.region.span.latitudeDelta/2
            
        return MapLocation(latitude: lat - ySpan, longitude: lon + xSpan)
    }
}
