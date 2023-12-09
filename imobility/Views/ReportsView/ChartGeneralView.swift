import SwiftUI
import Charts

struct OccurrenceByTypeChart: View {
    @ObservedObject var chartManager: ChartManager
    
    var body: some View {
        VStack {
            let data = chartManager.aggregateDataForType()
            let maxTotal = data.max(by: { $0.total < $1.total })?.total ?? 0
            Chart {
                ForEach(data) { aggregatedData in
                    BarMark(
                        x: .value("Tipo de Ocorrência", aggregatedData.type),
                        y: .value("Total de Ocorrências", aggregatedData.total)
                    )
                    .cornerRadius(6)
                    .foregroundStyle(aggregatedData.total == maxTotal ? Color.blue : Color.purple)
                }
            }
            .aspectRatio(1, contentMode: .fit)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}

struct OccurrenceByDateChart: View {
    @ObservedObject var chartManager: ChartManager
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    var body: some View {
        VStack {
            let data = chartManager.aggregateDataByDate()
            Chart {
                ForEach(data, id: \.id) { info in
                    LineMark(
                        x: .value("Data de Registro", dateFormatter.string(from: info.date)),
                        y: .value("Total de ocorrências", info.count)
                    )
                    .interpolationMethod(.catmullRom)
                }
            }
            .chartXAxis {
                AxisMarks(preset: .aligned, position: .bottom)
            }
            .chartYAxis {
                AxisMarks(preset: .aligned, position: .leading)
            }
            .aspectRatio(1, contentMode: .fit)
            .foregroundColor(.purple)
            .chartLegend(position: .topLeading)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}

struct OccurrenceRatesChart: View {
    @ObservedObject var chartManager: ChartManager
    
    var body: some View {
        VStack {
            let occurrenceRates = chartManager.calculateOccurrenceRates()
            Chart {
                ForEach(occurrenceRates) { occurrenceRate in
                    let isPositiveGreater = occurrenceRate.positiveRate > occurrenceRate.negativeRate
                    let positiveColor: Color = isPositiveGreater ? .blue : .purple
                    let negativeColor: Color = isPositiveGreater ? .purple : .blue
                    
                    BarMark(
                        x: .value("Total de Importantes", "Positiva"),
                        y: .value("Total", occurrenceRate.positiveRate)
                    )
                    .cornerRadius(6)
                    .foregroundStyle(positiveColor)

                    BarMark(
                        x: .value("Total de Não Importates", "Negativa"),
                        y: .value("Total", occurrenceRate.negativeRate)
                    )
                    .cornerRadius(6)
                    .foregroundStyle(negativeColor)
                }
            }
            .chartXAxis {
                AxisMarks(preset: .aligned, position: .bottom)
            }
            .chartYAxis {
                AxisMarks(preset: .aligned, position: .leading)
            }
            .aspectRatio(1, contentMode: .fit)
            .chartLegend(position: .topLeading)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}

struct OccurrenceByRegionChart: View {
    @ObservedObject var chartManager: ChartManager
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
            let maxCount = data.map { $0.count }.max() ?? 0
            
            Chart {
                ForEach(data) { info in
                    let isMaxValue = info.count == maxCount
                    let barColor: Color = isMaxValue ? .blue : .purple

                    BarMark(
                        x: .value("Região", info.region),
                        y: .value("Total de ocorrências", Double(info.count))
                    )
                    .cornerRadius(6)
                    .foregroundStyle(barColor)
                }
            }
            .aspectRatio(1, contentMode: .fit)
            
            Picker("Região", selection: $selectedRegion) {
                ForEach(RegionType.allCases, id: \.self) { region in
                    Text(region.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 25)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}
