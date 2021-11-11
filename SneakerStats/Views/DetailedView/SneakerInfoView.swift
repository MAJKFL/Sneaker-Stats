//
//  SneakerInfoView.swift
//  SneakerStats
//
//  Created by Kuba Florek on 04/07/2020.
//

import SwiftUI

struct SneakerInfoView: View {
    var sneaker: Sneaker
    
    var body: some View {
        HStack{
            VStack(alignment: .leading, spacing: 5) {
                Section(header: Text("brand").font(.system(size: 21, weight: .heavy, design: .default))){
                    Text(sneaker.brand ?? "-")
                }
                
                Section(header: Text("gender").font(.system(size: 21, weight: .heavy, design: .default))){
                    Text(sneaker.gender ?? "-")
                }
                
                Section(header: Text("colorway").font(.system(size: 21, weight: .heavy, design: .default))){
                    Text(sneaker.colorway ?? "-")
                }
                
                Section(header: Text("retail price").font(.system(size: 21, weight: .heavy, design: .default))){
                    Text("\(sneaker.retailPrice)$")
                }
                
                Section(header: Text("release date").font(.system(size: 21, weight: .heavy, design: .default))){
                    Text(shortReleaseDate())
                }
                
                Section(header: Text("style ID").font(.system(size: 21, weight: .heavy, design: .default))){
                    Text(sneaker.styleId ?? "-")
                }
                
                Section(header: Text("id").font(.system(size: 21, weight: .heavy, design: .default))){
                    Text(sneaker.id ?? "-")
                }
            }
            .font(.title2)
            .fixedSize(horizontal: false, vertical: true)
            .foregroundColor(Color.black)
            .padding()
            
            Spacer()
        }
        .background(Color("DarkerWhite"))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 3)
        .padding()
    }
    
    func shortReleaseDate() -> String {
        var str = sneaker.releaseDate
        str?.removeLast(8)
        return str ?? "--/--/----"
    }
}
