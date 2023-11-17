import SwiftUI

struct ReportView: View {
    @EnvironmentObject private var occurrenceManager: OccurrenceManager
    @EnvironmentObject private var locationManager: LocationManager
    
    @ObservedObject private var chartManager = ChartManager()
    
    @State private var isShowingButtonBack = true
    @State private var isShowingAccontuserView = false
    @State private var isShowingReportDetailRegion = false
    
    @State private var countryUser: String = ""
    @State private var stateUser: String = ""
    @State private var cityUser: String = ""
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack {
                    Vector(imageName: "Vector 1", startX: geometry.size.width, startY: -geometry.size.height)
                    
                    if isShowingReportDetailRegion {
                        ScrollView {
                            VStack{
                                Text("Informações da sua região")
                                    .font(.title)
                                    .padding(.bottom, 10)
                                Text("\(countryUser)")
                                    .bold()
                                    .padding(.bottom, 10)
                                SectionView(title: "Ocorrências por Estado") {
                                    OccurrenceByStateChart(chartManager: chartManager, location: $countryUser)
                                }
                                SectionView(title: "Ocorrências por Cidade") {
                                    OccurrenceByCityChart(chartManager: chartManager, location: $stateUser)
                                }
                                SectionView(title: "Ocorrências por Bairro") {
                                    OccurrenceByNeighboodChart(chartManager: chartManager, location: $cityUser)
                                }
                            }
                        }
                        .frame(height: geometry.size.width * 1.6)
                    } else {
                        ScrollView {
                            VStack {
                                Text("Informações Gerais")
                                    .font(.title)
                                    .padding(.bottom, 10)
                                SectionView(title: "Ocorrências por Tipos (Limite de 5)") {
                                    OccurrenceByTypeChart(chartManager: chartManager)
                                }
                                SectionView(title: "Ocorrências por Dia") {
                                    OccurrenceByDateChart(chartManager: chartManager)
                                }
                                SectionView(title: "Ocorrências por Importância") {
                                    OccurrenceRatesChart(chartManager: chartManager)
                                }
                                SectionView(title: "Ocorrências por Região (Limite de 5)") {
                                    OccurrenceByRegionChart(chartManager: chartManager)
                                }
                                ButtonRetangularSimple(buttonText: "Ver dados de região", action: {
                                    isShowingReportDetailRegion = true
                                })
                            }
                        }
                        .frame(height: geometry.size.width * 1.6)
                    }
                    Vector(imageName: "Vector 2", startX: -geometry.size.width, startY: geometry.size.height)
                }
                .onAppear {
                    defineLocationUser()
                }
                .onReceive(occurrenceManager.$occurrences) { newOccurrences in
                    chartManager.setOccurrences(newOccurrences)
                }
                .edgesIgnoringSafeArea(.all)
                .navigationBarItems(leading: Group {
                    if isShowingButtonBack {
                        Button(action: {
                            if isShowingReportDetailRegion {
                                isShowingReportDetailRegion = false
                            } else {
                                isShowingAccontuserView = true
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title)
                                .foregroundColor(.primary)
                        }
                    }
                })
                .navigationDestination(isPresented: $isShowingAccontuserView, destination: {
                    AccontUserView()
                        .navigationBarBackButtonHidden(true)
                })
            }
        }
    }
    
    func defineLocationUser() {
        locationManager.locationDescription()
        countryUser = locationManager.country
        stateUser = locationManager.state
        cityUser = locationManager.city
    }
}

struct SectionView<Content: View>: View {
    let title: String
    let content: () -> Content
    
    var body: some View {
        VStack(alignment: .center) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.bottom, 10)
            content()
        }
        .padding(.all, 10)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

