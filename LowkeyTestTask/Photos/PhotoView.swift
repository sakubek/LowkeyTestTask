//
//  PhotoView.swift
//  LowkeyTestTask
//
//  Created by Saikal Toichueva on 16/10/23.
//

import SwiftUI

struct PhotoView: View {
    let url: String

    var body: some View {
        VStack {
            AsyncImage(url: .init(string: url)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure(let error):
                    Text("Error: \(error.localizedDescription)")
                case .empty:
                    ProgressView()
                @unknown default:
                    Text("Unknown Error")
                }
            }
        }
    }
}
