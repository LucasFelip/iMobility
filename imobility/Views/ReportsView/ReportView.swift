import SwiftUI
import Charts

struct OccurrenceByTypeChart: View {
    @ObservedObject private var chartManager = ChartsManager()
    
    var body: some View {
        VStack {
            let data = chartManager.aggregateData()
            
            Text("Total por tipos de ocorrências")
                .bold()
            
            Chart() {
                ForEach(data) { info in
                    BarMark(
                        x: .value("Tipos de ocorrências", info.type),
                        y: .value("Total de ocorrências", info.total)
                    )
                    .cornerRadius(6)
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .foregroundColor(.purple)
        }
    }
}

struct OccurrenceByDateChart: View {
    @ObservedObject private var chartManager = ChartsManager()
    
    var body: some View {
        VStack {
            let data = chartManager.aggregateDataByDate()
            
            Text("Total de ocorrências por dia")
                .bold()
            
            Chart {
                ForEach(data, id: \.count) { info in
                    LineMark(x: .value("Data de Registro", info.date) ,
                             y: .value("Total de ocorrências", info.count)
                    )
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .foregroundColor(.purple)
        }
    }
}

struct OccurrenceByRegionChart: View {
    @ObservedObject private var chartManager = ChartsManager()
    @State private var selectedRegion: RegionType = .city
    
    enum RegionType: String, CaseIterable {
        case neighborhood = "Bairro"
        case city = "Cidade"
        case state = "Estado"
        case country = "País"
    }
    
    private var regionKeyPath: KeyPath<Occurrence, String> {
        switch selectedRegion {
        case .neighborhood:
            return \.neighborhood
        case .city:
            return \.city
        case .state:
            return \.state
        case .country:
            return \.country
        }
    }

    var body: some View {
        VStack {
            let data = chartManager.aggregateDataByRegion(regionKeyPath: regionKeyPath)
            
            Text("Total de ocorrências por \(selectedRegion.rawValue)")
                .bold()
            
            Chart {
                ForEach(data) { info in
                    BarMark(
                        x: .value("Região", info.region),
                        y: .value("Total de ocorrências", Double(info.count))
                    )
                    .cornerRadius(6)
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .foregroundColor(.purple)
            
            Picker("Região", selection: $selectedRegion) {
                ForEach(RegionType.allCases, id: \.self) { region in
                    Text(region.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 25)
        }
    }
}

struct OccurrenceRatesChart: View {
    @ObservedObject private var chartManager = ChartsManager()
    
    var body: some View {
        VStack {
            let occurrenceRates = chartManager.calculateOccurrenceRates()

            Text("Taxas de positividade e negatividade")
                .bold()

            Chart {
                ForEach(occurrenceRates) { occurrenceRate in
                    BarMark(
                        x: .value("Total", occurrenceRate.positiveRate),
                        y: .value("Taxa", occurrenceRate.negativeRate + occurrenceRate.positiveRate)
                    )
                    .cornerRadius(6)
                }
                .foregroundStyle(.purple)
                
                
                ForEach(occurrenceRates) { occurrenceRate in
                    BarMark(
                        x: .value("Total", occurrenceRate.positiveRate ),
                        y: .value("Taxa", occurrenceRate.positiveRate + occurrenceRate.negativeRate)
                    )
                    .cornerRadius(6)
                }
                .foregroundStyle(.blue)
            }
            .aspectRatio(1, contentMode: .fit)
            .foregroundColor(.purple)
            .chartLegend(position: .topLeading)
        }
    }
}

struct ReportView: View {
    @EnvironmentObject private var occurrenceManager: OccurrenceManager
    
    @State private var isShowingButtonBack = true
    @State private var isShowingAccontuserView = false

    var body: some View {
        NavigationStack {
            VStack {
                Vector(imageName: "Vector 1", startX: UIScreen.main.bounds.width, startY: -UIScreen.main.bounds.height)
                ScrollView {
                    OccurrenceByTypeChart()
                        .padding(.all, 30)
                    OccurrenceByDateChart()
                        .padding(.all, 30)
//                    OccurrenceByRegionChart()
//                        .padding(.vertical, 15)
 //                   OccurrenceRatesChart()
 //                       .padding(.vertical, 15)
                }
                .frame(width: 400, height: 650)
                Vector(imageName: "Vector 2", startX: -UIScreen.main.bounds.width, startY: UIScreen.main.bounds.height)
            }
            .edgesIgnoringSafeArea(.all)
            .navigationBarItems(leading: Group {
                if isShowingButtonBack {
                    Button(action: {
                        isShowingAccontuserView = true
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
