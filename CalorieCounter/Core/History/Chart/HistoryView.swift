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
                if let food = viewModel.historyResult.first?.foods, food.isEmpty  {
                    LottieView(lottieFile: "Empty")
                        .frame(height: 400)
                    Text("Chưa có lịch sử").font(.headline)
                    Spacer()
                } else {
                    Spacer()
                    Text("Sơ đồ calo 7 ngày gần nhất").font(.headline)
                    BarChart(dataSet: viewModel.mockBarChartDataSet, selectedElement: $selectedElement)
                        .frame(height: 250)
                    Spacer().frame(height: 20)
                    Text("Chi tiết món ăn").font(.headline)
                    Spacer().frame(height: 8)
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.historyResult.sorted(by: { $0.date < $1.date }), id: \.self) { history in
                                if !history.foods.isEmpty {
                                    NavigationLink(destination: DetailFoodHistory(foodToday: history.foods)) {
                                        DetailHistory(date: history.date, totalFood: history.foods.count, calories: "\(Int(history.totalCalories))/\(Int(history.target))")
                                    }
                                }
                            }
                        }
                    }
                }
                Spacer()
                
            }
            .onAppear {
                if viewModel.historyResult.isEmpty {
                                        KRProgressHUD.show()
                    viewModel.getAllHistory { histories in
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
            VStack {
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
