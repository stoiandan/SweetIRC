

import Foundation
import Combine

public class IRCChannel: ObservableObject {
    let name: String
    @Published private(set) var messages: [String] = []
    
    private var subcriptions = Set<AnyCancellable>()
    
    init(name: String, messagePublisher:  some Publisher<Response,Never>) {
        self.name = name
        messagePublisher.sink(receiveValue: { serverMessage in
            switch serverMessage {
            case .fail:
                self.messages.append("Faield to receive message from server")
            case .cotent(let message):
                self.messages.append(message)
            }
        }).store(in: &subcriptions)
    }
    
}
