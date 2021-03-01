//
//  MainTableViewController.swift
//  Books
//
//  Created by Erik Gadireddi on 01.03.2021.
//

import Foundation
import UIKit

final class MainTableViewController: UITableViewController {
    var viewControllers: [UITableViewController] = [BookListViewController(style: .grouped),CharacterListViewController(style: .grouped),MovieListViewController(style: .grouped)]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Lord of the rings"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let option = Option(rawValue: indexPath.row) {
            cell.textLabel?.text = option.name()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(viewControllers[indexPath.row], animated: true)
    }
    
    
}

enum Option:Int
{
    case books, characters, movies

    func name() -> String {
        switch self {
        case .books:

                return "Books"

        case .characters:

                return "Characters"

        case .movies:
                return "Movies"
        }
    }
}
