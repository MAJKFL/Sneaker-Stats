//
//  DailySuggestionsStatsView.swift
//  SneakerStats
//
//  Created by Kuba Florek on 07/07/2020.
//

import SwiftUI

struct DailySuggestionsStatsView: View {
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var sneaker: Sneaker
    
    var body: some View {
        let presentInDailySuggestions = Binding<Bool>(
            get: {
                self.sneaker.includeInDailySuggestions
            },
            set: {
                self.sneaker.includeInDailySuggestions = $0
                try? self.moc.save()
            }
        )
        
        return ZStack{
            VStack(alignment: .leading, spacing: 5) {
                Section(header: Text("last time in daily suggestions").font(.system(size: 21, weight: .heavy, design: .default))){
                    Text(shortDate())
                }
                .foregroundColor(.white)
                .colorMultiply(sneaker.includeInDailySuggestions ? Color.black : Color.gray)
                
                Section(header: Text("times in daily suggestions").font(.system(size: 21, weight: .heavy, design: .default))){
                    Text(String(sneaker.showedInDailySuggestions))
                }
                .foregroundColor(.white)
                .colorMultiply(sneaker.includeInDailySuggestions ? Color.black : Color.gray)
                
                Section(header: Text("average place").font(.system(size: 21, weight: .heavy, design: .default))){
                    Text(String(format: "%.2f", sneaker.averagePlace))
                }
                .foregroundColor(.white)
                .colorMultiply(sneaker.includeInDailySuggestions ? Color.black : Color.gray)
                
                Toggle(isOn: presentInDailySuggestions) {
                    Text("Include in daily suggestions").font(.system(size: 21, weight: .heavy, design: .default))
                        .foregroundColor(.white)
                        .colorMultiply(sneaker.includeInDailySuggestions ? Color.black : Color.gray)
                }
            }
            .animation(.default)
            .font(.title2)
            .padding()
        }
        .background(Color("DarkerWhite"))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 5)
        .padding([.top, .horizontal])
    }
    
    func shortDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        if let date = sneaker.lastTimeInDailySuggestions {
            return formatter.string(from: date)
        } else {
            return "--/--/----"
        }
    }
}
