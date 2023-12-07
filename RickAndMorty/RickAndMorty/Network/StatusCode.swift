//
//  StatusCode.swift
//  RickAndMorty
//
//  Created by Diplomado on 01/12/23.
//

import Foundation


enum StatusCode: Int{
    case unkown = 0
    case info
    case success
    case redirection
    case clientError
    case serverError
    
    init?(rawValue: Int) {
        switch rawValue{
        case 100,101,102:
            self = .info
        case 200, 201, 202, 203, 204, 206, 207, 208, 226:
            self = .success
        case 300, 301, 302, 303,304,305,306,307,308:
            self = .redirection
        case 400,401,402,403,404,405,406,407,408,409,410,411,412,413,414,415,416,417,418,421,422,423,424,426,428,429,431,451:
            self = .clientError
        case 500,501,502,503,504,505,506,507,510,511:
            self = .serverError
        default:
            self = .unkown
            
        }
    }
}
