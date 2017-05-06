import Foundation
import Moya

enum QuoteService {
    case random
}

extension QuoteService: TargetType {
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

    var parameters: [String: Any]? {
        return ["method": "getQuote",
                "format": "json",
                "lang": "en"
        ]
    }

    var sampleData: Data {
        return "Something went wrong".data(using: .utf8)!
    }

    var task: Task {
        return .request
    }

    var validate: Bool {
        return true
    }

    var parameterEncoding: ParameterEncoding { return URLEncoding.default }
}
