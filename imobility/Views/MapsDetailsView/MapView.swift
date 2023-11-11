import SwiftUI
import MapKit

struct Mapa: View {
    @EnvironmentObject private var occurrenceManager: OccurrenceManager
    @EnvironmentObject private var userManager: UserManager
    @EnvironmentObject private var locationManager: LocationManager
    
    @State private var isShowingModal = false
    @State private var selectedOccurrence: Occurrence?
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $locationManager.region,
                showsUserLocation: true,
                annotationItems: occurrenceManager.occurrences) { occurrence in
                MapAnnotation(coordinate: occurrence.coordinate) {
                    MapPinMaker()
                        .onTapGesture(count: 1, perform: {
                            selectedOccurrence = occurrence
                            isShowingModal = true
                        })
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $isShowingModal) {
            OccurrenceDetailView(selectedOccurrence: $selectedOccurrence, isShowingModal: $isShowingModal)
        }
        .onAppear {
            occurrenceManager.loadTotalOccurrence()
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
