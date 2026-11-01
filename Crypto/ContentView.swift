// xcode: set sdk=iOS

//
//  ContentView.swift
//  Crypto
//
//  Created by Antonio Damjanović on 28.10.2026..
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                CoinListView()
            }
            .tabItem { Label("Market", systemImage: "chart.line.uptrend.xyaxis") }
            
            NavigationStack {
                FavoritesView()
            }
            .tabItem { Label("Favorites", systemImage: "heart") }
            
            NavigationStack {
                ProfileView()
            }
            .tabItem { Label("Profile", systemImage: "person") }
        }
    }
}

#Preview {
    ContentView()
}
