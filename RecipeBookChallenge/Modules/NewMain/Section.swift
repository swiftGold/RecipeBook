//
//  Section.swift
//  RecipeBookChallenge
//
//  Created by Сергей Золотухин on 20.03.2023.
//

struct Section {
    let type: SectionType
    let rows: [RowType]
}

//TODO: - remove ...Section
enum SectionType {
    case trendingSection(headerModel: HeaderViewModel)
    case savedRecipeSection(headerModel: HeaderViewModel)
}

//TODO: - remove ...Row
enum RowType {
    case trendingRow(viewModel: TrendingTVCellViewModel)
    case savedRecipeRow(viewModel: SavedRecipeTVCellViewModel)
}
