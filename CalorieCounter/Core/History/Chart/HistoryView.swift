//
//  ChartView.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 30/5/24.
//

import SwiftUI
import KRProgressHUD

struct HistoryView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var isActive: Bool = false
    @StateObject private var viewModel = HistoryViewModel()
    @State private var selectedElement: BarChart.DataSet.DataElement?
    
    var body: some View {
        ZStack {
            VStack {
                Header
                if viewModel.mockBarChartDataSet.elements.isEmpty {
                    Text("Chưa có lịch sử...")
                } else {
                    Spacer().frame(height: 10)
                    Text("Sơ đồ calo 7 ngày gần nhất").font(.headline)
                    BarChart(dataSet: viewModel.mockBarChartDataSet, selectedElement: $selectedElement)
                        .frame(height: 250)
                }
                Spacer().frame(height: 20)
                Text("Chi tiết món ăn").font(.headline)
                Spacer().frame(height: 8)
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.historyResult, id: \.self){ history in
                            Button {
                                // move to to new screen
                            } label: {
                                Text("\(history.date) (\(history.foods.count) món ăn, (\(Int(history.totalCalories))/\(Int(history.target)))")
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 8)
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 2)
                        }
                    }
                }
            }
            .onAppear {
                if viewModel.historyResult.isEmpty {
                    KRProgressHUD.show()
                    viewModel.getAllHistory { histories in
                        print(histories.count)
                        KRProgressHUD.dismiss()
                        selectedElement = viewModel.mockBarChartDataSet.elements.first
                    }
                }
            }
        }
    }
}

extension HistoryView {
    var Header: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
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
                                .foregroundColor(Color.cl_F24F1D())
                        })
                        .navigationDestination(isPresented: $isActive, destination: {
                            SettingView()
                        })
                        Text("Cài đặt")
                            .font(.system(size: Vconst.DESIGN_WIDTH_RATIO * 15 ))
                            .foregroundColor(Color.cl_F24F1D())
                    }
                    .padding(.trailing, Vconst.DESIGN_WIDTH_RATIO * 25)
                }
                Spacer()
             }
        }.frame(height: 60)
    }
}


#Preview {
    HistoryView()
}
