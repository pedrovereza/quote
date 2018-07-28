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
    let imageProvider = MoyaProvider<ImageService>()
    let quoteProvider = MoyaProvider<QuoteService>()

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
            .disposed(by: disposeBag)
    }

    private func setupQuoteBinding() {
        quote
            .asObservable()
            .bind(to: quoteLabel.rx.text)
            .disposed(by: disposeBag)

        author
            .asObservable()
            .bind(to: authorLabel.rx.text)
            .disposed(by: disposeBag)
    }

    private func refresh() {
        fetchRandomImage()
        fetchRandomQuote()
    }

    private func fetchRandomImage() {
        imageProvider.rx.request(.random)
            .mapImage()
            .subscribe({ event in
                switch event {
                case .success(let image):
                    if let image = image {
                        self.image.value = image
                    }
                    break

                case .error(_):
                    break
                }
            })
            .disposed(by: disposeBag)
    }

    private func fetchRandomQuote() {
        quoteProvider.rx.request(.random)
            .mapJSON()
            .subscribe({ event in
                switch event {
                case .success(let response):
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
                    break
                case .error(_):
                    break
                }
            })
            .disposed(by: disposeBag)
    }

    @IBAction func refreshContent(_ sender: Any) {
        refresh()
    }
}
