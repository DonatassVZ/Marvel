//
//  CharactersView.swift
//  Marvel
//
//  Created by Vasiliy Munenko on 22.03.2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct CharactersView: View {
    
    @EnvironmentObject var homeData : HomeViewModel
    var body: some View {
        NavigationView{
        
            ScrollView(.vertical, showsIndicators: true, content: {
                
                VStack(spacing : 15){
                    
                    //search bar
                    HStack{
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search Character", text: $homeData.searchQuery)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                    .padding(.vertical , 10)
                    .padding(.horizontal)
                    .background(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: -5)
                }
                .padding()
                
                if let characters = homeData.fetchedCharacters{
                    
                    if characters.isEmpty {
                        //no result
                        Text("No Result Found")
                            .padding(.vertical , 20)
                    }
                    else{
                            //Display Result
                        ForEach(characters){ charItem in
                            
                           CharacterRowView(character: charItem)
                            
                        }
                    }
                }else{
                    if homeData.searchQuery != ""{
                        // load
                        ProgressView()
                            .padding(.vertical , 20)
                    }
                }
            })
        .navigationTitle("Marvel")
        }
    }
}

struct CharactersView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct CharacterRowView : View {
    var character : Character
    
    var body: some View{
        
        HStack(alignment: .top , spacing: 10){
            WebImage(url: extractImage(data: character.thumbnail))
                .resizable()
                .frame(width: 120, height: 120)
                .aspectRatio(contentMode: .fill)
                .cornerRadius(8)
                
            
            VStack(alignment : .center , spacing: 10){
                Text(character.name)
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text(character.description)
                    .font(.caption)
                    .fontWeight(.regular)
                    .foregroundColor(.gray)
                    .lineLimit(4)
                    .multilineTextAlignment(.leading)
                
                //nav links
                
                HStack(spacing: 10){
                    ForEach(character.urls,id: \.self) { (data) in
                        NavigationLink(
                            destination: WebView(url: extractUrl(data: data)),
                            label: {
                                Text(extractUrlType(data: data))
                            })
                    }
                }
            }
            Spacer(minLength: 0)
        }.padding()
    }
    
    func  extractImage(data :[ String : String]) -> URL {
        let path = data["path"] ?? ""
        let ext = data["extension"] ?? ""
        
        return URL(string: "\(path).\(ext)")!
    }
    
    func extractUrl (data: [String:String]) -> URL {
        let url = data["url"] ?? ""
        return URL(string: url)!
    }
    
    func extractUrlType(data : [String:String]) -> String {
        
        let type = data["type"] ?? ""
        
        return type.capitalized
        
    }
    
    
}
