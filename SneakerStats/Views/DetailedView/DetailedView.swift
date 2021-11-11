//
//  DetailedView.swift
//  SneakerStats
//
//  Created by Kuba Florek on 03/07/2020.
//

import SwiftUI

struct DetailedView: View, FetchableImage{
    enum detailinfo: String, CaseIterable{
        case stats
        //case stockx
        case details
    }
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    var sneaker: Sneaker
    
    @State private var showDetailInfo = detailinfo.stats
    @State private var showDeletingConfirmation = false
    
    @State private var image = Image("placeholder")
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack{
                // Main image
                GeometryReader { geometry in
                image
                    .resizable()
                    .scaledToFit()
                    .padding(15)
                    .background(Color.white)
                    .border(Color.white, width: 15)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: geometry.frame(in: .global).minY / 5 + 10 > 0 ? geometry.frame(in: .global).minY / 5 + 10 : 0)
                    .padding()
                    .offset(y: -geometry.frame(in: .global).minY)
                    .frame(width: UIScreen.main.bounds.width , height: geometry.frame(in: .global).minY + 250 > 0 ? geometry.frame(in: .global).minY + 250 : 0)
                }
                    .frame(height: 200)
                    .padding(.vertical)
                    .padding(.top, 45)
                
                // Title
                Text(sneaker.title ?? "-")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding()
                
                // Added date
                Text("Added: \(mediumDate())")
                    .foregroundColor(.secondary)

                // Info panel picker
                Picker(selection: $showDetailInfo, label: Text("")){
                    ForEach(detailinfo.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                
                // Info panels
                VStack{
                    switch showDetailInfo{
                    case .stats:
                        VStack {
                            StartWalkingButtonView(sneaker: sneaker)
                                
                            lastWalkView(sneaker: sneaker)
                                
                            RatingView(sneaker: sneaker)
                                
                            DailySuggestionsStatsView(sneaker: sneaker)
                                
                            Button(action: {
                                print("Sharing sneaker")
                            }) {
                                HStack{
                                    Image(systemName: "square.and.arrow.up")
                                    
                                    Text("Share")
                                }
                                .font(.title)
                            }
                            .padding()
                            }
                        .transition(AnyTransition.opacity.combined(with: .move(edge: .leading)))
                    default:
                        SneakerInfoView(sneaker: sneaker)
                            .transition(AnyTransition.opacity.combined(with: .move(edge: .trailing)))
                    
                        Button(action: {
                            showDeletingConfirmation = true
                        }) {
                            Image(systemName: "trash")
                        }
                        .font(.title)
                        .padding(.bottom)
                        .transition(AnyTransition.opacity.combined(with: .move(edge: .trailing)))
                    }
                }
                    .frame(width: UIScreen.main.bounds.width)
                    .animation(.spring())
            }
            .alert(isPresented: $showDeletingConfirmation) {
                Alert(title: Text("Delete sneaker"), message: Text("Are you sure?"), primaryButton:
                    .destructive(Text("Delete")) {
                        deleteSneaker()
                    }, secondaryButton: .cancel())
            }
            .onAppear {
                fetchImage()
            }
        }
    }
    
    func deleteSneaker() {
        print("Deleting sneaker...")
        
        let imageUrls: [String] = [
            sneaker.imageUrl ?? "https://stockx.imgix.net",
            sneaker.smallImageUrl ?? "https://stockx.imgix.net",
            sneaker.thumbUrl ?? "https://stockx.imgix.net"
        ]
        
        deleteBatchImages(using: imageUrls)
        
        moc.delete(sneaker)
        try? moc.save()
        presentationMode.wrappedValue.dismiss()
    }
    
    func fetchImage() {
        fetchImage(from: sneaker.imageUrl, options: nil) { (avatarData) in
            if let data = avatarData {
                DispatchQueue.main.async {
                    if let cgimage = UIImage(data: data)?.cgImage {
                        self.image = Image(cgimage, scale: 1.0, label: Text(""))
                    }
                }
            }
        }
    }
    
    func mediumDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: sneaker.addedDate ?? Date())
    }
}
