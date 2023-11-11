import SwiftUI
import Firebase

@main
struct imobilityApp: App {
    @ObservedObject private var userManager = UserManager()
    @ObservedObject private var occurrenceManager = OccurrenceManager()
    @ObservedObject private var locationManager = LocationManager()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userManager)
                .environmentObject(occurrenceManager)
                .environmentObject(locationManager)
        }
    }
}
