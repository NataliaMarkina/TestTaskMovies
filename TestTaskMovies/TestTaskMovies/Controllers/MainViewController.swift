//
//  ViewController.swift
//  TestTaskMovies
//
//  Created by Natalia on 04.05.2022.
//

import UIKit
import CoreData

class MainViewController: UIViewController {

    var searchedMovies: [Movie]? {
        didSet { tableView.searchedMovies = searchedMovies }
    }

    lazy var tableView = MoviesTableView(viewDelegate: self)

    lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.delegate = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Название фильма"
        definesPresentationContext = true
        return search
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.searchController = searchController
        setupSubviews()
        loadData()
    }

    private func setupSubviews() {
        view.subviews(tableView)
        tableView.fillContainer()
    }

    private func loadData() {
        do {
            try tableView.fetchedhResultController.performFetch()
        } catch let error  {
            print("ERROR: \(error)")
        }

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
            movieEntity.episodeId = Int32(movieModel.episodeId)
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
        } catch let error {
            print(error)
        }
    }
}

extension MainViewController: MoviesTableViewDelegate {

}

extension MainViewController: UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }

        if !searchText.isEmpty {
            var predicate: NSPredicate = NSPredicate()
            predicate = NSPredicate(format: "title contains[c] '\(searchText)'")
            let managedObjectContext = CoreDataStack.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Movie")
            fetchRequest.predicate = predicate
            do {
                searchedMovies = try managedObjectContext.fetch(fetchRequest) as? [Movie]
            } catch let error as NSError {
                print("Could not fetch. \(error)")
            }
        } else {
            searchedMovies = nil
        }
    }
}
