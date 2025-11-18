import SwiftUI
import Charts

struct DetailedChartView: View {
    @StateObject private var chartManager: ChartDataManager
    
    let chartType: ChartType
    @State private var showingDataEntrySheet = false
    
    init(chartType: ChartType) {
        self.chartType = chartType
        _chartManager = StateObject(wrappedValue: ChartDataManager(chartType: chartType))
    }

    private var dailyAverage: Double {
        let values = chartManager.historicalLogs.filter { chartManager.yValue(for: $0) > 0 }.map { chartManager.yValue(for: $0) }
        return values.isEmpty ? 0 : values.reduce(0, +) / Double(values.count)
    }

    private var yAxisDomain: ClosedRange<Double> {
        let maxGenericValue = chartManager.historicalLogs.map { chartManager.yValue(for: $0) }.max() ?? 0
        let maxValue = maxGenericValue > 0 ? maxGenericValue : 100.0
        return 0.0...(maxValue * 1.2)
    }
    
    private var xAxisDomain: ClosedRange<Date> {
        let now = Date().startOfDay
        let endDate = Calendar.current.date(byAdding: .day, value: 1, to: now) ?? now
        let startDate = Calendar.current.date(byAdding: .day, value: -chartManager.selectedTimeRange.days, to: now) ?? now
        return startDate...endDate
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            Picker("Time Range", selection: $chartManager.selectedTimeRange) {
                ForEach(TimeRange.allCases) { range in
                    Text(range.rawValue).tag(range)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            VStack(alignment: .leading) {
                Text("DAILY AVERAGE")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                
                Text("\(dailyAverage, specifier: "%.1f") \(chartType.unit)")
                    .font(.largeTitle).bold()
            }
            .padding(.horizontal)

            let filteredLogs = chartManager.historicalLogs.filter { chartManager.yValue(for: $0) > 0 }
            
            if filteredLogs.isEmpty {
                Spacer()
                Text("No data available for this period. Tap '+' to add an entry.")
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                Spacer()
            } else {
                Chart(filteredLogs) { log in
                    BarMark(
                        x: .value("Date", log.date, unit: .day),
                        y: .value(chartType.rawValue.capitalized, chartManager.yValue(for: log))
                    )
                    .foregroundStyle(chartType.color)
                }
                .chartYScale(domain: yAxisDomain)
                .chartXScale(domain: xAxisDomain)
                .chartXAxis {
                    switch chartManager.selectedTimeRange {
                    case .week:
                        AxisMarks(values: .stride(by: .day)) {
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel(format: .dateTime.weekday(.narrow))
                        }
                    case .month:
                        AxisMarks(values: .stride(by: .weekOfYear)) {
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel(format: .dateTime.month().day())
                        }
                    }
                 }
                 .frame(height: 300)
            }
        }
        .padding()
        .navigationTitle(chartType.rawValue.capitalized)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingDataEntrySheet = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingDataEntrySheet) {
            DataEntryView(chartManager: chartManager)
        }
    }
}

