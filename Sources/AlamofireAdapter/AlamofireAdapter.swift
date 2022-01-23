import NetworkingCore
import Alamofire
import Foundation

public class AlamofireAdapter: NetworkAdapterType {
    public typealias DataTaskType = Void
    
    public func execute<T: NetworkRequestType>(request: T, completion: @escaping (Result<T.ResponseType, Error>) -> Void) throws -> DataTaskType {
        
        AF.request(request.urlRequest)
            .responseData { response in
                do {
                    let parsedResponse = try request.parseResponse(data: response.data, urlResponse: response.response, error: response.error)
                    completion(.success(parsedResponse))
                } catch {
                    completion(.failure(error))
                }
                
            }
    }
}

public extension URLRequest {
    /// Returns the `httpMethod` as Alamofire's `HTTPMethod` type.
    var method: HTTPMethod? {
        get { return httpMethod.flatMap(HTTPMethod.init) }
        set { httpMethod = newValue?.rawValue }
    }
}
