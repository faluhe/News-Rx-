//
//  HomeCoordinator.swift
//  News
//
//  Created by Ismailov Farrukh on 09/08/23.
//

import UIKit
import RxRelay
import RxSwift

class HomeCoordinator: Coordinator {

    typealias Container = UINavigationController
    var container = UINavigationController()

    let bag = DisposeBag()

    struct Input {
        let updatedata = PublishRelay<Void>()
        let detailsModel = BehaviorRelay<NewsSectionModel?>(value: nil)
    }

    let input = Input()

    func start() {
        configure()
    }

    func configure() {
        let module = HomeModuleConfigurator.configure()
//        input.updatedata
//            .bind(to: module.viewModel.moduleBindings.updateData)
//            .disposed(by: bag)


        module.viewModel.moduleCommands.startDetails
            .filterNil()
            .do(onNext: { value in
            self.input.detailsModel.accept(value)
        }).bind(to: Binder<NewsSectionModel?>(self) { target, _ in
         target.startDetailsScreen()
        }).disposed(by: bag)

        container.setViewControllers([module.view], animated: true)
    }


    func startDetailsScreen() {
        let module = DetailsModuleConfiguraotor.configure()
        input.detailsModel.bind(to: module.viewModel.moduleBindings.detailsModel).disposed(by: bag)
        container.pushViewController(module.view, animated: true)
    }
}



protocol OptionalType {
    associatedtype Wrapped

    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    var value: Wrapped? {
        return self
    }
}

extension ObservableType where Element: OptionalType {
    func filterNil() -> Observable<Element.Wrapped> {
        return flatMap { (element) -> Observable<Element.Wrapped> in
            if let value = element.value {
                return .just(value)
            } else {
                return .empty()
            }
        }
    }

    func replaceNilWith(_ nilValue: Element.Wrapped) -> Observable<Element.Wrapped> {
        return flatMap { (element) -> Observable<Element.Wrapped> in
            if let value = element.value {
                return .just(value)
            } else {
                return .just(nilValue)
            }
        }
    }
}

extension ObservableType {

    func mapToVoid() -> Observable<Void> {
        return map({ _ in Void() })
    }

}

extension PrimitiveSequence where Trait == SingleTrait, Element: Any {

    func mapToVoid() -> Single<Void> {
        return map({ _ in Void() })
    }

}

extension ObservableType {

    func withPrevious() -> Observable<(Element?, Element)> {
        return scan([], accumulator: { (previous, current) in
            Array(previous + [current]).suffix(2)
        })
        .map({ (arr) -> (previous: Element?, current: Element) in
            (arr.count > 1 ? arr.first : nil, arr.last ?? arr[0])
        })
    }

}
