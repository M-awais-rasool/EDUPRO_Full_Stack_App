//
//  SectionView.swift
//  EduproApp
//
//  Created by Ch  A 𝔀 𝓪 𝓲 𝓼 on 20/02/2025.
//

import SwiftUI

struct SectionView: View {
    let section: CourseSection
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Section \(section.number) - ")
                    .font(.headline)
                    .foregroundColor(.black)
                
                Text(section.title)
                    .font(.headline)
                    .foregroundColor(.blue)
                
                Spacer()
                
                Text(section.duration)
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            .padding(.top, 20)
            .padding(.bottom, 10)
            
            ForEach(section.modules) { module in
                ModuleView(module: module)
            }
        }
    }
}

struct ModuleView: View {
    let module: CourseModule
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Text(module.number)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.gray)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(module.title)
                        .font(.system(size: 16, weight: .semibold))
                    
                    Text(module.duration)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                if module.isLocked {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.black)
                        .frame(width: 30, height: 30)
                } else {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 30, height: 30)
                        .overlay(
                            Image(systemName: "play.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                        )
                }
            }
            .padding(.vertical, 12)
            .background(Color.white)
            
            Divider()
                .padding(.leading, 75)
        }
    }
}

