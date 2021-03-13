//
//  ContentView.swift
//  API Calling
//
//  Created by Yawar Kamran on 2/28/21.
//

import SwiftUI
struct ContentView: View {
    @State private var entries = [Entry]()
    @State private var showingAlert = false
    var body: some View {
        NavigationView {
            List(entries) { entry in
                Link(destination: URL(string: entry.link)!, label: {
                    Text(entry.title)
                })
            }
            .navigationTitle("Elon Musk")
        }
        .onAppear(perform: {
            queryAPI()
        })
        .alert(isPresented: $showingAlert, content: {
            Alert(title: Text("Loading Error"),
                  message: Text("There was a problem loading the data"),
                  dismissButton: .default(Text("OK")))
        })
    }
    func queryAPI() {
        let query = "https://google-search3.p.rapidapi.com/api/v1/search/q=elon+musk&num=100?rapidapi-key=6f680e027cmsh663637dcbd8e3aap10a339jsn6758ecd66f5f"
        
        if let url = URL(string: query) {
            if let data = try? Data(contentsOf: url) {
                let json = try! JSON(data: data)
                let contents = json["results"].arrayValue
                for item in contents {
                    let title = item["title"].stringValue
                    let link = item["link"].stringValue
                    let entry = Entry(title: title, link: link)
                    
                    entries.append(entry)
                }
                return
            }
        }
        showingAlert = true
    }
    
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
struct Entry: Identifiable {
    let id = UUID()
    let title: String
    let link: String
}
