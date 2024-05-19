struct ContentView: View {
    @StateObject private var viewModel = DashboardViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Text(viewModel.greeting)
                    .font(.largeTitle)
                    .padding()
                
                ChartView(chartData: viewModel.chartData)
                    .padding()
                
                TabView {
                    List(viewModel.topLinks) { link in
                        LinkView(link: link)
                    }
                    .tabItem {
                        Text("Top Links")
                    }
                    
                    List(viewModel.recentLinks) { link in
                        LinkView(link: link)
                    }
                    .tabItem {
                        Text("Recent Links")
                    }
                }
                .padding()
            }
            .navigationBarTitle("Dashboard", displayMode: .inline)
        }
    }
}

struct LinkView: View {
    let link: DashboardResponse.LinkData
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(link.title)
                .font(.headline)
            Text(link.url)
                .font(.subheadline)
                .foregroundColor(.blue)
        }
    }
}

struct ChartView: View {
    let chartData: [DashboardResponse.ChartData]
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .bottom) {
                ForEach(chartData) { data in
                    VStack {
                        Text("\(data.value, specifier: "%.0f")")
                            .font(.caption)
                        Rectangle()
                            .fill(Color.blue)
                            .frame(width: geometry.size.width / CGFloat(chartData.count) * 0.6,
                                   height: CGFloat(data.value) * 2)
                        Text(data.label)
                            .font(.caption)
                    }
                }
            }
        }
    }
}

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

