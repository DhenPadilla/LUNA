//
//  Events.swift
//  LUA Application
//
//  Created by Dhen Padilla on 27/01/2018.
//  Copyright © 2018 dhenpadilla. All rights reserved.
//

import Foundation

class Events {
    private var events:[Event] = []
    
    static let sharedEventsModel = Events()
    
    func appendEvent(newEvent: Event) {
        events.append(newEvent)
    }
    
    func getEvents() -> [Event] {
        return self.events
    }

    
}
