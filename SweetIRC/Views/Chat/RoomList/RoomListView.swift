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
    
    var body: some View {
        VStack {
            HStack {
                TextField("Search Room:", text: $viewModel.searchText)
                    .onSubmit {
                        viewModel.handleSearch(of: viewModel.searchText)
                    }
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
                    VStack(alignment: .leading) {
                        Text(viewModel.rooms[idx].name)
                            .font(.headline)
                        Text(viewModel.rooms[idx].description)
                    }
                }
                .padding([.bottom,.horizontal])
            }
        }
    }
}

struct RoomListView_Previews: PreviewProvider {
    
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
    
    static var previews: some View {
        Group {
            // no rooms queried, aka initial state
            RoomListView(viewModel: vmInitialstate)
            
            // searhc in progress
            RoomListView(viewModel: vmInProgress)
            
            // no rooms found
            RoomListView(viewModel: vmNoRoomsFound)
            
            // rooms found
            RoomListView(viewModel: vmWithRooms)
            
            
        }.onAppear {
            vmNoRoomsFound.handleSearch(of: "")
            vmInProgress.handleSearch(of: "")
            vmWithRooms.handleSearch(of: "")
            subject.send(RoomInfo(name: "macOS", description: "A great place to talk about macOS"))
            subject.send(RoomInfo(name: "libera", description: "A place for everyone"))
            
            subject.send(completion: .finished)
        }
    }
}


enum ListViewError: Error {
    case fail
}


enum SearchState: String {
    case iniial = "No room queried"
    case querying = "Performing query..."
    case noResult = "No rooms found"
    case error = "There was an error searching for rooms"
}



public struct RoomInfo: Hashable {
    let name: String
    let description: String
}
