//
//  CustomImageLoader.swift
//  WeatherApp
//
//  Created by Robert-Dumitru Oprea on 13/04/2023.
//

import SwiftUI
import Combine

class CustomImageLoader: ObservableObject {
    @Published var image: UIImage?
    private var cancellable: AnyCancellable?
    private static var cache = NSCache<NSURL, UIImage>() //Cache used to store the downloaded image, it will remain in the cache until the app is terminated

    func load(url: URL) {
        if let cachedImage = CustomImageLoader.cache.object(forKey: url as NSURL) {
            image = cachedImage
            return
        }

        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] downloadedImage in
                guard let downloadedImage = downloadedImage else { return }
                CustomImageLoader.cache.setObject(downloadedImage, forKey: url as NSURL)
                self?.image = downloadedImage
            })
    }

    func cancel() {
        cancellable?.cancel()
    }
}


struct CustomAsyncImage: View {
    @StateObject private var loader = CustomImageLoader()
    private let url: URL

    init(url: URL) {
        self.url = url
    }

    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
            } else {
                ProgressView()
            }
        }
        .onAppear {
            loader.load(url: url)
        }
        .onDisappear {
            loader.cancel()
        }
    }
}
