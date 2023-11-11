import Foundation

class ChartsManager: NSObject, ObservableObject {
    private let occurrenceManager = OccurrenceManager()
    
    struct AggregatedData: Identifiable {
        let id = UUID()
        let type: String
        let total: Double
    }

    struct OccurrenceByRegion: Identifiable {
        let id = UUID()
        var region: String
        var count: Int
    }

    struct OccurrenceByDate {
        var date: Date
        var count: Int
    }

    struct OccurrenceRate: Identifiable {
        let id = UUID()
        var positiveRate: Double
        var negativeRate: Double
    }
    
    func aggregateData() -> [AggregatedData] {
        let typeOccurrences = Dictionary(grouping: occurrenceManager.occurrences, by: { $0.type })
        let aggregatedData = typeOccurrences.map { (type, occurrences) in
            return AggregatedData(type: type.description, total: Double(occurrences.count))
        }
        return aggregatedData
    }
    
    func aggregateDataByRegion(regionKeyPath: KeyPath<Occurrence, String>) -> [OccurrenceByRegion] {
        let regionOccurrences = Dictionary(grouping: occurrenceManager.occurrences, by: { $0[keyPath: regionKeyPath] })
        let aggregatedData = regionOccurrences.map { (region, occurrences) in
            return OccurrenceByRegion(region: region, count: occurrences.count)
        }
        return aggregatedData
    }

    func aggregateDataByDate() -> [OccurrenceByDate] {
        let dateOccurrences = Dictionary(grouping: occurrenceManager.occurrences, by: { Calendar.current.startOfDay(for: $0.dateRegister) })
        let aggregatedData = dateOccurrences.map { (date, occurrences) in
            return OccurrenceByDate(date: date, count: occurrences.count)
        }
        return aggregatedData
    }
    
    func calculateOccurrenceRates() -> [OccurrenceRate] {
        let occurrences = occurrenceManager.occurrences

        let totalPositiveRate = occurrences.reduce(0.0) { $0 + $1.positiveRate }
        let totalNegativeRate = occurrences.reduce(0.0) { $0 + $1.negativeRate }

        let positiveRate = totalPositiveRate / Double(occurrences.count)
        let negativeRate = totalNegativeRate / Double(occurrences.count)

        return [OccurrenceRate(positiveRate: positiveRate, negativeRate: negativeRate)]
    }
}
