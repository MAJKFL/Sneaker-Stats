//
//  ContentView.swift
//  SneakerStats-withCoreData
//
//  Created by Kuba Florek on 05/07/2020.
//

import SwiftUI
import CoreData

struct ContentView: View, FetchableImage {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Sneaker.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Sneaker.totalWalkTime, ascending: true),
        NSSortDescriptor(keyPath: \Sneaker.addedDate, ascending: true)
    ]) var sneakers: FetchedResults<Sneaker>
    
    @State private var showAddView = false
    @State private var showDeletingConfirmation = false
    
    @State private var selectedSneaker: Sneaker?
    
    @State private var images = [Image]()
    
    let layout = Array(repeating: GridItem(.flexible()), count: 2)
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                LazyVGrid(columns: layout, spacing: 20) {
                    ForEach(sneakers, id: \.self) { sneaker in
                        NavigationLink(destination: DetailedView(sneaker: sneaker)) {
                            ZStack{
                                // Background
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                                    .shadow(radius: 10)
                                
                                // Image
                                if images.count == sneakers.count {
                                    images[sneakers.firstIndex(where: { $0 === sneaker }) ?? 1 ]
                                        .resizable()
                                        .scaledToFit()
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding()
                                } else {
                                    Image("placeholder")
                                        .resizable()
                                        .scaledToFit()
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding()
                                }
                            }
                            .contextMenu {
                                Button(action: {
                                    showDeletingConfirmation = true
                                    selectedSneaker = sneaker
                                }) {
                                    Text("Delete this sneaker")
                                    Image(systemName: "trash")
                                }
                            }
                        }
                        .padding(.horizontal)
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    // Add button
                    Button(action: {
                        showAddView = true
                    }){
                        ZStack {
                            Image("placeholder")
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding()
                                .opacity(0)
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .shadow(radius: 10)
                            
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(Color("AddButton"))
                        }
                    }
                        .padding(.horizontal)
                        .buttonStyle(PlainButtonStyle())
                }
                .animation(.easeIn)
            }
            .navigationTitle("Collection")
            .sheet(isPresented: $showAddView, onDismiss: fetchImages) {
                AddView().environment(\.managedObjectContext, moc)
            }
            .alert(isPresented: $showDeletingConfirmation) {
                Alert(title: Text("Delete sneaker"), message: Text("Are you sure?"), primaryButton:
                    .destructive(Text("Delete")) {
                        deleteSneaker()
                    }, secondaryButton: .cancel())
            }
            .onAppear {
                fetchImages()
            }
        }
    }
    
    func fetchImages() {
        images = [Image]()
        
        var allthumbsURLs = [String]()
        
        for sneaker in sneakers {
            allthumbsURLs.append(sneaker.imageUrl ?? "https://stockx.imgix.net")
        }
        
        fetchBatchImages(using: allthumbsURLs, partialFetchHandler: { (imageData, index) in
                DispatchQueue.main.async {
                    guard let data = imageData else { return }
                    
                    if let image = UIImage(data: data)?.cgImage {
                        images.append(Image(image, scale: 1.0, label: Text("")))
                    } else {
                        images.append(Image("placeholder"))
                    }
                }
            }) {
                print("Finished fetching sneakers!")
        }
    }
    
    func deleteSneaker() {
        print("Deleting sneaker...")
        
        let imageUrls: [String] = [
            selectedSneaker!.imageUrl ?? "https://stockx.imgix.net",
            selectedSneaker!.smallImageUrl ?? "https://stockx.imgix.net",
            selectedSneaker!.thumbUrl ?? "https://stockx.imgix.net"
        ]
        
        deleteBatchImages(using: imageUrls)
        
        moc.delete(selectedSneaker!)
        try? moc.save()
        
        fetchImages()
    }
}

