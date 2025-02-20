//
//  DataModel.swift
//  EduproApp
//
//  Created by Ch  A 𝔀 𝓪 𝓲 𝓼 on 20/02/2025.
//

import Foundation


struct CourseSection: Identifiable {
    let id = UUID()
    let number: String
    let title: String
    let duration: String
    let modules: [CourseModule]
}

struct CourseModule: Identifiable {
    let id = UUID()
    let number: String
    let title: String
    let duration: String
    let isLocked: Bool
}

struct HomeCourseModel: Identifiable {
    let id = UUID()
    let title: String
    let category: String
    let price: String
    let rating: String
    let students: String
}

let sections: [CourseSection] = [
    CourseSection(
        number: "01",
        title: "Introduction",
        duration: "25 Mins",
        modules: [
            CourseModule(number: "01", title: "Why Using Graphic De..", duration: "15 Mins", isLocked: false),
            CourseModule(number: "02", title: "Setup Your Graphic De..", duration: "10 Mins", isLocked: false)
        ]
    ),
    CourseSection(
        number: "02",
        title: "Graphic Design",
        duration: "55 Mins",
        modules: [
            CourseModule(number: "03", title: "Take a Look Graphic De..", duration: "08 Mins", isLocked: true),
            CourseModule(number: "04", title: "Working with Graphic De..", duration: "25 Mins", isLocked: true),
            CourseModule(number: "05", title: "Working with Frame & Lay..", duration: "12 Mins", isLocked: true),
            CourseModule(number: "06", title: "Using Graphic Plugins", duration: "10 Mins", isLocked: true)
        ]
    ),
    CourseSection(
        number: "03",
        title: "Let's Practice",
        duration: "35 Mins",
        modules: [
            CourseModule(number: "07", title: "Let's Design a Sign Up Fo..", duration: "15 Mins", isLocked: true),
            CourseModule(number: "08", title: "Sharing work with Team", duration: "20 Mins", isLocked: true)
        ]
    )
]

let detailSections:[CourseSection] = [
    CourseSection(
        number: "01",
        title: "Introduction",
        duration: "25 Mins",
        modules: [
            CourseModule(number: "01", title: "Why Using Graphic De..", duration: "15 Mins", isLocked: false),
            CourseModule(number: "02", title: "Setup Your Graphic De..", duration: "10 Mins", isLocked: false)
        ]
    ),
]
