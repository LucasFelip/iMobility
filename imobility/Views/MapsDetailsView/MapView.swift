import SwiftUI
import MapKit

struct Mapa: View {
    @EnvironmentObject private var occurrenceManager: OccurrenceManager
    @EnvironmentObject private var userManager: UserManager
    @EnvironmentObject private var locationManager: LocationManager
    
    @State private var isShowingModal = false
    @State private var selectedOccurrence: Occurrence?
    @State private var mapRegion = MKCoordinateRegion(
        center: .init(latitude: 0, longitude: 0),
        span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $mapRegion,
                showsUserLocation: true,
                annotationItems: visibleOccurrences()) { occurrence in
                MapAnnotation(coordinate: occurrence.coordinate) {
                    MapPinMaker()
                        .onTapGesture(count: 1, perform: {
                            selectedOccurrence = occurrence
                            isShowingModal = true
                        })
                }
            }
            .onReceive(locationManager.$region) { region in
                DispatchQueue.main.async {
                    self.mapRegion = region
                }
                locationManager.locationDescription()
            }
            .edgesIgnoringSafeArea(.all)
        }
        .sheet(isPresented: $isShowingModal) {
            OccurrenceDetailView(selectedOccurrence: $selectedOccurrence, isShowingModal: $isShowingModal)
        }
        .onAppear {
            DispatchQueue.main.async {
                occurrenceManager.loadTotalOccurrence()
            }
        }
    }
    
    private func visibleOccurrences() -> [Occurrence] {
        let zoomOutThreshold: CLLocationDegrees = 0.03
        let zoomLevel = locationManager.region.span.latitudeDelta

        if zoomLevel > zoomOutThreshold {
            return []
        } else {
            return occurrenceManager.occurrences
        }
    }
}

struct MapView: View {
    var body: some View {
        VStack {
            Mapa()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
