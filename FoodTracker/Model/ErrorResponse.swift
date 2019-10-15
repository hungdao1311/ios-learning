//
//  ErrorResponse.swift
//  FoodTracker
//
//  Created by Hung Dao on 10/11/19.
//  Copyright © 2019 Hung Dao. All rights reserved.
//

import Foundation



struct ErrorResponse: CustomStringConvertible {
    let statusCode: Int
    let error: String
    let errorDescription: String
    
    var isOk: Bool {
        return statusCode == 200
    }
    
    var isUnauthorized : Bool {
        return statusCode == 401
    }
    // designated constructor
    init(statusCode: Int, error: String, errorDescription: String) {
        self.statusCode = statusCode
        self.error = error
        self.errorDescription = errorDescription
    }
    
    init(json: Reader, statusCode: Int) {
        self.init(
            statusCode: statusCode,
            error: json.readString("error"),
            errorDescription: json.readString("error_description")
        )
    }
    
    init(exception: Error) {
        if exception is HttpStatusError {
            self.init(httpError: exception as! HttpStatusError)
        } else {
            self.init(error: exception)
        }
    }
    
    private init(error: Error) {
        let alertMessage = error.localizedDescription
        self.init(
            statusCode: 0,
            error: "",
            errorDescription: alertMessage
        )
    }
    
    private init(httpError: HttpStatusError) {
        switch httpError.statusCode {
        case 400 ... 499:
            do {
                self.init(json: try Reader(json: httpError.content), statusCode: httpError.statusCode)
            } catch {
                self.init(error: error)
            }
        case 500:
            let alertMessage = "We have a problem with the server, please try again later"
            self.init(
                statusCode: httpError.statusCode,
                error: "",
                errorDescription: alertMessage
            )
        default:
            self.init(error: httpError)
        }
    }
    
    var description: String {
        return "error: \(errorDescription)"
    }
    
}
