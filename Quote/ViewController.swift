import UIKit
import Moya
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!

    @IBOutlet weak var quoteLabel: UILabel!

    @IBOutlet weak var authorLabel: UILabel!

    let disposeBag = DisposeBag()
    let imageProvider = RxMoyaProvider<ImageService>(plugins: [NetworkLoggerPlugin(verbose: true)])
    let quoteProvider = RxMoyaProvider<QuoteService>(plugins: [NetworkLoggerPlugin(verbose: true)])

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchAndDisplayRandomImage()
        fetchAndDisplayRandomQuote()
    }

    private func fetchAndDisplayRandomImage() {
        imageProvider.request(.random)
            .mapImage()
            .subscribe(onNext: { image in
                self.backgroundImage.image = image
                self.backgroundImage.tintColor = UIColor.black
            })
            .addDisposableTo(disposeBag)
    }

    private func fetchAndDisplayRandomQuote() {
        quoteProvider.request(.random)
            .mapJSON()
            .subscribe(onNext: { response in
                if let json = response as? [String: String] {
                    let quote = json["quoteText"]?.replacingOccurrences(of: "\\", with: "")

                    self.quoteLabel.text = "\"\(quote!.trimmingCharacters(in: .whitespaces))\""
                    if let author = json["quoteAuthor"] {
                        self.authorLabel.text = author
                    }
                    else {
                        self.authorLabel.text = "Unknown"
                    }
                } else {
                    self.authorLabel.text = "Unknown"
                }
            })
            .addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
