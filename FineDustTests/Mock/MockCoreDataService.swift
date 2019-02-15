//
//  MockCoreDataService.swift
//  FineDustTests
//
//  Created by Presto on 04/02/2019.
//  Copyright © 2019 boostcamp3rd. All rights reserved.
//

@testable import FineDust
import Foundation

class MockCoreDataService: CoreDataServiceType {
  
  var lastAccessedDate: Date?
  
  var coreDataIntakePerDate: DateIntakePair?
  
  var lastRequestedData: LastRequestedData?
  
  var error: Error?
  
  func requestLastAccessedDate(completion: @escaping (Date?, Error?) -> Void) {
    completion(lastAccessedDate, error)
  }
  
  func saveLastAccessedDate(completion: @escaping (Error?) -> Void) {
    completion(error)
  }
  
  func requestIntakes(from startDate: Date, to endDate: Date, completion: @escaping (DateIntakePair?, Error?) -> Void) {
    completion(coreDataIntakePerDate, error)
  }
  
  func saveIntake(fineDust: Int, ultrafineDust: Int, at date: Date, completion: @escaping (Error?) -> Void) {
    completion(error)
  }
  
  func saveIntakes(fineDusts: [Int], ultrafineDusts: [Int], at dates: [Date], completion: @escaping (Error?) -> Void) {
    completion(error)
  }
  
  func requestLastRequestedData(completion: @escaping (LastRequestedData?, Error?) -> Void) {
    completion(lastSavedData, error)
  }
  
  func saveLastRequestedData(_ lastSavedData: LastRequestedData, completion: @escaping (Error?) -> Void) {
    completion(error)
  }
}
