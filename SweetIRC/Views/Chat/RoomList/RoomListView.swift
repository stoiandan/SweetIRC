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
    @State var error = false
    @State var seachText = ""
    @State var selection: Int?
    @State var store = Set<AnyCancellable>()
    var body: some View {
        VStack {
            HStack {
                TextField("Search Room:", text: $seachText)
                Button("Search") {
                    searchEngine(seachText).sink(receiveCompletion: { comp in
                        switch comp {
                        case .finished:
                            break
                        case .failure(_):
                            error.toggle()
                        }
                    }, receiveValue: { room in
                        rooms.append(room)
                    })
                    .store(in: &store)
                }
            }
            .padding()
            if !error {
                List(rooms.indices, id: \.self, selection: $selection) { idx in
                        Text(rooms[idx])
                }
                .padding([.bottom,.horizontal])
                if selection != nil {
                    Button("Join") {
                        
                    }
                }
            } else {
                Text("Could not load the list an error occured")
            }
        }
        .frame(minWidth: 50, maxWidth: 240, minHeight: 50)
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
