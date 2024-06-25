//
//  LineChartDemoView.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 1/6/24.
//

import SwiftUI
import SwiftUICharts
//import Lottie


struct HistoryChartView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var isActive: Bool = false
    @StateObject private var viewModel = HistoryModel()
    @State private var chartData: [(String, Int)] = []
    
    var body: some View {
        ZStack {
            Color.cl_E1E2E7().opacity(0.4).ignoresSafeArea()
            VStack {
                Header.frame(height: Vconst.DESIGN_HEIGHT_RATIO * 80)
                if chartData.isEmpty {
                    //                let animationView = AnimationView()
                    //                animationView.animation = Animation.named("your-animation-file-name")
                    //                animationView.loopMode = .loop
                    //                animationView.contentMode = .scaleAspectFit
                    //                animationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
                    //                view.addSubview(animationView)
                    //                animationView.play()
                    Text("Lịch sử trống...")
                } else {
                    let data = HistoryChartView.weekOfData(chartData: chartData)
                    LineChart(chartData: data)
                        .pointMarkers(chartData: data).foregroundColor(.blue)
                        .touchOverlay(chartData: data, specifier: "%.0f")
                        .yAxisGrid(chartData: data)
                        .xAxisLabels(chartData: data)
                        .yAxisLabels(chartData: data)
                        .infoBox(chartData: data)
                        .headerBox(chartData: data)
                        .legends(chartData: data, columns: [GridItem(.flexible()), GridItem(.flexible())])
                        .id(data.id)
                        .frame(minWidth: 150, maxWidth: UIScreen.height - 100, minHeight: 150, idealHeight: 250, maxHeight: 600, alignment: .center)
                        .padding(.leading, 0)
                        .padding(.trailing, 30)
                }
                Spacer()
            }
            .navigationTitle("Week of Data")
            .onAppear {
                viewModel.fetchHistory{ historyArray in
                    var data: [(String, Int)] = []
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd"
                    
                    for history in historyArray {
                        data.append((history.date, history.totalCalorie))
                    }
                    data.sort { $0.0 < $1.0 }
                    DispatchQueue.main.async {
                        self.chartData = data
                    }
                }
            }
        }
    }
    
    static func weekOfData(chartData: [(String, Int)]) -> LineChartData {
        let data = LineDataSet(dataPoints: [
            LineChartDataPoint(value: Double(chartData[0].1), xAxisLabel: "\(chartData[0].0)", description: chartData[0].0),
//            LineChartDataPoint(value: Double(chartData[1].1), xAxisLabel: "\(chartData[1].0)", description: "\(chartData[1].0)"),
//            LineChartDataPoint(value: Double(chartData[2].1),  xAxisLabel: "\(chartData[0].0)", description: "\(chartData[2].0)"),
//            LineChartDataPoint(value: Double(chartData[3].1), xAxisLabel: "\(chartData[3].0)", description: "\(chartData[3].0)"),
//            LineChartDataPoint(value: Double(chartData[4].1), xAxisLabel: "\(chartData[4].0)", description: "\(chartData[4].0)"),
//            LineChartDataPoint(value: Double(chartData[5].1), xAxisLabel: "\(chartData[5].0)", description: "\(chartData[5].0)"),
//            LineChartDataPoint(value: Double(chartData[6].1),  xAxisLabel: "\(chartData[6].0)", description: "\(chartData[6].0)")
        ],
                               style: LineStyle(lineColour: ColourStyle(colour: .purple), lineType: .stepped))
        
        let metadata   = ChartMetadata(title: "Calories", subtitle: "Over a Week")
        
        let gridStyle  = GridStyle(numberOfLines: 7,
                                   lineColour   : Color(.lightGray).opacity(0.5),
                                   lineWidth    : 1,
                                   dash         : [8],
                                   dashPhase    : 0)
        
        let chartStyle = LineChartStyle(infoBoxPlacement    : .infoBox(isStatic: false),
                                        infoBoxBorderColour : Color.primary,
                                        infoBoxBorderStyle  : StrokeStyle(lineWidth: 1),
                                        
                                        markerType          : .vertical(attachment: .line(dot: .style(DotStyle()))),
                                        
                                        xAxisGridStyle      : gridStyle,
                                        xAxisLabelPosition  : .bottom,
                                        xAxisLabelColour    : Color.primary,
                                        xAxisLabelsFrom     : .dataPoint(rotation: .degrees(0)),
                                        
                                        yAxisGridStyle      : gridStyle,
                                        yAxisLabelPosition  : .leading,
                                        yAxisLabelColour    : Color.primary,
                                        yAxisNumberOfLabels : 7,
                                        
                                        baseline            : .minimumWithMaximum(of: 0),
                                        topLine             : .maximum(of: 2500),
                                        
                                        globalAnimation     : .easeOut(duration: 1))
        
        return LineChartData(dataSets       : data,
                             metadata       : metadata,
                             chartStyle     : chartStyle)
    }
}

extension HistoryChartView {
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
                        Text("Setting")
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
    HistoryChartView()
}
