//
//  ViewController.swift
//  TestTaskMovies
//
//  Created by Natalia on 04.05.2022.
//

import UIKit

class MainViewController: UIViewController {

    var movies: [MovieModel]? {
        didSet { tableView.movies = movies }
    }

    lazy var tableView = MoviesTableView(viewDelegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupSubviews()
        loadData()
    }

    private func setupSubviews() {
        view.subviews(tableView)
        tableView.fillContainer()
    }

    private func loadData() {
        ApiManager.shared.getMovies { [weak self] movies in
            guard let self = self else { return }
            self.movies = movies
        } error: { error in
            return
        }
    }
}

extension MainViewController: MoviesTableViewDelegate {

}
