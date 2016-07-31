//
//  CwlDispatchTests.swift
//  CwlUtils
//
//  Created by Matt Gallagher on 2016/07/30.
//  Copyright © 2016 Matt Gallagher ( http://cocoawithlove.com ). All rights reserved.
//
//  Permission to use, copy, modify, and/or distribute this software for any
//  purpose with or without fee is hereby granted, provided that the above
//  copyright notice and this permission notice appear in all copies.
//
//  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
//  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
//  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
//  SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
//  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
//  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR
//  IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
//

import Foundation
import XCTest
import CwlUtils

class DispatchTests: XCTestCase {
	let queue = DispatchQueue(label: "")
	let value = 3
	let key = DispatchSpecificKey<Int>()
	
	override func setUp() {
		queue.setSpecific(key: key, value: value)
	}
	
	func testAccess() {
		let result = queue.access {
			return DispatchQueue.getSpecific(key: self.key)
		}
		XCTAssert(result == value)
	}
	
	func testSynchronousTimer() {
		let ex = expectation(description: "")
		var timer: DispatchSourceTimer? = nil
		queue.sync {
			timer = DispatchSource.timer(interval: .milliseconds(50), queue: queue) {
				XCTAssert(DispatchQueue.getSpecific(key: self.key) == self.value)
				ex.fulfill()
			}
		}
		waitForExpectations(timeout: 1e2, handler: nil)
		withExtendedLifetime(timer) {}
	}
	
	func testParametricTimer() {
		let ex1 = expectation(description: "")
		let ex2 = expectation(description: "")
		var timer: DispatchSourceTimer? = nil
		var outerMutexComplete = false
		queue.sync {
			timer = DispatchSource.timer(interval: .milliseconds(1), parameter: 1) { p in
				self.queue.sync {
					XCTAssert(outerMutexComplete)
					XCTAssert(p == 1)
					ex1.fulfill()
				}
			}
			Thread.sleep(forTimeInterval: 0.1)
			timer?.scheduleOneshot(interval: .milliseconds(1), parameter: 2) { p in
				self.queue.sync {
					XCTAssert(outerMutexComplete)
					XCTAssert(p == 2)
					ex2.fulfill()
				}
			}
			outerMutexComplete = true
		}
		waitForExpectations(timeout: 1e2, handler: nil)
		withExtendedLifetime(timer) {}
	}
}
