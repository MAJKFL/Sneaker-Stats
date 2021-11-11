//
//  CountingUpTimerView.swift
//  SneakerStats
//
//  Created by Kuba Florek on 09/07/2020.
//

import SwiftUI
import Combine

struct CountingUpTimerView: View {
    @State var date: Date
    
    @State var now = Date()

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Text(hoursMinutesSeconds())
            .onReceive(timer) { time in
                now = Date()
            }
    }
    
    func hoursMinutesSeconds() -> String {
        let diffComponents = Calendar.current.dateComponents([.second], from: date, to: now)
        let seconds = diffComponents.second ?? 0
        
        return "\((seconds % 86400) / 3600) hours \((seconds % 3600) / 60) minutes \((seconds % 3600) % 60) seconds"
    }
}
