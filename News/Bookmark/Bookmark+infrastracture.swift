//
//  Bookmark+infrastracture.swift
//  News
//
//  Created by Ismailov Farrukh on 29/09/23.
//

import Foundation

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

    }


    struct Bindings {

    }

    struct Commands {

    }

    struct Dependencies {
        let bookmarkService: BookmarkService
    }
}
