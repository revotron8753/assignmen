import SwiftUI
import Combine

struct DashboardResponse: Codable {
    let topLinks: [LinkData]
    let recentLinks: [LinkData]
    let chartData: [ChartData]
    
    struct LinkData: Codable, Identifiable {
        let id: Int
        let title: String
        let url: String
    }
    
    struct ChartData: Codable, Identifiable {
        let id: Int
        let label: String
        let value: Double
    }
}

class DashboardViewModel: ObservableObject {
    @Published var topLinks: [DashboardResponse.LinkData] = []
    @Published var recentLinks: [DashboardResponse.LinkData] = []
    @Published var chartData: [DashboardResponse.ChartData] = []
    @Published var greeting: String = ""
    
    private var cancellable: AnyCancellable?
    
    init() {
        fetchDashboardData()
        updateGreeting()
    }
    
    func fetchDashboardData() {
        let url = URL(string: "https://api.inopenapp.com/api/v1/dashboardNew")!
        var request = URLRequest(url: url)
        request.setValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjU5MjcsImlhdCI6MTY3NDU1MDQ1MH0.dCkW0ox8tbjJA2GgUx2UEwNlbTZ7Rr38PVFJevYcXFI", forHTTPHeaderField: "Authorization")
        
        cancellable = URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: DashboardResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching data: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { response in
                self.topLinks = response.topLinks
                self.recentLinks = response.recentLinks
                self.chartData = response.chartData
            })
    }
    
    func updateGreeting() {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12:
            greeting = "Good Morning"
        case 12..<17:
            greeting = "Good Afternoon"
        case 17..<21:
            greeting = "Good Evening"
        default:
            greeting = "Good Night"
        }
    }
}
