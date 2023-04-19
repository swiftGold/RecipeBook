//
//  MainPresenter.swift
//  RecipeBookChallenge
//
//  Created by Сергей Золотухин on 20.03.2023.
//

protocol MainPresenterProtocol {
    func viewDidLoad()
}

final class MainPresenter {
    weak var viewController: NewMainViewControllerProtocol?
    
    private let apiService: APIServiceProtocol
    private let userDefaultsManager: UserDefaultsManagerProtocol
    private var recipes: [ResponseModel] = []
    private var savedRecipes: [ResponseModel] = []
    private var idsArray: [Int] = []
    
    init(apiService: APIServiceProtocol,
         userDefaultsManager: UserDefaultsManagerProtocol
    ) {
        self.apiService = apiService
        self.userDefaultsManager = userDefaultsManager
    }
}

extension MainPresenter: MainPresenterProtocol {
    func viewDidLoad() {
       updateTableView()
    }
}

extension MainPresenter: TrendingTableViewCellDelegate {
    func didTapTrendRecipeCVCell(with index: Int) {
        let id = idsArray[index]
        viewController?.routeToDetailVC(with: id)
    }
    
    func didTapSaveRecipe(with id: Int) {
        userDefaultsManager.setUserDefaults(with: id)
        updateTableView()
    }
    
    func didTapMoreInfoButton(with id: Int) {
        viewController?.routeToMoreInfoVC(with: id)
    }
}

private extension MainPresenter {
    func makeTrendsSection() -> Section {
        let headerModel = HeaderViewModel(title: "Trending now 🔥", action: didTapTrendsHeaderButton)

        let rows = recipes.map { item -> TrendViewModel in
            TrendViewModel(
                aggregateLikes: item.aggregateLikes,
                id: item.id,
                title: item.title,
                readyInMinutes: item.readyInMinutes,
                image: item.image,
                dishTypes: item.dishTypes,
                isSaved: false
            )
        }
        let viewModel = TrendingTVCellViewModel(recipes: rows, delegate: self)
        let row = RowType.trendingRow(viewModel: viewModel)
        return Section(type: .trendingSection(headerModel: headerModel), rows: [row])
    }
    
    func makeSavedSection() -> Section {
        
        let headerModel = HeaderViewModel(title: "Saved recipe", action: didTapSavedHeaderButton)
        
        let rows = savedRecipes.map { item -> SavedViewModel in
            SavedViewModel(id: item.id,
                           title: item.title,
                           image: item.image
            )
        }
        
        let viewModel = SavedRecipeTVCellViewModel(recipes: rows)
        let row = RowType.savedRecipeRow(viewModel: viewModel)
        
        return Section(type: .savedRecipeSection(headerModel: headerModel), rows: [row])
    }
    
    func makeSections() {
        let sections: [Section] = [
            makeTrendsSection(), makeSavedSection()
        ]
        viewController?.updateTable(sections: sections)
    }
 
    func didTapTrendsHeaderButton() {
        print(#function)
    }
    
    func didTapSavedHeaderButton() {
        print(#function)
    }

    func updateTableView() {
        Task {
            do {
                let singleString = userDefaultsManager.getData()
                let trendsResponse = try await apiService.fetchTrends()
                idsArray = trendsResponse.results.map { $0.id }
                let string = trendsResponse.results.map { "\($0.id)" }.joined(separator: ",")
                recipes = try await apiService.fetchManyIds(with: string)
                let saved = try await apiService.fetchManyIds(with: singleString)
                savedRecipes = reverseArray(with: saved)
                await MainActor.run {
                    makeSections()
                }
            } catch {
                await MainActor.run {
                    print(error, error.localizedDescription)
                }
            }
        }
    }
    
    func reverseArray(with array: [ResponseModel]) -> [ResponseModel] {
        var reversedArray = [ResponseModel]()
        for value in array.reversed() {
            reversedArray += [value]
        }
        return reversedArray
    }
}
