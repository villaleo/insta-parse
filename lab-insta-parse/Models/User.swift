//
//  User.swift
//  lab-insta-parse
//
//  Forked from Charlie Hieger on 11/1/22.
//  Created by Leonardo Villalobos on 3/2/23.
//

import Foundation
import ParseSwift

struct User: ParseUser {
    var username: String?
    var email: String?
    var emailVerified: Bool?
    var password: String?
    var authData: [String : [String : String]?]?
    
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseSwift.ParseACL?
}

// MARK: impl User
extension User {
    init(username: String, email: String, password: String) {
        self.username = username
        self.email = email
        self.password = password
    }
}

// MARK: Conform User to CustomStringConvertible
extension User: CustomStringConvertible {
    var description: String {
        return "User{username=\(username ?? "")," + "email=\(email ?? "")}"
    }
}
