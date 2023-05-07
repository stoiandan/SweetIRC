//
//  RoomListView.swift
//  SweetIRC
//
//  Created by Dan Stoian on 09.03.2023.
//

import SwiftUI
import Combine

struct RoomListView: View {
    @StateObject var viewModel: RoomListViewModel
    let joinRoom: (String) async -> Void
    var body: some View {
        VStack {
            HStack {
                TextField("Search Room:", text: $viewModel.searchText)
                    .onSubmit(viewModel.handleSearch)
            }
            .padding()
            if viewModel.rooms.isEmpty {
                statusView
            } else {
                mainView
            }
        }
        .frame(minWidth: 230, minHeight: viewModel.rooms.isEmpty ? CGFloat(150.0) : CGFloat (12 *  Double(viewModel.rooms.count)))
    }
    
    
    var statusView: some View {
        VStack {
            Text(viewModel.status.rawValue)
            if viewModel.status == .querying {
                ProgressView()
            }
        }
        .padding()
    }
    
    var mainView: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(viewModel.rooms.indices, id: \.self) { idx in
                    let room = viewModel.rooms[idx]
                    VStack(alignment: .leading) {
                        Text(room.name)
                            .font(.headline)
                        Text(room.description)
                    }
                    .onTapGesture {
                        Task {
                            await joinRoom(room.name)
                        }
                    }
                }
                .padding([.bottom,.horizontal])
            }
        }
    }
}

struct RoomListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // no rooms queried, aka initial state
            RoomListView(viewModel: vmInitialstate) { val in 
                
            }
            
            // searhc in progress
            RoomListView(viewModel: vmInProgress)  { val in
                
            }
            
            // no rooms found
            RoomListView(viewModel: vmNoRoomsFound) { val in
                
            }
            
            // rooms found
            RoomListView(viewModel: vmWithRooms) { val in
                
            }
            
            
        }.onAppear {
            vmNoRoomsFound.handleSearch()
            vmInProgress.handleSearch()
            vmWithRooms.handleSearch()
            subject.send(RoomInfo(name: "macOS", description: "A great place to talk about macOS"))
            subject.send(RoomInfo(name: "libera", description: "A place for everyone"))
            
            subject.send(completion: .finished)
        }
    }
}


extension RoomListView_Previews {
    private static let vmInProgress = RoomListViewModel(search: { _ in
        let subject = PassthroughSubject<RoomInfo,Error>()
        return subject
    })
    
    private static let vmNoRoomsFound = RoomListViewModel(search: { _ in
        let subject = PassthroughSubject<RoomInfo,Error>()
        subject.send(completion: .finished)
        return subject
    })
    
    private static let vmInitialstate = RoomListViewModel(search: { _ in
        let subject = PassthroughSubject<RoomInfo,Error>()
        return subject
    })
    
    private static let subject = PassthroughSubject<RoomInfo,Error>()
    
    private static let vmWithRooms = RoomListViewModel(search: { _ in
        return subject
    })
    
}
