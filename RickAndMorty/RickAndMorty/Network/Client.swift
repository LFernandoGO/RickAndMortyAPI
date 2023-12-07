//
//  Client.swift
//  RickAndMorty
//
//  Created by Diplomado on 02/12/23.
//

import Foundation

struct Client{
    let session = URLSession.shared
    let baseURL: String
    private let contentType: String
    
    enum NetworkErrorrs: Error{
        case standar
        case client
        case server
        case conection
        case invalidResponse
        case invalidRequest
        
    }
    
    init(_ baseURL: String, contentType: String = "aplication/json"){
        self.baseURL = baseURL
        self.contentType = contentType
    }
    
    typealias requestHandler = ((Data?)-> Void)
    typealias errorHandler = (NetworkErrorrs)->Void
    
    func get(_ path: String, query: [String:String], success: requestHandler?, failure: errorHandler? = nil){
        request(method: "GET", path: path,query: query, body: nil, success: success, failure: failure)
    }
    
    func request(method: String, path: String, query: [String:String], body: Data?, success: requestHandler?, failure: errorHandler? = nil){
        guard let request = buildRequees(method: method, path: path, query: query, body: body) else{
            failure?(NetworkErrorrs.invalidRequest)
            return
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                #if DEBUG
                debugPrint(error)
                #endif
                failure?(NetworkErrorrs.conection)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                failure?(NetworkErrorrs.invalidResponse)
                return
            }
            
            let status = StatusCode(rawValue: httpResponse.statusCode)
            #if DEBUG
            print("Status: \(httpResponse.statusCode)")
            debugPrint(httpResponse)
            #endif
            switch status {
            case .success:
                success?(data)
            case .clientError:
                failure?(NetworkErrorrs.client)
            case .serverError:
                failure?(NetworkErrorrs.server)
            default:
                failure?(NetworkErrorrs.invalidResponse)
            }
        }
        task.resume()
    }
    
    private func buildRequees(method: String, path: String, query: [String:String], body: Data?) -> URLRequest?{
        guard var urlComp = URLComponents(string: baseURL) else {return nil}
        urlComp.path = path
        urlComp.queryItems = query.map{(key,value) in
            URLQueryItem(name: key, value: value)
        }
        guard let url = urlComp.url else {return nil}
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue( contentType, forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        #if DEBUG
        debugPrint(request)
        #endif
        return request
    }
}
