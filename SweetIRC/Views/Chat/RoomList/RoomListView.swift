//
//  RoomListView.swift
//  SweetIRC
//
//  Created by Dan Stoian on 09.03.2023.
//

import SwiftUI
import Combine

struct RoomListView: View {
    let searchEngine: (String) -> PassthroughSubject<String,Error>
    @State var rooms: [String] = []
    @State var seachText = ""
    @State var selection: Int?
    @State var store = Set<AnyCancellable>()
    @State var status = SeachState.iniial
    var body: some View {
        VStack {
            HStack {
                TextField("Search Room:", text: $seachText)
                Button("Search", action: handleSearch)
            }
            .padding()
                if rooms.isEmpty {
                    Text(status.rawValue)
                } else {
                    mainView
                }
        }
    }
    
    
    func handleSearch() {
        status = .querying
        searchEngine(seachText).sink(receiveCompletion: { comp in
            switch comp {
            case .finished:
                if rooms.isEmpty {
                    status = .noResult
                }
            case .failure(_):
                status = .error
            }
        }, receiveValue: { room in
            rooms.append(room)
        })
        .store(in: &store)
    }
    
    @ViewBuilder
    var mainView: some View {
        List(rooms.indices, id: \.self, selection: $selection) { idx in
            Text(rooms[idx])
        }
        .padding([.bottom,.horizontal])
        if selection != nil {
            Button("Join") {
            }
        }
    }
}

struct RoomListView_Previews: PreviewProvider {
    static var previews: some View {
        RoomListView(searchEngine: { _ in return PassthroughSubject<String,Error>()},
                     rooms: ["##linux","##fedora","##apple","##mac"])
    }
}


enum ListViewError: Error {
    case fail
}


enum SeachState: String {
    case iniial = "No room queried"
    case querying = "Performing query..."
    case noResult = "No rooms found"
    case error = "There was an error searching for rooms"
}
