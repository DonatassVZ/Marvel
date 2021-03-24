//
//  ComicsView.swift
//  Marvel
//
//  Created by Vasiliy Munenko on 23.03.2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct ComicsView: View {
    
    @EnvironmentObject var homeData: HomeViewModel
    var body: some View {
        NavigationView{
            ScrollView(.vertical, showsIndicators: false, content: {
                if homeData.fetchedComics.isEmpty{
                    ProgressView()
                        .padding()
                }else{
                    //Display content
                    
                    VStack(spacing: 10){
                        ForEach(homeData.fetchedComics){ comic in
                            
                            ComicRowView(character: comic)
                        }
                    }.padding(.bottom)
                }
                
                //scrolling - fetch next
                
                if homeData.offsetComics == homeData.fetchedComics.count  && homeData.offsetComics != 0 {
                    ProgressView()
                        .padding(.vertical)
                        .onAppear(perform: {
                            print("fetch comics new")
                            homeData.fetchComics()
                        })
                }else {
                
                    GeometryReader{ reader -> Color in
                        let minY = reader.frame(in: .global).minY
                        
                        let height = UIScreen.main.bounds.height / 1.3
                        
                        if !homeData.fetchedComics.isEmpty && minY < height {
                            DispatchQueue.main.async {
                                homeData.offsetComics = homeData.fetchedComics.count
                            }
                        }
                        
                        return Color.clear
                    }.frame(width: 20, height: 20, alignment: .center)
                }
                
            }).navigationTitle("Marvel comics")
        } //load data
        .onAppear(perform: {
            if homeData.fetchedComics.isEmpty{
                  homeData.fetchComics()
            }
        })
    }
}

struct ComicsView_Previews: PreviewProvider {
    static var previews: some View {
        ComicsView()
    }
}


struct ComicRowView : View {
    var character : Comic
    
    var body: some View {
        
        HStack(alignment: .top , spacing: 10){
            WebImage(url: extractImage(data: character.thumbnail))
                .resizable()
                .frame(width: 120, height: 120)
                .aspectRatio(contentMode: .fill)
                .cornerRadius(8)
                
            
            VStack(alignment : .center , spacing: 10){
                HStack{
                    Text(character.title)
                    .font(.title3)
                    .fontWeight(.bold)
                    
                    Text("\(character.id)")
                        .font(.caption2)
                }
                
                if let description = character.description{
                Text(description)
                    .font(.caption)
                    .fontWeight(.regular)
                    .foregroundColor(.gray)
                    .lineLimit(4)
                    .multilineTextAlignment(.leading)
                }
                
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
