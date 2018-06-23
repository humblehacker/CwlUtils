//
//  CwlAddressInfoTests.swift
//  CwlUtils
//
//  Created by Matt Gallagher on 2016/02/26.
//  Copyright © 2016 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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

class AddressInfoTests: XCTestCase {
	func testCallingFunctionIdentifier() {
		let name = callingFunctionIdentifier()
		
		print(name)
		
		// Only test the suffix since the module name varies.
		// The two options tested here are the pre-Swift 2.2, the post-Swift 2.2 through Swift 3.1 and the Swift 4 mangled names.
		XCTAssert(
			name.hasSuffix("16AddressInfoTests29testCallingFunctionIdentifierfS0_FT_T_") ||
			name.hasSuffix("16AddressInfoTests29testCallingFunctionIdentifierfT_T_") ||
			name.hasSuffix("16AddressInfoTestsC29testCallingFunctionIdentifieryyF"))
	}
	
	func testSymbolsForCallStackAddresses() {
		var b = Thread.callStackSymbols
		b.remove(at: 0)
		var a = symbolsForCallStack(addresses: callStackReturnAddresses())
		a.remove(at: 0)
		XCTAssert(a == b)
	}
}
