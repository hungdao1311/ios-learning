//
//  DataService.swift
//  FoodTracker
//
//  Created by Hung Dao on 10/7/19.
//  Copyright © 2019 Hung Dao. All rights reserved.
//

import Foundation

class DataService {
    var url: URL
    var body: Body?
    var method: HttpMethod?
    private var request: URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method?.stringValue
        urlRequest.httpBody = body?.content.data(using: .utf8)
        urlRequest.setValue(body?.contentType, forHTTPHeaderField: "Content-Type")
        return urlRequest
    }
    init(url: URL) {
        self.url = url
    }
    
    func setBody(body: Body) -> DataService {
        if (self.method == .get || self.method == .head) {
            fatalError("\(self.method!.stringValue) method is not allowed to have body")
        }
        self.body = body
        return self
    }
    
    func setParam(params: UrlEncodedBody) -> DataService {
        var absoluteString = self.url.absoluteString
        if absoluteString.last! == "?" {
            absoluteString.remove(at: absoluteString.index(before: absoluteString.endIndex))
        }
        absoluteString += params.content
        self.url = URL(string: absoluteString)!
        return self
    }
    
    func setMethod(method: HttpMethod) -> DataService {
        self.method = method
        return self
    }
    
    func getRawResult(completion: @escaping (_ result: String?, _ error: Error?) -> Void) {
        var result: String?
        var callbackError: Error?
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            if let data = data {
                result = String(decoding: data, as: UTF8.self)
            } else {
                callbackError = error
            }
            DispatchQueue.main.async {
                completion(result, callbackError)
            }
        }
        task.resume()
    }
    
    func getObject<T>(completion: @escaping (_ result: T?, _ apiError: ErrorResponse?, _ error: Error?) -> Void) where T: DataParseable, T: CustomStringConvertible{
        var result: T?
        var callbackError: Error?
        var errorResponse: ErrorResponse?
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            let status = (response as! HTTPURLResponse).statusCode
            if let data = data {
                do {
                    let dict = try self.convertToDictionary(text: String(decoding: data, as:UTF8.self))
                    let reader = Reader(dict)
                    if (status == 200) {
                        result = try T(json: reader)
                    } else {
                        errorResponse = ErrorResponse(json: reader)
                    }
                } catch (let e) {
                    callbackError = e
                }
            } else {
                callbackError = error
            }
            DispatchQueue.main.async {
                completion(result, errorResponse, callbackError)
            }
        }
        task.resume()
    }
    
    func convertToDictionary(text: String) throws -> [String: Any] {
        if let data = text.data(using: .utf8) {
            let jsonObject: Any
            do {
                jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            } catch {
                throw ParserError.JsonParsing
            }
            if let dict = jsonObject as? [String: Any] {
                return dict
            } else {
                throw ParserError.DictionaryCasting
            }
        } else {
            throw ParserError.EmptyResponse
        }
    }
}
