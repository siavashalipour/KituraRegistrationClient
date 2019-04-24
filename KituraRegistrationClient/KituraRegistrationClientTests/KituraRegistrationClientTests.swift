//
//  KituraRegistrationClientTests.swift
//  KituraRegistrationClientTests
//
//  Created by Siavash on 24/4/19.
//  Copyright © 2019 Siavash. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxBlocking

@testable import KituraRegistrationClient

class KituraRegistrationClientTests: XCTestCase {
  
  var loginVM: LoggedInViewModel!
  var scheduler: ConcurrentDispatchQueueScheduler!
  let aThing = Thing(uuid: UUID.init().uuidString)
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    super.setUp()
    
    loginVM = LoggedInViewModel.init(with: Account(email: "test@test.com", password: "Password1", things: [aThing]), navigator: Navigator.init())
    scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testEmailVariable() {
    let emailObserver = loginVM.emailValue.asObservable().subscribeOn(scheduler)
    let newEmail = "result@result.com"
    loginVM.emailValue.value = newEmail
    
    do {
      guard let result = try emailObserver.toBlocking().first() else {return}
      XCTAssertEqual(result, newEmail)
    } catch {
      print("Err")
    }
    
  }
  
  func testThingVairable() {
    
    let thingObserver = loginVM.things.asObservable().subscribeOn(scheduler)
    
    do {
      guard let result = try thingObserver.toBlocking().first() else {return}
      if let safeResult = result {
        XCTAssertEqual(safeResult.count, 1)
        XCTAssertEqual(safeResult.first!.uuid, aThing.uuid)
      } else {
        fatalError()
      }
    } catch {
      fatalError()
    }
    
  }
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}
