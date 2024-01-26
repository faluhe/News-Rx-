//
//  DatabaseDispatcher.swift
//  News
//
//  Created by Ismailov Farrukh on 14/08/23.
//
import Foundation
import RxSwift
import CoreData

protocol NetworkDispatcherType {
    func request<T: Codable>(_ target: NetworkTargetType, type: T.Type) -> Single<T>
}

final class NetworkDispatcher: NetworkDispatcherType {

    func request<T>(_ target: NetworkTargetType, type: T.Type) -> RxSwift.Single<T> where T : Decodable, T : Encodable {
        return Single.create { [unowned self] single in

            switch target.requestMethod {
            case .get:
                getData(target, type: type) { result in
                    single(result ?? .failure(ResponseError.unknownData))
                }
            }
            return Disposables.create()
        }
    }


    private func getData<T: Codable>(_ target: NetworkTargetType, type: T.Type, completion: @escaping (Result<T, Error>?) -> Void) {
        guard let url = URL(string: target.path) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(NetworkError.networkError))
                return
            }

            guard let data = data else {
                completion(.failure(ResponseError.noData))
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(ResponseError.parsingError))
            }
        }.resume()
    }
}
