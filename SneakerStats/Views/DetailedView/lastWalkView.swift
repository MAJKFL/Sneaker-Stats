//
//  lastWalkView.swift
//  SneakerStats
//
//  Created by Kuba Florek on 07/07/2020.
//

import SwiftUI

struct lastWalkView: View {
    @ObservedObject var sneaker: Sneaker
    
    var body: some View {
        HStack{
            VStack(alignment: .leading, spacing: 5) {
                Section(header: Text(sneaker.isWalking ? "walking:" : "last walk").font(.system(size: 23, weight: .heavy, design: .default))){
                    if sneaker.isWalking {
                        
                        CountingUpTimerView(date: sneaker.lastWalkDate ?? Date())
                    } else {
                        Text(mediumDate())
                        
                        Text(hoursMinutesSeconds(time: Int(sneaker.lastWalkTime)))
                    }
                }
                
                Section(header: Text("total walks").font(.system(size: 23, weight: .heavy, design: .default))){
                    Text(String(sneaker.totalWalks))
                }
                
                Section(header: Text("total walk time").font(.system(size: 23, weight: .heavy, design: .default))){
                    Text(hoursMinutesSeconds(time: Int(sneaker.totalWalkTime)))
                }
                
                Section(header: Text("average walk time").font(.system(size: 23, weight: .heavy, design: .default))){
                    Text(hoursMinutesSeconds(time: Int(sneaker.averageWalkTime)))
                }
            }
            .font(.title2)
            .foregroundColor(Color.black)
            .padding()
            
            Spacer()
        }
        .background(Color("DarkerWhite"))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 5)
        .padding([.top, .horizontal])
        .animation(.default)
    }
    
    func mediumDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        if let date = sneaker.lastWalkDate {
            return formatter.string(from: date)
        } else {
            return "--/--/----"
        }
    }
    
    func hoursMinutesSeconds(time: Int?) -> String {
        if let wrappedTime = time {
            return "\(wrappedTime / 86400) d \((wrappedTime % 86400) / 3600) h \((wrappedTime % 3600) / 60) min \((wrappedTime % 3600) % 60) sec"
        } else {
            let diffComponents = Calendar.current.dateComponents([.second], from: sneaker.lastWalkDate ?? Date(), to: Date())
            let seconds = diffComponents.second ?? 0
            
            return "\(seconds / 86400) d \((seconds % 86400) / 3600) h \((seconds % 3600) / 60) min \((seconds % 3600) % 60) sec"
        }
    }
}
