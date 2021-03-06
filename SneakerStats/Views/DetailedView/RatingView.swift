//
//  RatingView.swift
//  Bookworm
//
//  Created by Kuba Florek on 02/06/2020.
//  Copyright © 2020 kf. All rights reserved.
//

import SwiftUI

struct RatingView: View {
    @Environment(\.managedObjectContext) var moc
    
    @ObservedObject var sneaker: Sneaker

    var label = ""

    var maximumRating = 5

    var offImage: Image?
    var onImage = Image(systemName: "star.fill")

    var offColor = Color.gray
    var onColor = Color.yellow
    
    var body: some View {
        HStack {
            if label.isEmpty == false {
                Text(label)
            }
            
            ForEach(1..<maximumRating + 1) { number in
                self.image(for: number)
                    .font(.title)
                    .foregroundColor(Color.white)
                    .colorMultiply(number > Int(sneaker.rating) ? self.offColor : self.onColor)
                    .onTapGesture {
                        sneaker.rating = Int16(number)
                        try? self.moc.save()
                    }
                .accessibility(label: Text("\(number == 1 ? "1 star" : "\(number) stars")"))
                .accessibility(removeTraits: .isImage)
                .accessibility(addTraits: number > Int(sneaker.rating) ? .isButton : [.isButton, .isSelected])
            }
            .padding()
        }
        .background(Color("DarkerWhite"))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 5)
        .padding(.top)
        .animation(.easeOut)
    }
    
    func image(for number: Int) -> Image {
        if number > Int(sneaker.rating) {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
}
