//
//  PhotosViewModel.swift
//  LowkeyTestTask
//
//  Created by Saikal Toichueva on 16/10/23.
//

import Foundation

class PhotosViewModel: ObservableObject {
    /// I would normally use Dependency Injection here
    let service: PhotosService = PhotosServiceImpl()
    @Published var photos: [Photo] = []

    /// MARK: Restriction to the number of pages, there were no specific number for that
    var totalPages = 50
    var page : Int = 1

    //MARK: - PAGINATION
    @MainActor func loadMoreContent(currentItem item: Photo) async {
        let thresholdIndex = self.photos.index(self.photos.endIndex, offsetBy: -1)
        if photos.count == thresholdIndex + 1,
            (page + 1) <= totalPages,
            photos[thresholdIndex].id == item.id {
            page += 1
            await fetchPhotos()
        }
    }

    //MARK: - API CALL

    @MainActor func fetchPhotos(forcedRefresh: Bool = false) async {
        /// FYI I noticed that this API can return the same photow with same id again
        if forcedRefresh {
            let photos = try? await service.fetchPhotos(page: 1)
            self.photos = photos ?? []
        } else {
            let photos = try? await service.fetchPhotos(page: page)
            self.photos.append(contentsOf: photos ?? [])
        }
    }
}
