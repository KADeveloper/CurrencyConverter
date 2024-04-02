//
//  NetworkingService.swift
//  Currency Converter
//
//  Created by Aleksei Kudriashov on 3/30/24.
//

import Foundation

protocol Networking: AnyObject {
    func loadCurrencies() async throws -> CurrencyListResponse
    func loadExchangeRate(for currency: String) async throws -> CurrencyExchangeDataResponse
}

final class HTTPClient: Networking {
    private let session: URLSession

    init() {
        self.session = URLSession.shared
    }

    func loadCurrencies() async throws -> CurrencyListResponse {
        var components = URLComponents(string: "https://api.freecurrencyapi.com/v1/currencies")!
        components.queryItems = [
            URLQueryItem(name: "currencies", value: Constants.availableCurrencies.map({ $0.rawValue }).joined(separator: ","))
        ]

        var urlRequest = URLRequest(url: components.url!)

        urlRequest.httpMethod = "GET"
        urlRequest.setValue("fca_live_2fnOzNdwJEMXhK7e0vAqo2YrQsyAWOepjHOlwBaR", forHTTPHeaderField: "apikey")

        return try await load(urlRequest: urlRequest)
    }

    func loadExchangeRate(for currency: String) async throws -> CurrencyExchangeDataResponse {
        var components = URLComponents(string: "https://api.freecurrencyapi.com/v1/latest")!
        components.queryItems = [
            URLQueryItem(name: "base_currency", value: currency),
            URLQueryItem(name: "currencies", value: Constants.availableCurrencies.map({ $0.rawValue }).joined(separator: ","))
        ]

        var urlRequest = URLRequest(url: components.url!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("fca_live_2fnOzNdwJEMXhK7e0vAqo2YrQsyAWOepjHOlwBaR", forHTTPHeaderField: "apikey")

        return try await load(urlRequest: urlRequest)
    }

    private func load<Response: Decodable>(urlRequest: URLRequest) async throws -> Response {
        guard let (data, response) = try? await session.data(for: urlRequest),
              let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
            throw NetworkingError.missingData
        }

        do {
            let jsonDecoder = JSONDecoder()
            return try jsonDecoder.decode(Response.self, from: data)
        } catch {
            throw NetworkingError.decodingFailed(error)
        }
    }
}
