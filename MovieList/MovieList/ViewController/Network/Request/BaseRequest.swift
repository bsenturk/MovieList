//
//  BaseRequest.swift
//  MovieList
//
//  Created by Burak Şentürk on 16.10.2019.
//  Copyright © 2019 Burak Şentürk. All rights reserved.
//

import Foundation
class BaseRequest {

    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }

    static func request<S: Decodable>(path: String,
                                      method: HTTPMethod,
                                      baseUrl: String = EndPoints.baseUrl,
                                      urlParameters: [String: String],
                                      succeed: @escaping (S) -> Void) {
        guard var components = URLComponents(string: baseUrl + path) else { return }

        components.queryItems = urlParameters.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        guard let url = components.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        print("---------\(url)-------------")

        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in

            if let error = error {
                print(error)
            }

            if let status = response as? HTTPURLResponse {
                if status.statusCode == 200 {
                    do {
                        guard
                            let data = data,
                            let decoder = try? JSONDecoder().decode(S.self, from: data) else { return }

                        DispatchQueue.main.async {
                            succeed(decoder)

                        }
                    }
                }
            }

        }).resume()

    }
}
