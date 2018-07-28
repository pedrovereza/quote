import Foundation
import Moya

enum QuoteService {
    case random
}

extension QuoteService: TargetType {
    var headers: [String : String]? {
        return nil
    }

    var baseURL: URL { return URL(string: "http://api.forismatic.com")! }
    var path : String {
        switch self {
        case .random:
            return "/api/1.0/"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var sampleData: Data {
        return "Something went wrong".data(using: .utf8)!
    }

    var task: Task {
        return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }

    var validate: Bool {
        return true
    }

    private var parameters: [String: Any] {
        return ["method": "getQuote",
                "format": "json",
                "lang": "en"
        ]
    }
}
