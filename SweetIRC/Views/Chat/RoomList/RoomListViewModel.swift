//
//  RoomListViewModel.swift
//  SweetIRC
//
//  Created by Dan Stoian on 18.04.2023.
//

import Foundation
import Combine

class RoomListViewModel: ObservableObject {
    let searchEngine: (String) -> PassthroughSubject<RoomInfo,Error>
        
    @Published private(set)  var rooms: [RoomInfo] = []
    @Published private(set) var status = SearchState.iniial
    
    @Published var searchText = ""
    
    
    private var store = Set<AnyCancellable>()
    
    init(search: @escaping (String) -> PassthroughSubject<RoomInfo,Error>) {
        self.searchEngine = search
    }
    
    func handleSearch() {
        rooms = []
        status = .querying
        searchEngine(searchText).sink(receiveCompletion: { [weak self] comp in
            guard let self = self else {
                return
            }
            switch comp {
            case .finished:
                if rooms.isEmpty {
                    status = .noResult
                }
            case .failure(_):
                status = .error
            }
        }, receiveValue: { [weak self] room in
            guard let self = self else {
                return
            }
            rooms.append(room)
        })
        .store(in: &store)
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

