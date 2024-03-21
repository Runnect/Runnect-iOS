//
//  Providers.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/04/05.
//

import Foundation

import Moya

struct Providers {
  static let departureSearchingProvider = MoyaProvider<DepartureSearchingRouter>(withAuth: false)
  static let authProvider = MoyaProvider<AuthRouter>(withAuth: true)
  static let userProvider = MoyaProvider<UserRouter>(withAuth: true)
  static let courseProvider = MoyaProvider<CourseRouter>(withAuth: true)
  static let publicCourseProvider = MoyaProvider<PublicCourseRouter>(withAuth: true)
  static let recordProvider = MoyaProvider<RecordRouter>(withAuth: true)
  static let scrapProvider = MoyaProvider<ScrapRouter>(withAuth: true)
  static let stampProvider = MoyaProvider<StampRouter>(withAuth: true)
}

struct Provider {
    static let departureSearchingProvider = NetworkProvider<DepartureSearchingRouter>(withAuth: false)
    static let authProvider = NetworkProvider<AuthRouter>(withAuth: true)
    static let userProvider = NetworkProvider<UserRouter>(withAuth: true)
    static let courseProvider = NetworkProvider<CourseRouter>(withAuth: true)
    static let publicCourseProvider = NetworkProvider<PublicCourseRouter>(withAuth: true)
    static let recordProvider = NetworkProvider<RecordRouter>(withAuth: true)
    static let scrapProvider = NetworkProvider<ScrapRouter>(withAuth: true)
    static let stampProvider = NetworkProvider<StampRouter>(withAuth: true)
}

extension MoyaProvider {
  convenience init(withAuth: Bool) {
    if withAuth {
      self.init(session: Session(interceptor: AuthInterceptor.shared),
                plugins: [NetworkLoggerPlugin(verbose: true)])
    } else {
        self.init(plugins: [NetworkLoggerPlugin(verbose: true)])
    }
  }
}
