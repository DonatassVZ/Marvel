//
//  HomeView.swift
//  Marvel
//
//  Created by Vasiliy Munenko on 22.03.2021.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var homeData = HomeViewModel()
    var body: some View {
       
        TabView{
            
            
            CharactersView()
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Characters")
                }
                .environmentObject(homeData)
            
            ComicsView()
                .tabItem {
                    Image(systemName: "books.vertical.fill")
                    Text("Comics")
                }
                .environmentObject(homeData)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
