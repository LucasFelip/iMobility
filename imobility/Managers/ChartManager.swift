import Foundation

class ChartManager: ObservableObject {
    @Published var occurrences: [Occurrence] = []

    func setOccurrences(_ newOccurrences: [Occurrence]) {
        self.occurrences = newOccurrences
    }
    
    func normalizeDate(_ date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return calendar.date(from: components) ?? date
    }

    struct AggregatedData: Identifiable {
        let id = UUID()
        let type: String
        let total: Double
    }

    struct OccurrenceByDate: Identifiable {
        let id = UUID()
        var date: Date
        var count: Int
    }

    struct OccurrenceByRegion: Identifiable {
        let id = UUID()
        var region: String
        var count: Int
    }

    struct OccurrenceRate: Identifiable {
        let id = UUID()
        var positiveRate: Double
        var negativeRate: Double
        var totalRate: Double
    }

    func aggregateDataForType() -> [AggregatedData] {
        let typeOccurrences = Dictionary(grouping: self.occurrences, by: { $0.type })
        let aggregatedData = typeOccurrences.map { type, occurrences in
            AggregatedData(type: type.description, total: Double(occurrences.count))
        }
        return Array(aggregatedData.prefix(5))
    }

    func aggregateDataByDate() -> [OccurrenceByDate] {
        let dateOccurrences = Dictionary(grouping: self.occurrences, by: { occurrence in
            let normalizedDate = normalizeDate(occurrence.dateRegister)
            return normalizedDate
        })
        let aggregatedData = dateOccurrences.map { (date, occurrences) in
            OccurrenceByDate(date: date, count: occurrences.count)
        }.sorted { $0.date < $1.date }
        return aggregatedData
    }

    func aggregateDataByRegion(regionKeyPath: KeyPath<Occurrence, String>) -> [OccurrenceByRegion] {
        let regionOccurrences = Dictionary(grouping: self.occurrences, by: { $0[keyPath: regionKeyPath] })
        let aggregatedData = regionOccurrences.map { (region, occurrences) in
            return OccurrenceByRegion(region: region, count: occurrences.count)
        }
        return Array(aggregatedData.prefix(5))
    }
    
    func aggregateDataByCountry() -> [OccurrenceByRegion] {
        let countryOccurrences = Dictionary(grouping: self.occurrences, by: { $0.country })
        let aggregatedData = countryOccurrences.map { (country, occurrences) in
            return OccurrenceByRegion(region: country, count: occurrences.count)
        }
        return aggregatedData
    }
    
    func aggregateDataByState(forCountry country: String) -> [OccurrenceByRegion] {
        let stateOccurrences = Dictionary(grouping: self.occurrences.filter { $0.country == country }, by: { $0.state })
        let aggregatedData = stateOccurrences.map { (state, occurrences) in
            return OccurrenceByRegion(region: state, count: occurrences.count)
        }
        return aggregatedData
    }
    
    func aggregateDataByCity(forState state: String) -> [OccurrenceByRegion] {
        let cityOccurrences = Dictionary(grouping: self.occurrences.filter { $0.state == state }, by: { $0.city })
        let aggregatedData = cityOccurrences.map { (city, occurrences) in
            return OccurrenceByRegion(region: city, count: occurrences.count)
        }
        return aggregatedData
    }
    
    func aggregateDataByNeighborhood(forCity city: String) -> [OccurrenceByRegion] {
        let neighborhoodOccurrences = Dictionary(grouping: self.occurrences.filter { $0.city == city }, by: { $0.neighborhood })
        let aggregatedData = neighborhoodOccurrences.map { (neighborhood, occurrences) in
            return OccurrenceByRegion(region: neighborhood, count: occurrences.count)
        }
        return aggregatedData
    }
    
    func calculateOccurrenceRates() -> [OccurrenceRate] {
        let totalPositiveRate = occurrences.reduce(0.0) { $0 + $1.positiveRate }
        let totalNegativeRate = occurrences.reduce(0.0) { $0 + $1.negativeRate }

        let totalRate = totalPositiveRate + totalNegativeRate

        return [OccurrenceRate(positiveRate: totalPositiveRate,
                               negativeRate: totalNegativeRate,
                               totalRate: totalRate)]
    }
}
