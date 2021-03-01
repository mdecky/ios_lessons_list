//
//  CharacterQuote.swift
//  Books
//
//  Created by Erik Gadireddi on 28.02.2021.
//

import Foundation
import UIKit

final class CharacterQuotes: UITableViewController {
    let character: String
    var quotes: [QuotesRespones.Quote] = []
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    init(_ id: String) {
        self.character = id
        super.init(style: .grouped)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Quotes"  // changes title of navigation controller for method 2 you need parent UINavigationController
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let session = URLSession.shared
        
        // you need to sign up and fill this empty string
        // https://the-one-api.dev/sign-up
        let token = ""
        if token == "" {
            fatalError("token not initialized maybe you need to get one https://the-one-api.dev/sign-up")
        }
        let url = URL(string: "https://the-one-api.dev/v2/character/\(character)/quote")!
        
        // create get request with token
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                //print(String(decoding: data, as: UTF8.self))
                let responseObject = try JSONDecoder().decode(QuotesRespones.self, from: data)

                self.quotes = responseObject.docs

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
        return quotes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.text = quotes[indexPath.row].dialog
        return cell
    }
    
}

struct QuotesRespones:Decodable {
    struct Quote:Decodable {
        let id: String
        let dialog: String
        let movie: String
        let character: String
        
        enum CodingKeys: String, CodingKey{
            case id = "_id", dialog, movie, character
        }
    }
    let docs : [Quote]
}
