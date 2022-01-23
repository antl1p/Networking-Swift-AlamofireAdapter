import XCTest
@testable import AlamofireAdapter

final class AlamofireAdapterTests: XCTestCase {
    var model: Model {
        Model(stringProperty: "String", intProperty: 100_100)
    }
    
    enum TestErrors: Error {
        case testFail
    }
    
    func testRequestReturnsIntoCompletionBlock() throws {
        // GIVEN a GET Request
        let request = MockRequest(expectedResult: .success(model))
        
        // WHEN the request is executed on a URLSessionAdapter
        let expectation = XCTestExpectation(description: "DataTask Completion")
        let sut = AlamofireAdapter()
        _ = try sut.execute(request: request) { _ in
            expectation.fulfill()
        }
        
        // THEN the request should be fulfilled before the timeout
        wait(for: [expectation], timeout: 10)
    }
    
    func testRequestIsPassedResponseForParsing() throws {
        // GIVEN a GET Request
        let request = MockRequest(expectedResult: .success(model))
        
        // WHEN the request is executed on a URLSessionAdapter
        let expectation = XCTestExpectation(description: "DataTask Completion")
        let sut = AlamofireAdapter()
        _ = try sut.execute(request: request) { response in
            expectation.fulfill()
        }
        
        // THEN the request should attempt to parse the response
        wait(for: [expectation], timeout: 10)
        
        XCTAssertNotNil(request.data)
        XCTAssertNotNil(request.urlResponse)
        XCTAssertNil(request.error)
    }
    
    func testRequestProperlyAbstractsParsingSuccessResponse() throws {
        // GIVEN a GET Request
        let request = MockRequest(expectedResult: .success(model))
        
        // WHEN the request is executed on a URLSessionAdapter
        var actualResponse: Result<Model, Error>?
        let expectation = XCTestExpectation(description: "DataTask Completion")
        let sut = AlamofireAdapter()
        _ = try sut.execute(request: request) { response in
            actualResponse = response
            expectation.fulfill()
        }
        
        // THEN the request should return the hard-coded response
        wait(for: [expectation], timeout: 10)
        
        guard case let .success(actualResponseModel) = actualResponse else {
            XCTFail("actualResponse should be success")
            return
        }
        
        XCTAssertEqual(actualResponseModel.stringProperty, model.stringProperty)
        XCTAssertEqual(actualResponseModel.intProperty, model.intProperty)
    }
    
    func testRequestProperlyAbstractsParsingFailureResponse() throws {
        // GIVEN a GET Request
        let request = MockRequest(expectedResult: .failure(TestErrors.testFail))
        
        // WHEN the request is executed on a URLSessionAdapter
        var actualResponse: Result<Model, Error>?
        let expectation = XCTestExpectation(description: "DataTask Completion")
        let sut = AlamofireAdapter()
        _ = try sut.execute(request: request) { response in
            actualResponse = response
            expectation.fulfill()
        }
        
        // THEN the request should return the hard-coded response
        wait(for: [expectation], timeout: 10)
        
        guard case let .failure(failureError) = actualResponse,
              let testError = failureError as? TestErrors  else {
            XCTFail("actualResponse should be success")
            return
        }
        
        XCTAssertEqual(testError, TestErrors.testFail)
    }
}
