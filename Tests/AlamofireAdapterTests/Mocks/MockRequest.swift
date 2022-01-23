import Foundation
import NetworkingCore

final class MockRequest: NetworkRequestType {
    typealias ResponseType = Model
    
    let expectedResult: Result<Model, Error>
    
    private(set) var data: Data?
    private(set) var urlResponse: URLResponse?
    private(set) var error: Error?
    
    init(expectedResult: Result<Model, Error>) {
        self.expectedResult = expectedResult
    }
    
    var urlRequest: URLRequest {
        var request = URLRequest(url: URL(string: "https://cataas.com/c")!)
        request.httpMethod = "GET"
        return request
    }
    
    func parseResponse(data: Data?, urlResponse: URLResponse?, error: Error?) throws -> Model {
        self.data = data
        self.urlResponse = urlResponse
        self.error = error
        
        switch expectedResult {
        case let .success(model):
            return model
        case let .failure(error):
            throw error
        }
    }
}
