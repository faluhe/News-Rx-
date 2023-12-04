//
//  Observable+Operators.swift
//  News
//
//  Created by Ismailov Farrukh on 04/12/23.
//
import RxSwift
import RxCocoa

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
