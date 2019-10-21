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
    var accessToken: String?
    private var request: URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method?.stringValue
        urlRequest.httpBody = body?.content.data(using: .utf8)
        urlRequest.setValue(body?.contentType, forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(accessToken ?? "")", forHTTPHeaderField: "Authorization")
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
    
    func setAccessToken(token: String) -> DataService {
        self.accessToken = token
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
    
    func getObject<T>(completion: @escaping (_ result: T?, _ error: Error?) -> Void) where T: DataParseable{
        var result: T?
        var callbackError: Error?
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            let status = (response as! HTTPURLResponse).statusCode
            if let data = data {
                do {
                    let content = String(decoding: data, as:UTF8.self)
                    if (status == 200) {
                        result = try parseObject(content: content)
                    } else {
                        callbackError = HttpStatusError(statusCode: status, content: content)
                    }
                } catch (let e) {
                    callbackError = e
                }
            } else {
                callbackError = error
            }
            DispatchQueue.main.async {
                completion(result, callbackError)
            }
        }
        task.resume()
    }
    
   
}
