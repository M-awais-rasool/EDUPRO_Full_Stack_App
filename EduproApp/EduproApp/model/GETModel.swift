//
//  GETModel.swift
//  EduproApp
//
//  Created by Ch  A 𝔀 𝓪 𝓲 𝓼 on 25/02/2025.
//

import Foundation

struct HomeCourse: Decodable {
    let data: [Course]?
    let status: String
}

struct Course:Identifiable,Decodable{
    let id :String
    let category :String
    let description :String
    let image :String
    var isBookMark :Bool
    let price:Double
    let title :String
}

struct HomeMentor:Decodable{
    let data: [Mentor]
    let status: String
}

struct Mentor:Identifiable,Decodable{
    let id:String
    let email:String
    let image:String
    let name:String
}

struct CourseDetail: Decodable {
    let data: CourseDetailData
    let status: String
}

struct CourseDetailData:Identifiable,Decodable{
    let id :String
    let category :String
    let description :String
    let image :String
    let isBookMark :Bool
    let price:Double
    let title :String
    let user:Mentor
}


struct KeyWordModel:Decodable{
    let data: [KeyWordData]
    let status: String
}

struct KeyWordData:Identifiable,Decodable{
    let id :String
    let word: String
}

struct MentorProfile:Decodable{
    let data: Mentor
    let status: String
}


struct Vides:Decodable{
    let data: [VideoData]?
    let status: String
}

struct VideoData:Identifiable,Decodable{
    let id : String
    let title: String
    let videos :[VideoInnerData]?
}

struct VideoInnerData:Identifiable,Decodable{
    let id :String
    let title:String
    let video:String
}
