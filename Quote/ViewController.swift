import UIKit
import Moya

class ViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!

    @IBOutlet weak var quoteLabel: UILabel!

    @IBOutlet weak var authorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let imageProvider = MoyaProvider<ImageService>(plugins: [NetworkLoggerPlugin(verbose: true)])
        let quoteProvider = MoyaProvider<QuoteService>(plugins: [NetworkLoggerPlugin(verbose: true)])

        imageProvider.request(.random) { result in
            switch result {
            case let .success(moyaResponse):
                self.backgroundImage.image = try! moyaResponse.mapImage()
                self.backgroundImage.tintColor = UIColor.black
            case let .failure(error):
                print(error)
            }
        }

        quoteProvider.request(.random) { result in
            switch result {
            case let .success(response):
                let json = try! response.mapJSON() as? [String: String]

                let quote = json?["quoteText"]

                self.quoteLabel.text = "\"\(quote!.trimmingCharacters(in: .whitespaces))\""
                if let author = json?["quoteAuthor"] {
                    self.authorLabel.text = author
                }
                else {
                    self.authorLabel.text = "Unknown"
                }

            case let .failure(error):
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
