//
//  SearchedSneakersModel.swift
//  SneakerStats
//
//  Created by Kuba Florek on 03/07/2020.
//

import SwiftUI

enum LoadingState{
    case loading, loaded, failed
}

class SearchedSneakersModel: ObservableObject, FetchableImage {
    @Published var loadingState = LoadingState.loaded
    
    @Published var sneakers = [sneaker]()
    
    func fetchSneakers(styleId: String) {
        loadingState = .loading
        
        let urlString = "https://api.thesneakerdatabase.com/v1/sneakers?limit=20&styleId=\(styleId)"

        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                // we got some data back!
                let decoder = JSONDecoder()

                if let items = try? decoder.decode(Result.self, from: data) {
                    // success – convert the array values to our pages array
                    DispatchQueue.main.async {
                        self.sneakers = Array(items.results)
                        self.loadingState = .loaded
                        self.fetchThumbs()
                    }
                    return
                }
            }
            // if we're still here it means the request failed somehow
            DispatchQueue.main.async {
                self.loadingState = .failed
            }
        }.resume()
    }
    
    func fetchThumbs() {
        var allthumbsURLs = [String]()
        
        for sneaker in sneakers {
            allthumbsURLs.append(sneaker.media.thumbUrl ?? "")
        }
        
        var opt = FetchableImageOptions()
        opt.allowLocalStorage = false
        
        fetchBatchImages(using: allthumbsURLs, options: opt, partialFetchHandler: { (imageData, index) in
         
                DispatchQueue.main.async {
                    guard let data = imageData else { return }
                    self.appendNewThumb(index: index, cgImage: (UIImage(data: data)?.cgImage))
                }
            }) {
        }
    }
    
    func appendNewThumb(index: Int, cgImage: CGImage?) {
        if sneakers.count >= index {
            sneakers[index].media.thumb = cgImage
        }
    }
}
