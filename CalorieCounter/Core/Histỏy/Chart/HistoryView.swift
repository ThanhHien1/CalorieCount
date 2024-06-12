//
//  ChartView.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 30/5/24.
//

import SwiftUI
import SwiftUICharts

struct HistoryView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var isActive: Bool = false
    @StateObject private var viewModel = HistoryModel()
    @State private var chartData: [(String, Int)] = []
    
    var body: some View {
        ZStack {
            Color.cl_E1E2E7().opacity(0.4)
                .ignoresSafeArea()
            VStack {
                Header
                if !chartData.isEmpty {
                    Text("Chưa có lịch sử...")
                } else {
                    
                }
            }
            .onAppear {
                viewModel.fetchHistory{ historyArray in
                    guard let historyArray = historyArray else { return }
                    var data: [(String, Int)] = []
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd"
                    
                    for history in historyArray {
                        let dateStr = dateFormatter.string(from: history.date)
                        data.append((dateStr, history.totalCalorie))
                    }
                    
                    // Sắp xếp dữ liệu theo ngày
                    data.sort { $0.0 < $1.0 }
                    
                    // Cập nhật chartData trên luồng chính
                    DispatchQueue.main.async {
                        self.chartData = data
                    }
                }
            }
        }
    }
}

extension HistoryView {
    var Header: some View {
        ZStack {
            Color.cl_F24F1D()
                .edgesIgnoringSafeArea(.all)
            VStack() {
                Spacer().frame(height:  Vconst.DESIGN_HEIGHT_RATIO * 10)
                HStack {
                    Spacer()
                    VStack {
                        Button(action: {
                            isActive = true
                        }, label: {
                            Image(systemName: "gearshape.fill")
                                .resizable()
                                .frame(width: Vconst.DESIGN_WIDTH_RATIO * 20, height: Vconst.DESIGN_HEIGHT_RATIO * 20)
                                .foregroundColor(.white)
                        })
                        .navigationDestination(isPresented: $isActive, destination: {
                            SettingView()
                        })
                        Text("Cài đặt")
                            .font(.system(size: Vconst.DESIGN_WIDTH_RATIO * 15 ))
                            .foregroundColor(.white)
                    }
                    .padding(.trailing, Vconst.DESIGN_WIDTH_RATIO * 25)
                }
                Spacer()
             }
        }
    }
}


#Preview {
    HistoryView()
}
