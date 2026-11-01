//
//  CoinImageView.swift
//  Crypto
//
//  Created by Antonio Damjanović on 01.11.2026..
//

import SwiftUI

struct CoinImageView: View {
    let url: URL?
    
    init(url: URL?) {
        self.url = url
    }
    
    init(url: String) {
        self.url = URL(string: url)
    }
    
    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
                case .empty:
                    Color(.gray)
                        .overlay {
                            ProgressView()
                        }
                    
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                    
                case .failure(_):
                    Text("Could not load image")
                    
                @unknown default:
                    fatalError()
            }
        }
    }
}

#Preview {
    CoinImageView(url: Coin.example.image)
}
