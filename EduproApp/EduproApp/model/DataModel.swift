//
//  DataModel.swift
//  EduproApp
//
//  Created by Ch  A 𝔀 𝓪 𝓲 𝓼 on 20/02/2025.
//

import Foundation
import SwiftUI

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

let ratings = [
    (name: "John Smith", rating: 5.0, date: "Jan 15, 2025", comment: "Excellent course! Clear explanation and great projects."),
    (name: "Emma Watson", rating: 4.5, date: "Feb 3, 2025", comment: "Very informative and well-structured. Would recommend to anyone interested in graphic design."),
    (name: "Michael Brown", rating: 3.5, date: "Jan 28, 2025", comment: "Good content but some sections could use more examples."),
    (name: "Sarah Johnson", rating: 5.0, date: "Feb 10, 2025", comment: "Exactly what I needed to advance my career. The instructor is amazing!")
]

let courses = [
    (category: "Graphic Design", title: "Graphic Design Advanced", price: "799", rating: 4.2, students: 7830, isFeatured: true),
    (category: "Graphic Design", title: "Advertisement Design", price: "499", rating: 3.9, students: 12680, isFeatured: false),
    (category: "Programming", title: "Graphic Design", price: "199", rating: 4.2, students: 990, isFeatured: true),
    (category: "Web Development", title: "Web Developer Specialization", price: "899", rating: 4.9, students: 14580, isFeatured: false),
    (category: "SEO & Marketing", title: "Digital Marketing Career Track", price: "299", rating: 4.2, students: 10252, isFeatured: true),
    (category: "SEO & Marketing", title: "Digital Marketing Track", price: "299", rating: 4.2, students: 10252, isFeatured: true)
]


//notification screen
struct NotificationItem: Identifiable {
    let id = UUID()
    let icon: String
    let iconBackgroundColor: Color
    let iconForegroundColor: Color
    let title: String
    let message: String
}

struct NotificationSection: Identifiable {
    let id = UUID()
    let title: String
    let items: [NotificationItem]
}

let notificationSections: [NotificationSection] = [
    NotificationSection(
        title: "Today",
        items: [
            NotificationItem(
                icon: "square.grid.2x2",
                iconBackgroundColor: .white,
                iconForegroundColor: .blue,
                title: "New Category Course.!",
                message: "New the 3D Design Course is Availa.."
            ),
            NotificationItem(
                icon: "tv.fill",
                iconBackgroundColor: .blue,
                iconForegroundColor: .white,
                title: "New Category Course.!",
                message: "New the 3D Design Course is Availa..."
            ),
            NotificationItem(
                icon: "ticket",
                iconBackgroundColor: .white,
                iconForegroundColor: .blue,
                title: "Today's Special Offers",
                message: "You Have made a Coure Payment."
            )
        ]
    ),
    NotificationSection(
        title: "Yesterday",
        items: [
            NotificationItem(
                icon: "creditcard",
                iconBackgroundColor: .white,
                iconForegroundColor: .blue,
                title: "Credit Card Connected.!",
                message: "Credit Card has been Linked.!"
            )
        ]
    ),
    NotificationSection(
        title: "Nov 20, 2022",
        items: [
            NotificationItem(
                icon: "person.circle",
                iconBackgroundColor: .white,
                iconForegroundColor: .blue,
                title: "Account Setup Successful.!",
                message: "Your Account has been Created."
            )
        ]
    )
]
