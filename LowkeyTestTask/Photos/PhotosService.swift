//
//  PhotosService.swift
//  LowkeyTestTask
//
//  Created by Saikal Toichueva on 16/10/23.
//

import Foundation

fileprivate extension String {
    static let url = "https://api.pexels.com/v1/curated?per_page=15"
    static let apiKey = "HMPiKd6BA4NV4Ui8hXSiznwqIahQKNB3QylUbGF2UchqON8LYMAF3jDh"
}

protocol PhotosService {
    func fetchPhotos(page: Int) async throws -> [Photo]
}

class PhotosServiceImpl: PhotosService {
    func fetchPhotos(page: Int) async throws -> [Photo] {
        var urlComponents = URLComponents(string: .url)
        urlComponents?.queryItems = [
            URLQueryItem(name: "page", value: String(page))
        ]
        guard let url = urlComponents?.url else { return [] }

        var request = URLRequest(url: url)
        request.setValue(.apiKey, forHTTPHeaderField: "Authorization")

        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decodedData = try decoder.decode(Photos.self, from: data)
        return decodedData.photos
    }
}
