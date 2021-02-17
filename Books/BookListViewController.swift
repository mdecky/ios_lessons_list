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

        let session = URLSession.shared

        let dataTask = session.dataTask(with: URL(string: "https://the-one-api.dev/v2/book/")!) { (data, response, error) in
            guard let data = data else { return }
            do {
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
        let cell = UITableViewCell()
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

final class BookListViewModel {
    let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func loadData(completion: @escaping ([String]) -> Void) {
        let dataTask = session.dataTask(with: URL(string: "https://the-one-api.dev/v2/book/")!) { (data, response, error) in
            guard let data = data else { return }
            do {
                let responseObject = try JSONDecoder().decode(BookResponse.self, from: data)
                completion(responseObject.docs.map({$0.name}))
            } catch {
                print(error)
            }
        }
        dataTask.resume()
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
