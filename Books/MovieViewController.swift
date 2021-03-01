//
//  MovieViewController.swift
//  Books
//
//  Created by Erik Gadireddi on 28.02.2021.
//

import Foundation
import UIKit

final class MovieListViewController: UITableViewController {
    var movies: [Movie] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Movies"
        let session = URLSession.shared
        
        // you need to sign up and fill this empty string
        // https://the-one-api.dev/sign-up
        let token = ""
        if token == "" {
        fatalError("token not initialized maybe you need to get one https://the-one-api.dev/sign-up")
        }
        let url = URL(string: "https://the-one-api.dev/v2/movie/")!
        
        // create get request with token
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                print(String(decoding: data, as: UTF8.self))
                let responseObject = try JSONDecoder().decode(MovieResponse.self, from: data)
                self.movies = responseObject.movies

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
        return movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = movies[indexPath.row].name
        return cell
    }
    
}

//"docs":[{"_id":"5cd95395de30eff6ebccde56","name":"The Lord of the Rings Series","runtimeInMinutes":558,"budgetInMillions":281,"boxOfficeRevenueInMillions":2917,"academyAwardNominations":30,"academyAwardWins":17,"rottenTomatesScore":94}

struct MovieResponse: Decodable {
    
    let movies: [Movie]
    
    enum CodingKeys: String, CodingKey{
        case movies = "docs"
    }
    
}
struct Movie: Decodable {
    let id: String
    let name: String
    let runtimeInMinutes: Int
    let budgetInMillions: Double
    let academyAwardNominations: Int
    let boxOfficeRevenueInMillions: Double
    let academyAwardWins: Int
    let rottenTomatesScore: Double
    enum CodingKeys: String, CodingKey{
        case id = "_id", name,runtimeInMinutes,budgetInMillions,boxOfficeRevenueInMillions, academyAwardNominations, academyAwardWins, rottenTomatesScore
    }
}
