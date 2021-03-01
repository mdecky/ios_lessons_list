//
//  CharacterListViewController.swift
//  Books
//
//  Created by Erik Gadireddi on 27.02.2021.
//

import Foundation
import UIKit

final class CharacterListViewController: UITableViewController {
    var characters: [CharacterResponse.Person] = []
    override init(style: UITableView.Style) {
        super.init(style: style)
        self.title = "Characters"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let session = URLSession.shared
        
        // you need to sign up and fill this empty string
        // https://the-one-api.dev/sign-up
        let token = ""
        if token == "" {
        fatalError("token not initialized maybe you need to get one https://the-one-api.dev/sign-up")
        }
        let url = URL(string: "https://the-one-api.dev/v2/character")!
        
        // create get request with token
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
//                print(String(decoding: data, as: UTF8.self))
                let responseObject = try JSONDecoder().decode(CharacterResponse.self, from: data)

                self.characters = responseObject.docs.filter{
                    self.isKnown($0.name)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print(error)
            }
        }
        dataTask.resume()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Reuse or create a cell.
        //let cell = UITableViewCell()
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = characters[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let character = characters[indexPath.row].id
        let viewController = CharacterQuotes(character)
        // first method
        //navigationController?.pushViewController(viewController, animated: true)
        
        // second method
        let nc = UINavigationController(rootViewController: viewController)
        present(nc , animated: true, completion: nil)

    }
    
    private func isKnown(_ name: String) -> Bool {
        let famousCharacters = ["Bofur", "Boromir", "Frodo Baggins", "Gandalf","Galandriel","Gimli","Bilbo Baggins","Saruman", "Legolas","Aragorn II. Elessar"]
        return famousCharacters.contains(name)
    }
    
}
/*
 example 
_id":"5cdbdecb6dc0baeae48cfac6",
 "death":"NaN",
 "birth":"NaN",
 "hair":"NaN",
 "realm":"NaN",
 "height":"NaN",
 "spouse":"Unnamed Wife",
 "gender":"Male", -- seems to be optional
 "name":"Galathil",
 "race":"Elves"}
 */
struct CharacterResponse: Decodable {
    struct Person: Decodable {
        let id: String
        let death: String?
        let birth: String?
        let hair: String
        let realm: String?
        let height: String?
        let spouse: String?
        let gender: String?
        let name: String
        let race: String?
      
        
        enum CodingKeys: String, CodingKey {
               case id = "_id", death, birth, hair,realm, height, spouse, gender, name,race
           }
        
    }
    
    let docs: [Person]
}
