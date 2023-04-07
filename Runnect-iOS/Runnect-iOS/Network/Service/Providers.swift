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

extension MoyaProvider {
  convenience init(withAuth: Bool) {
    if withAuth {
      self.init(session: Session(interceptor: AuthInterceptor.shared),
                plugins: [NetworkLoggerPlugin(verbose: true)])
    } else {
      self.init()
    }
  }
}
