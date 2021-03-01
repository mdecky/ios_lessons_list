//
//  ChapterListViewController.swift
//  Books
//
//  Created by Matěj Děcký on 17/02/2021.
//

import UIKit

final class ChapterListViewController: UITableViewController {
    let bookInfo: BookResponse.BookInfo
    var chapters: [BookChapterResponse.ChapterInfo] = []

    init(bookInfo: BookResponse.BookInfo) {
        self.bookInfo = bookInfo
        super.init(style: .grouped)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let session = URLSession.shared
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        let dataTask = session.dataTask(with: URL(string: "https://the-one-api.dev/v2/book/\(bookInfo.id)/chapter")!) { (data, response, error) in
            guard let data = data else { return }
            do {
                let responseObject = try JSONDecoder().decode(BookChapterResponse.self, from: data)
                self.chapters = responseObject.docs
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
        return chapters.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = chapters[indexPath.row].chapterName
        return cell
    }
}

struct BookChapterResponse: Decodable {
    struct ChapterInfo: Decodable {
        let id: String
        let chapterName: String

        enum CodingKeys: String, CodingKey {
            case id = "_id", chapterName
        }
    }

    let docs: [ChapterInfo]
}
