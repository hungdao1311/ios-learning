//
//  Token.swift
//  FoodTracker
//
//  Created by Hung Dao on 10/10/19.
//  Copyright © 2019 Hung Dao. All rights reserved.
//

import Foundation

struct Token: DataParseable, CustomStringConvertible {
    var accessToken: String
    var expiresIn: Int
    var refreshExpiresIn: Int
    var refreshToken: String
    var tokenType: String
    var notBeforePolicy: Date
    var sessionState: String
    
    init(json: Reader) {
        self.accessToken = json.readString("access_token")
        self.expiresIn = json.readInt("expires_in")
        self.refreshExpiresIn = json.readInt("refresh_expires_in")
        self.refreshToken = json.readString("refresh_token")
        self.tokenType = json.readString("token_type")
        self.notBeforePolicy = json.readDate("not-before-policy")
        self.sessionState = json.readString("session_state")
    }
    
    var description: String {
        return "access token: \(accessToken), expires in: \(expiresIn), refresh expires in: \(refreshExpiresIn), refresh token: \(refreshToken), token type: \(tokenType), not before policy: \(notBeforePolicy.iso8601), session state: \(sessionState)"
    }
}
