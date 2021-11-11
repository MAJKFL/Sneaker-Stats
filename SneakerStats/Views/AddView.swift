//
//  AddView.swift
//  SneakerStats
//
//  Created by Kuba Florek on 02/07/2020.
//

import SwiftUI

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(entity: Sneaker.entity(), sortDescriptors: []) var sneakers: FetchedResults<Sneaker>
    
    @ObservedObject var fetchedSneakers = SearchedSneakersModel()
    
    @State private var styleId = ""
    
    @State private var selectedSneaker: sneaker? = nil
    
    @State private var showConfirmationAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $styleId, placeholder: "Search") {
                    fetchedSneakers.fetchSneakers(styleId: styleId)
                }
                
                if fetchedSneakers.loadingState == .loaded {
                    if fetchedSneakers.sneakers.count <= 0 {
                        Text("No results.")
                            .padding()
                    }
                    
                    List(fetchedSneakers.sneakers) { sneaker in
                        Button(action: {
                            selectedSneaker = sneaker
                            showConfirmationAlert = true
                        }){
                            HStack{
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white)
                                        .frame(width: 100)
                                        .shadow(radius: 5)
                                        .padding()
                                    
                                    sneakerThumb(sneaker: sneaker)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 83, height: 60)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding()
                                }
                                
                                Spacer()
                                
                                VStack{
                                    Text(sneaker.title ?? "--")
                                        .font(.headline)
                                        .lineLimit(2)
                                        .padding()
                                        .layoutPriority(1)
                                    Text(sneaker.styleId ?? "--")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .padding()
                                }
                            }
                        }
                            .buttonStyle(PlainButtonStyle())
                            .disabled(!isSneakerAlreadyAdded(sneaker: sneaker))
                    }
                } else if fetchedSneakers.loadingState == .loading {
                    ProgressView()
                        .padding()
                } else {
                    Text("Please try again later.")
                        .padding()
                }
                
                Spacer()
            }
            .navigationTitle("Add sneaker")
            .alert(isPresented: $showConfirmationAlert) {
                Alert(title: Text("Are you sure?"), message: Text("Do you want to add \(selectedSneaker!.title ?? "--") to your collection?"), primaryButton: .default(Text("Add")) {
                    addSneaker()
                    presentationMode.wrappedValue.dismiss()
                }, secondaryButton: .cancel())
            }
        }
        .resignKeyboardOnDragGesture()
    }
    
    func sneakerThumb(sneaker: sneaker) -> Image {
        if let thumb = sneaker.media.thumb {
            return Image(thumb, scale: 1.0, label: Text(""))
        } else {
            return Image("placeholder")
        }
    }
    
    func addSneaker() {
        let newSneaker = Sneaker(context: self.moc)
        newSneaker.brand = selectedSneaker!.brand
        newSneaker.colorway = selectedSneaker!.colorway
        newSneaker.gender = selectedSneaker!.gender
        newSneaker.id = selectedSneaker!.id
        newSneaker.imageUrl = selectedSneaker!.media.imageUrl
        newSneaker.releaseDate = selectedSneaker!.releaseDate
        newSneaker.retailPrice = Int16(selectedSneaker!.retailPrice ?? 0)
        newSneaker.smallImageUrl = selectedSneaker!.media.smallImageUrl
        newSneaker.styleId = selectedSneaker!.styleId
        newSneaker.thumbUrl = selectedSneaker!.media.thumbUrl
        newSneaker.title = selectedSneaker!.title
        newSneaker.year = Int16(selectedSneaker!.year ?? 0)
        newSneaker.addedDate = Date()
        
        try? self.moc.save()
        
        addedSuccesfully()
        
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func isSneakerAlreadyAdded(sneaker: sneaker) -> Bool {
        let results = sneakers.filter { $0.id == sneaker.id }
        
        return results.isEmpty
    }
    
    func addedSuccesfully() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}
