import SwiftUI

struct ChartsView: View {
    var body: some View {
        NavigationStack {
            List {
                ForEach(ChartType.allCases) { chartType in
                    NavigationLink(destination: DetailedChartView(chartType: chartType)) {
                        HStack {
                            Image(systemName: "chart.bar.fill")
                                .foregroundColor(chartType.color)
                            Text(chartType.rawValue.capitalized)
                        }
                    }
                }
            }
            .navigationTitle("Trends")
        }
    }
}


