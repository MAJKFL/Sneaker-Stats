//
//  StartWalkingButtonView.swift
//  SneakerStats
//
//  Created by Kuba Florek on 07/07/2020.
//

import SwiftUI

struct StartWalkingButtonView: View {
    @Environment(\.managedObjectContext) var moc
    
    @ObservedObject var sneaker: Sneaker
    
    var body: some View {
        ZStack {
            Button(action: {
                if sneaker.isWalking {
                    stopWalking()
                } else {
                    startWalking()
                }
            }) {
                Text(sneaker.isWalking ? "Stop walking" : "Start walking")
                    .font(.title)
                    .foregroundColor(Color.white)
                    .padding()
            }
            .buttonStyle(PlainButtonStyle())
            .background(sneaker.isWalking ? Color.red : Color.green)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 10)
        }
        .animation(.default)
        .padding(.horizontal)
    }
    
    func startWalking() {
        sneaker.lastWalkDate = Date()
        sneaker.isWalking = true
        
        try? self.moc.save()
    }
    
    func stopWalking() {
        sneaker.isWalking = false
        
        sneaker.totalWalks += 1
        
        let diffComponents = Calendar.current.dateComponents([.second], from: sneaker.lastWalkDate ?? Date(), to: Date())
        let seconds = diffComponents.second ?? 0
        sneaker.lastWalkTime = Int16(seconds)
        sneaker.totalWalkTime += Int16(seconds)
        
        sneaker.lastWalkDate = Date()
        
        sneaker.averageWalkTime = Double(sneaker.totalWalkTime) / Double(sneaker.totalWalks)
        
        try? self.moc.save()
    }
}
