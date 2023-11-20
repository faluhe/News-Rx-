//
//  Bookmark+infrastracture.swift
//  News
//
//  Created by Ismailov Farrukh on 29/09/23.
//

import Foundation
import RxSwift
import RxRelay

protocol BookmarkMuduleType {
    var moduleBindings: BookmarkViewModel.ModuleBindings { get }
    var moduleCommands: BookmarkViewModel.ModuleCommands { get }
}

protocol BookmarkViewModelType {
    var bindings: BookmarkViewModel.Bindings { get }
    var commands: BookmarkViewModel.Commands { get }
}


extension BookmarkViewModel{
    
    struct ModuleBindings {
        
    }
    
    struct ModuleCommands {
        let startDetails = BehaviorRelay<NewsSectionModel?>(value: nil)
    }
    
    
    struct Bindings {
        let sections = BehaviorRelay<[NewsSectionModel]>(value: [])
        let openDetailsScreen = BehaviorRelay<NewsSectionModel?>(value: nil)
    }
    
    struct Commands {
        let loadBookmarks = PublishRelay<Void>()
    }
    
    struct Dependencies {
        let bookmarkService: BookmarkService
    }
}
