import UIKit

// Протокол для общения между Presenter и View слоями
protocol GiphyViewControllerProtocol: AnyObject {
    // Отображение ошибки при загрузке гифки
    func showError()

    // Отображение гифки
    func showGiphy(_ image: UIImage?)

    // Начать показывать индикатор загрузки гифки
    func didStartLoading()

    // Закончить показывать индикатор загрузки гифки
    func didFinishLoading()
}
