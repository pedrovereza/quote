import UIKit
import Moya
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!

    @IBOutlet weak var quoteLabel: UILabel!

    @IBOutlet weak var authorLabel: UILabel!

    @IBOutlet weak var refreshButton: UIButton!

    var image: Variable<UIImage> = Variable(UIImage())
    var quote: Variable<String> = Variable("")
    var author: Variable<String> = Variable("Unknown")

    let disposeBag = DisposeBag()
    let imageProvider = RxMoyaProvider<ImageService>(plugins: [NetworkLoggerPlugin(verbose: true)])
    let quoteProvider = RxMoyaProvider<QuoteService>(plugins: [NetworkLoggerPlugin(verbose: true)])

    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundImage.tintColor = UIColor.black

        setupImageBinding()
        setupQuoteBinding()

        refresh()
    }

    private func setupImageBinding() {
        image
            .asObservable()
            .bind(to: backgroundImage.rx.image)
            .addDisposableTo(disposeBag)
    }

    private func setupQuoteBinding() {
        quote
            .asObservable()
            .bind(to: quoteLabel.rx.text)
            .addDisposableTo(disposeBag)

        author
            .asObservable()
            .bind(to: authorLabel.rx.text)
            .addDisposableTo(disposeBag)
    }

    private func refresh() {
        fetchRandomImage()
        fetchRandomQuote()
    }

    private func fetchRandomImage() {
        imageProvider.request(.random)
            .mapImage()
            .subscribe(onNext: { image in
                if let image = image {
                    self.image.value = image
                }
            })
            .addDisposableTo(disposeBag)
    }

    private func fetchRandomQuote() {
        quoteProvider.request(.random)
            .mapJSON()
            .subscribe(onNext: { response in
                if let json = response as? [String: String] {
                    let quote = json["quoteText"]?.replacingOccurrences(of: "\\", with: "")

                    self.quote.value = "\"\(quote!.trimmingCharacters(in: .whitespaces))\""
                    if let author = json["quoteAuthor"] {
                        self.author.value = author
                    }
                    else {
                        self.author.value = "Unknown"
                    }
                } else {
                    self.author.value = "Unknown"
                }
            })
            .addDisposableTo(disposeBag)
    }

    @IBAction func refreshContent(_ sender: Any) {
        refresh()
    }
}
