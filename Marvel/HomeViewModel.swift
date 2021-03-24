//
//  HomeViewModel.swift
//  Marvel
//
//  Created by Vasiliy Munenko on 22.03.2021.
//

import SwiftUI
import Combine
import CryptoKit



class HomeViewModel: ObservableObject {
    
    @Published var searchQuery = ""
    
    // used to cansel search oublisher
    var searchCancellable : AnyCancellable? = nil
    
    //fetch data
    @Published var fetchedCharacters: [Character]? = nil
    
    //comic data
    @Published var fetchedComics : [Comic] = []
    @Published var offsetComics : Int = 0
    
    init() {
        searchCancellable = $searchQuery
            .removeDuplicates()
            .debounce(for: 0.6, scheduler: RunLoop.main)
            .sink(receiveValue: { (str) in
                if str == "" {
                    //reset data
                    self.fetchedCharacters  = nil
                }else{
                    //search data
                    print("Seach:  \(str)")
                    self.searchCharacter()
                    
                }
            })
    }
    
    
    func searchCharacter() {
        
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5(data: "\(ts)\(privateKey)\(publicKey)")
        
        let originalQuery = searchQuery.replacingOccurrences(of: " ", with: "%20")
        
        let url = "https://gateway.marvel.com:443/v1/public/characters?nameStartsWith=\(originalQuery)&ts=\(ts)&apikey=\(publicKey)&hash=\(hash)"
        
        print(url)
      //  let url = "https://gateway.marvel.com:443/v1/public/characters?name=Man&apikey=a54bccc516a31857f99a080114e00d79"
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: URL(string: url)!){ (data, _ , err) in
            
            
            
            if let error = err {
                print(error.localizedDescription , err.debugDescription)
                return
            }
            guard let apiData = data else{
                print("data not found")
                return
            }
            
             //see all
            let jsonString = String(data: apiData, encoding: .utf8)
            print(jsonString ?? "no-string")
            //
            do {
                //decoding API data
                
                let characters = try JSONDecoder().decode(APIResult.self, from: apiData)
               
                DispatchQueue.main.async {
                    if self.fetchedCharacters == nil {
                        self.fetchedCharacters = characters.data.results
                    }
                }
                
            }
            catch{
                print("errorDataTask" , error.localizedDescription)
            }
            
        }.resume()
    }
    
    
    func MD5(data : String) -> String {
        
        let hash = Insecure.MD5.hash(data: data.data(using: .utf8) ?? Data())
        return hash.map{
            String(format: "%02hhx", $0)
        }.joined()
    }
    
    
    func fetchComics() {
        
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5(data: "\(ts)\(privateKey)\(publicKey)")
        
        let url = "https://gateway.marvel.com:443/v1/public/comics?limit=20&offset=\(offsetComics)&ts=\(ts)&apikey=\(publicKey)&hash=\(hash)"
        
        print(url)
      //  let url = "https://gateway.marvel.com:443/v1/public/characters?name=Man&apikey=a54bccc516a31857f99a080114e00d79"
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: URL(string: url)!){ (data, _ , err) in
            
            
            
            if let error = err {
                print(error.localizedDescription , err.debugDescription)
                return
            }
            guard let apiData = data else{
                print("data not found")
                return
            }
            
             //see all
            let jsonString = String(data: apiData, encoding: .utf8)
            print(jsonString ?? "no-string")
            //
            do {
                //decoding API data
                
                let characters = try JSONDecoder().decode(APIComicResult.self, from: apiData)
               
                DispatchQueue.main.async {
                    
                    self.fetchedComics.append(contentsOf: characters.data.results)
                    
                }
                
            }
            catch{
                print("errorDataTask" , error.localizedDescription)
            }
            
        }.resume()
    }
}

struct HomeViewModel_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
