//
//  DatabaseDispatcher.swift
//  News
//
//  Created by Ismailov Farrukh on 14/08/23.
//
import RxSwift
import Foundation
import CoreData

protocol DatabaseDispatcherType {
    func request<T: Codable>(_ target: NetworkTargetType, type: T.Type) -> Single<T>
}

final class DatabaseDispatcher: DatabaseDispatcherType {
    
    func request<T>(_ target: NetworkTargetType, type: T.Type) -> RxSwift.Single<T> where T : Decodable, T : Encodable {
        return Single.create { [unowned self] single in
            switch target.requestMethod {
            case .get:
                getNews(target, type: type) { result in
                    single(result ?? .failure(ResponseError.unknownData))
                }
            }
            return Disposables.create()
        }
    }


    func getNews<T: Codable>(_ target: NetworkTargetType, type: T.Type, completion: @escaping (Result<T, Error>?) -> Void) {
        guard let url = URL(string: target.path) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
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
                completion(.failure(error))
            }
        }.resume()
    }
}
