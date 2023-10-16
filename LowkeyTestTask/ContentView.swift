//
//  ContentView.swift
//  LowkeyTestTask
//
//  Created by Saikal Toichueva on 12/10/23.
//

import SwiftUI
import Kingfisher

struct ContentView: View {
    @StateObject var viewModel = PhotosViewModel()
    @State var selectedPhoto: Photo?

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.photos, id: \.self) { photo in
                        HStack {
                            PhotoView(url: photo.src.small)
                            Text(photo.photographer)
                        }.task {
                            await viewModel.loadMoreContent(currentItem: photo)
                        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(10.0)
                            .shadow(color: Color.black.opacity(0.5), radius: 2, x: 0, y: 0)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5).onTapGesture {
                                self.selectedPhoto = photo
                            }
                    }
                }
            }
            .navigationTitle("Photos")
            .task {
                await viewModel.fetchPhotos()
            }.refreshable {
                await viewModel.fetchPhotos(forcedRefresh: true)
            }
        }.sheet(item: $selectedPhoto) { photo in
            PhotoView(url: photo.src.original)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//class ImageLoader: ObservableObject {
//  private var cancellable: AnyCancellable?
//  private var cache: ImageCache
//  @Published var image: UIImage?
//  private let url: URL
//  init(url: URL, cache: ImageCache) {
//    self.url = url
//    self.cache = cache
//  }
//  deinit {
//    cancellable?.cancel()
//  }
//  func load() {
//    if let image = cache[url] {
//      dispatchToMainThreadIfNeeded {
//        self.image = image
//      }
//      return
//    }
//    cancellable = URLSession.shared.dataTaskPublisher(for: url)
//      .map { UIImage(data: $0.data) }
//      .handleEvents(receiveOutput: { [weak self] in self?.cache($0) })
//      .replaceError(with: nil)
//      .sink { value in
//        self.image = value // Dispatch on main thread is not firing the publisher..
//    }
//  }
//  func cancel() {
//    cancellable?.cancel()
//  }
//  private func cache(_ image: UIImage?) {
//    image.map { cache[url] = $0 }
//  }
//}
