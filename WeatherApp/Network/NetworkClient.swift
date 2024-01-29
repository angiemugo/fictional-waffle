//
//  DefaultNetworkClient.swift
//  WeatherApp
//
//  Created by Angie Mugo on 29/01/2024.
//

import Foundation

enum Network {
    typealias HTTPHeaders = [String: String]
    
    static let baseURL = URL(string: "https://api.openweathermap.org/data/2.5/")!
    
    enum HTTPMethod: String {
        case GET
    }
    
    enum Errors: Error {
        case HTTPError(code: Int)
        case genericError(Error)
    }
}

protocol NetworkClient: AnyObject {
    var headers: Network.HTTPHeaders { get }
    
    func get<R: Decodable>(_ url: URL, headers: Network.HTTPHeaders?, completed: @escaping (Result<R, WeatherClientError>) -> Void)
}

class DefaultNetworkClient: NetworkClient {
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    private let defaultHeaders: Network.HTTPHeaders
    
    init(_ apiToken: String? = nil) {
        encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(DateFormatter.iso8601Full)
        
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        
        var headers = [String:String]()
        if let apiToken = apiToken {
            headers["Authorization"] = "Bearer \(apiToken)"
        }
        defaultHeaders = headers
    }
    
    var headers: Network.HTTPHeaders {
        defaultHeaders
    }
    
    func get<R: Decodable>(_ url: URL, headers: Network.HTTPHeaders? = nil, completed: @escaping (Result<R, WeatherClientError>) -> Void) {
        let request = buildRequest(method: .GET, url: url, headers: headers)
        print(request.url?.absoluteURL ?? "")
        executeRequest(request: request, completed: completed)
    }
    
    private func initRequest(url: URL, headers: Network.HTTPHeaders? = [:]) -> URLRequest {
        let allHeaders = defaultHeaders.merging(headers ?? [:]) { (_, new) in
            new
        }
        var request = URLRequest(url: url)
        for item in allHeaders {
            request.setValue(item.value, forHTTPHeaderField: item.key)
        }
        
        return request
    }
    
    private func buildRequest(method: Network.HTTPMethod, url: URL, headers: Network.HTTPHeaders?) -> URLRequest {
        var request = initRequest(url: url, headers: headers)
        request.httpMethod = method.rawValue
        
        return request
    }
    
    private func executeRequest<T: Decodable>(request: URLRequest, completed: @escaping (Result<T, WeatherClientError>) -> Void
    ) {
        DebugEnvironment.log.debug("Request: \(request.httpMethod ?? "") \(request.url?.absoluteString ?? "")")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            var completeResult: Result<T, WeatherClientError>?
            
            if let error = NetworkClientHelpers.extractError(response: response, error: error) {
                completeResult = .failure(error)
            } else if let data = data {
                DebugEnvironment.log.trace(String(data: data, encoding: .utf8) ?? "")
                do {
                    DebugEnvironment.log.trace(String(data: data, encoding: .utf8) ?? "")
                    let result = try self.decoder.decode(T.self, from: data)
                    completeResult = .success(result)
                } catch let decodingError as Swift.DecodingError {
                    completeResult = .failure(.decodingError(decodingError))
                } catch {
                    completeResult = .failure(.genericError(error))
                }
            } else {
                completeResult = .failure(.unsupportedResponseError)
            }
            
            DispatchQueue.main.async {
                guard let completeResult = completeResult else {
                    fatalError("Something is wrong, no result!")
                }
                completed(completeResult)
            }
        }
        task.resume()
    }
    
}
