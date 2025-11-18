import SwiftUI

struct DataEntryView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var chartManager: ChartDataManager
    
    @State private var date = Date()
    @State private var value = ""

    var body: some View {
        NavigationStack {
            Form {
                DatePicker("Date", selection: $date, displayedComponents: .date)
                HStack {
                    TextField("Value", text: $value)
                        .keyboardType(.decimalPad)
                    Text(chartManager.chartType.unit)
                }
            }
            .navigationTitle("Add Data")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        chartManager.saveData(date: date, value: value)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

