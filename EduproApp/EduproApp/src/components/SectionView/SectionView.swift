//
//  SectionView.swift
//  EduproApp
//
//  Created by Ch  A 𝔀 𝓪 𝓲 𝓼 on 20/02/2025.
//

import SwiftUI

struct SectionView: View {
    let section: VideoData
    let index: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Section \(index + 1) - ")
                    .font(.headline)
                    .foregroundColor(.black)
                
                Text(section.title)
                    .font(.headline)
                    .foregroundColor(.blue)
                
                Spacer()
                
                Text("25 mint")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            .padding(.top, 20)
            .padding(.bottom, 10)
            
            if let videos = section.videos {
                ForEach(Array(videos.enumerated()), id: \.element.id) { index, module in
                    ModuleView(module: module,index:index)
                }
            }
        }
    }
}


struct ModuleView: View {
    let module: VideoInnerData
    let index: Int
    @State private var navigateToVideo = false
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Text("\(index + 1)")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.gray)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(module.title)
                        .font(.system(size: 16, weight: .semibold))
                    
                    Text("5 min")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(systemName: "lock.fill")
                    .foregroundColor(.black)
                    .frame(width: 30, height: 30)
            }
            .padding(.vertical, 12)
            .background(Color.white)
            .onTapGesture {
                navigateToVideo = true
            }
            
            Divider()
                .padding(.leading, 75)
        }
        .navigationDestination(isPresented: $navigateToVideo) {
            if let validURL = URL(string: module.video) {
                VideoPlayerView(videoURL: validURL)
            } else {
                Text("Invalid Video URL")
            }
        }
    }
}



