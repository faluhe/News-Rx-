//
//  DetailsViewModel.swift
//  News
//
//  Created by Ismailov Farrukh on 21/08/23.
//

import UIKit
import RxSwift
import RxRelay

final class DetailsViewModel: DetailsModuleType, DetailsViewModelType {

    private let bag = DisposeBag()

    // MARK: - Dependencies
    let dependencies: Dependencies

    // MARK: - Module infrastructure
    let moduleBindings = ModuleBindings()
    let moduleCommands = ModuleCommands()

    // MARK: - ViewModel infrastructure
    let bindings = Bindings()
    let commands = Commands()

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        self.configure(dependencies: dependencies)
        self.configure(moduleCommands: moduleCommands)
        configure(commands: commands)
        configure(bindings: bindings)
        configure(moduleBindings: moduleBindings)
    }

    func configure(dependencies: Dependencies) {

    }

    func configure(moduleCommands: ModuleCommands) {

    }

    func configure(bindings: Bindings) {
        bindings.title.bind(to: Binder<String>(self) { target, value in
            print(value)
            let articleExist = target.dependencies.coreDataManager.doesEntityExist(BookmarkEntity.self, withTitle: value)
            bindings.isBookmarked.accept(articleExist)
        }).disposed(by: bag)
    }

    func configure(commands: Commands) {
        commands.addToBookmarks.bind(to: Binder<Void>(self) { target, _ in
            guard let detailsModel = self.bindings.detailsModel.value else {
                // Handle the case where detailsModel doesn't conform to ConvertibleToEntity
                print("Error: detailsModel does not conform to ConvertibleToEntity")
                return
            } 

            if target.bindings.isBookmarked.value {
                self.dependencies.coreDataManager.deleteEntity(detailsModel)
                print("delete")
            }else {
                self.dependencies.coreDataManager.saveEntity(detailsModel)
                print("save")
            }
        }).disposed(by: bag)

    }

    func configure(moduleBindings: ModuleBindings) {
        moduleBindings.detailsModel.bind(to: bindings.detailsModel).disposed(by: bag)
//
//        bindings.detailsModel.subscribe(onNext: { [weak self] model in
//            print("FIRST _\(model?.toEntity(context: (self?.dependencies.coreDataManager.persistentContainer.viewContext)!))")
//        }).disposed(by: bag)
    }


}



//<BookmarkEntity: 0x6000032ee440> (entity: BookmarkEntity; id: 0x6000011d5bc0 <x-coredata:///BookmarkEntity/tB9AEDEE5-FE66-46EE-8CAB-AC3ED0D3708743>; data: {
//    desc = "Republican Rep. Jim Jordan again failed to win the House speaker\U2019s gavel in a second vote on Wednesday, drawing less support than in an initial vote the day before. The loss raises serious questions o";
//    title = "Jim Jordan loses second vote for House speaker amid steep GOP opposition - CNN";
//    url = "https://www.cnn.com/2023/10/18/politics/jim-jordan-speaker-bid/index.html";
//    urlToImage = "https://media.cnn.com/api/v1/images/stellar/prod/231018123438-03-house-speaker-race-101823.jpg?c=16x9&q=w_800,c_fill";
//})
//
//
//<BookmarkEntity: 0x60000326d130> (entity: BookmarkEntity; id: 0x60000115b420 <x-coredata:///BookmarkEntity/tB9AEDEE5-FE66-46EE-8CAB-AC3ED0D3708744>; data: {
//    desc = "Republican Rep. Jim Jordan again failed to win the House speaker\U2019s gavel in a second vote on Wednesday, drawing less support than in an initial vote the day before. The loss raises serious questions o";
//    title = "Jim Jordan loses second vote for House speaker amid steep GOP opposition - CNN";
//    url = "https://www.cnn.com/2023/10/18/politics/jim-jordan-speaker-bid/index.html";
//    urlToImage = "https://media.cnn.com/api/v1/images/stellar/prod/231018123438-03-house-speaker-race-101823.jpg?c=16x9&q=w_800,c_fill";
//})
