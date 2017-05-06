import Foundation
import Moya

enum ImageService {
    case random
}

extension ImageService: TargetType {
    var baseURL: URL { return URL(string: "https://unsplash.it")! }
    var path : String {
        switch self {
        case .random:
            return "/750/1134/"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var parameters: [String: Any]? {
        return ["random": true, "gravity" : "center"]
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
