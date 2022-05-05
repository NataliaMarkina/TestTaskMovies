//
//  ViewController.swift
//  TestTaskMovies
//
//  Created by Natalia on 04.05.2022.
//

import UIKit
import CoreData

class MainViewController: UIViewController {

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
        if isEmptySavedData() {
            ApiManager.shared.getMovies { [weak self] movies in
                guard let self = self else { return }
                self.saveInCoreData(movies: movies)
            } error: { error in
                return
            }
        }
    }

    private func isEmptySavedData() -> Bool {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        let fetchRequest = Movie.fetchRequest()
        let objects = try? context.fetch(fetchRequest)
        return objects?.isEmpty ?? true
    }

    private func createMovieEntity(movieModel: MovieModel) -> NSManagedObject? {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let movieEntity = NSEntityDescription.insertNewObject(forEntityName: "Movie", into: context) as? Movie {
            movieEntity.title = movieModel.title

            if let id = movieModel.episodeId {
                movieEntity.episodeId = Int32(id)
            }

            movieEntity.openingCrawl = movieModel.openingCrawl
            movieEntity.director = movieModel.director
            movieEntity.producer = movieModel.producer
            movieEntity.releaseDate = movieModel.releaseDate
            movieEntity.characters = movieModel.characters
            movieEntity.planets = movieModel.planets
            movieEntity.starships = movieModel.starships
            movieEntity.vehicles = movieModel.vehicles
            movieEntity.species = movieModel.species
            movieEntity.created = movieModel.created
            movieEntity.edited = movieModel.edited
            movieEntity.url = movieModel.url
            return movieEntity
        }
        return nil
    }

    private func saveInCoreData(movies: [MovieModel]?) {
        guard let movies = movies else { return }
        _ = movies.map { createMovieEntity(movieModel: $0) }

        do {
            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
            tableView.reloadData()
        } catch let error {
            print(error)
        }
    }
}

extension MainViewController: MoviesTableViewDelegate {

}
