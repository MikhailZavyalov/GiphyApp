import UIKit

// Экран на котором показываются гифки
final class GiphyViewController: UIViewController {
    // Переменная Int -- Счетчик залайканых или задизлайканных гифок
    // Например shownGifCounter -- счетчика показанных гифок
    private var shownGifCounter: Int = 0
    // Переменная Int -- Количество понравившихся гифок
    // Например likedGifCounter -- счетчик любимых гифок
    private var likedGifCounter: Int = 0
    private let gifsAmount: Int = 10
    private var alertPresenter: AlertPresenter = AlertPresenter()
    // @IBOutlet UILabel для счетчика гифок, например 1/10
    // Например -- @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    // @IBOutlet UIImageView для Гифки
    // Например -- @IBOutlet weak var giphyImageView: UIImageView!
    @IBOutlet weak var gifWordLabel: UILabel!
    @IBOutlet weak var giphyImageView: UIImageView!
    // @IBOutlet UIActivityIndicatorView загрузки гифки, так как она может загрухаться долго
    @IBOutlet weak var giphyActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    // Нажатие на кнопку лайка
    @IBAction func onYesButtonTapped() {
        // Проверка на то просмотрели или нет 10 гифок
        presenter.saveGif(giphyImageView.image)
        likedGifCounter += 1
        showEndOfGiphy()
        showBorder(color: .ypGreen)
        // Если все 10 гифок просомтрели необходимо показать UIAlertController о завершении
        // При нажатии на кнопку в UIAlertController необходимо сбросить счетчики и начать сначала
        
        // Иначе, если еще не просмотрели 10 гифок, то увеличиваем счетчик и обновляем UIlabel с счетчиком
        
        // Сохраняем понравившуюся гифку
        // presenter.saveGif(<Созданный UIImageView для @IBOutlet>.image)
        // Например -- presenter.saveGif(giphyImageView.image)
        // Загружаем следующую гифку
        if shownGifCounter < gifsAmount {
            presenter.fetchNextGiphy()
        }
    }
    
    // Нажатие на кнопку дизлайка
    @IBAction func onNoButtonTapped() {
        // Проверка на то просмотрели или нет 10 гифок
        showEndOfGiphy()
        showBorder(color: .ypRed)
        
        // Если все 10 гифок просомтрели необходимо показать UIAlertController о завершении
        // При нажатии на кнопку в UIAlertController необходимо сбросить счетчики и начать
        
        // Иначе, если еще не просмотрели 10 гифок, то увеличиваем счетчик и обновляем UIlabel с счетчиком
        
        // Загружаем следующую гифку
        
        if shownGifCounter < gifsAmount {
            presenter.fetchNextGiphy()
        }
    }
    
    // Слой Presenter - бизнес логика приложения, к которым должен общаться UIViewController
    private lazy var presenter: GiphyPresenterProtocol = {
        let presenter = GiphyPresenter()
        presenter.viewController = self
        return presenter
    }()
    
    // MARK: - Жизенный цикл экрана
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gifWordLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        gifWordLabel.textColor = UIColor(named: "YPWhite")
        counterLabel.textColor = UIColor(named: "YPWhite")
        giphyImageView.layer.cornerRadius = 10
        yesButton.layer.cornerRadius = 10
        noButton.layer.cornerRadius = 10
        restart()
    }
}


// MARK: - Приватные методы

private extension GiphyViewController {
    // Учеличиваем счетчик просмотренных гифок на 1
    // Обновляем UILabel который находится в верхнем UIStackView и отвечает за количество просмотренных гифок
    // Обновляем счетчик просмотренных гифок UIlabel
    func updateCounterLabel() {
        shownGifCounter += 1
        counterLabel.text = "\(shownGifCounter)/\(gifsAmount)"
    }
    
    func showBorder(color: UIColor) {
        giphyImageView.layer.borderWidth = 10
        
        UIView.animateKeyframes(withDuration: 0.5, delay: 0) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) { [self] in
                giphyImageView.layer.borderColor = color.cgColor
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) { [self] in
                giphyImageView.layer.borderColor = UIColor.clear.cgColor
            }
        }
    }
    
    // Перезапускаем счетчики просмотренных гифок и понравивишихся гифок
    // Обновляем UILabel который находится в верхнем UIStackView и отвечает за количество просмотренных гифок
    // Загружаем гифку
    func restart() {
        giphyImageView.layer.borderColor = UIColor.clear.cgColor
        shownGifCounter = 0
        updateCounterLabel()
        likedGifCounter = 0
        presenter.fetchNextGiphy()
    }
}

// MARK: - GiphyViewControllerProtocol

extension GiphyViewController: GiphyViewControllerProtocol {
    // Показ ошибки UIAlertController, что не удалось загрузить гифку
    func showError() {
        // Необходимо показать UIAlertController
        // Заголовок -- Что-то пошло не так(
        // Сообщение -- не возможно загрузить данные
        // Кнопка -- Попробовать еще раз
        //
        // При нажатии на кнопку необходимо перезагрузить гифку
        let errorAlertModel = AlertModel(
            title: "Что-то пошло не так(",
            message: "невозможно загрузить данные",
            buttonText: "Попробовать ещё раз"
        ) { [weak self] in
            guard let self = self else {
                return
            }
            self.presenter.fetchNextGiphy()
        }
        alertPresenter.present(alert: errorAlertModel, presentingViewController: self)
    }
    
    func showEndOfGiphy() {
        guard shownGifCounter == gifsAmount else {
            updateCounterLabel()
            presenter.fetchNextGiphy()
            return
        }
        // Необходимо показать UIAlertController
        // Заголовок -- Мемы закончились!
        // Сообщение -- Вам понравилось: \(n)\\10
        // Кнопка -- Хочу посмотреть еще гифок
        //
        // При нажатии сбросить все счетчики -- вызов метода restart
        let alertModel = AlertModel(title: "Мемы закончились!", message: "Вам понравилось: \(likedGifCounter)/\(gifsAmount)", buttonText: "Хочу посмотреть ещё гифок", completion: { [weak self] in
            guard let self = self else { return }
            self.restart()
        })
        alertPresenter.present(alert: alertModel, presentingViewController: self)
    }
    
    // Показать гифку UIImage
    func showGiphy(_ image: UIImage?) {
        giphyImageView.image = image
    }
    
    // Показать лоадер
    // Присвоить UIImageView.image = nil
    // Вызвать giphyActivityIndicatorView показа индикатора загрузки
    func didStartLoading() {
        // presenter.saveGif(<Созданный UIImageView для @IBOutlet>.image)
        // Например -- presenter.saveGif(giphyImageView.image)
        yesButton.isEnabled = false
        noButton.isEnabled = false
        giphyImageView.image = nil
        giphyActivityIndicatorView.startAnimating()
    }
    
    // Остановить giphyActivityIndicatorView показа индикатора загрузки
    func didFinishLoading() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
        giphyActivityIndicatorView.stopAnimating()
    }
}
