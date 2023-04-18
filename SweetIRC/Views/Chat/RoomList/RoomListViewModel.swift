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
    
    @Published var searchText = ""
    
    @Published private(set)  var rooms: [RoomInfo] = []
    @Published private(set) var status = SearchState.iniial
    
    
    private var store = Set<AnyCancellable>()
    
    init(search: @escaping (String) -> PassthroughSubject<RoomInfo,Error>) {
        self.searchEngine = search
    }

    func handleSearch(of searchText: String) {
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
