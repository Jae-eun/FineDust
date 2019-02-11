//
//  CoreDataServiceType.swift
//  FineDust
//
//  Created by Presto on 03/02/2019.
//  Copyright © 2019 boostcamp3rd. All rights reserved.
//

import Foundation

/// Core Data Service 프로토콜.
protocol CoreDataServiceType: class {
  
  /// 최근 접속 날짜 저장.
  func saveLastAccessedDate(completion: @escaping (Error?) -> Void)
  
  /// 최근 접속 날짜 가져오기.
  func fetchLastAccessedDate(completion: @escaping (Date?, Error?) -> Void)
  
  /// 일주일 미세먼지 흡입량 가져오기.
  func fetchIntakes(from startDate: Date,
                    to endDate: Date,
                    completion: @escaping ([Int]?, Error?) -> Void)
}
