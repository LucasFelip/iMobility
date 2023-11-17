import SwiftUI
import Charts

struct OccurrenceByStateChart: View {
    @ObservedObject var chartManager: ChartManager
    @Binding var location: String
    
    var body: some View {
        VStack {
            let data = chartManager.aggregateDataByState(forCountry: location)
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
        }
    }
}

struct OccurrenceByCityChart: View {
    @ObservedObject var chartManager: ChartManager
    @Binding var location: String
    
    var body: some View {
        VStack {
            let data = chartManager.aggregateDataByCity(forState: location)
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
        }
    }
}

struct OccurrenceByNeighboodChart: View {
    @ObservedObject var chartManager: ChartManager
    @Binding var location: String
    
    var body: some View {
        VStack {
            let data = chartManager.aggregateDataByNeighborhood(forCity: location)
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
        }
    }
}
