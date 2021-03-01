//
//  BookListViewController.swift
//  Books
//
//  Created by Matěj Děcký on 17/02/2021.
//

import Foundation
import UIKit

final class BookListViewController: UITableViewController {

    var bookInfos: [BookResponse.BookInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Books"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        let session = URLSession.shared

        let dataTask = session.dataTask(with: URL(string: "https://the-one-api.dev/v2/book/")!) { (data, response, error) in
            guard let data = data else { return }
            do {
           //     print(String(decoding: data, as: UTF8.self))
                let responseObject = try JSONDecoder().decode(BookResponse.self, from: data)
                self.bookInfos = responseObject.docs
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
        return bookInfos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = bookInfos[indexPath.row].name
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let bookInfo = bookInfos[indexPath.row]
        let viewController = ChapterListViewController(bookInfo: bookInfo)
        present(viewController, animated: true, completion: nil)
//        navigationController?.pushViewController(viewController, animated: true)
    }
}

struct BookResponse: Decodable {
    struct BookInfo: Decodable {
        let id: String
        let name: String

        enum CodingKeys: String, CodingKey {
            case id = "_id", name
        }
    }

    let docs: [BookInfo]
}
