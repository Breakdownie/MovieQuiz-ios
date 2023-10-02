import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    
    //MARK: Properties
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    private let questionsAmount: Int = 10
    
    private lazy var questionFactory: QuestionFactoryProtocol = {
        QuestionFactory(delegate: self)
    }()
    
    private lazy var alertPresenter: AlertPresenter = {
        AlertPresenter(controller: self)
    }()
    
    private var currentQuestion: QuizQuestion?
    
    private var statisticsService: StatisticsService?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory.delegate = self
        alertPresenter = AlertPresenter(controller: self)
        statisticsService = StatisticsServiceImpl()
        questionFactory.requestNextQuestion()
    }
    
    // MARK: QuestionFactoryDelegate
    
    func didReceiveNextQuestion(_ question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    //MARK: Functions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let yesAnswer = true
        
        sender.isEnabled = false
        
        showAnswerResult(isCorrect: yesAnswer == currentQuestion.correctAnswer)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            sender.isEnabled = true
        }
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let noAnswer = false
        
        sender.isEnabled = false
        
        showAnswerResult(isCorrect: noAnswer == currentQuestion.correctAnswer)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            sender.isEnabled = true
        }
    }
    
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let modelImage = UIImage(named: model.image) ?? UIImage()
        let questionStep = QuizStepViewModel(image: modelImage,
                                             question: model.text,
                                             questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.imageView.layer.borderColor = UIColor.clear.cgColor
            self.showNextQuestionOrResults()
        }
        
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            showFinalResults()
        } else {
            currentQuestionIndex += 1
            questionFactory.requestNextQuestion()
        }
    }
    
    private func showFinalResults() {
        print("Показываем результаты")
        statisticsService?.store(correct: correctAnswers, total: questionsAmount)
        
        let alertModel = AlertModel(title: "Этот раунд окончен!",
                                    message: makeResultMessage(),
                                    buttonText: "Сыграть еще раз") { [weak self] in
            self?.currentQuestionIndex = 0
            self?.correctAnswers = 0
            self?.questionFactory.requestNextQuestion()
        }
        alertPresenter.show(model: alertModel)
    }
    
    private func makeResultMessage() -> String {
        guard let statisticsService = statisticsService, let bestGame = statisticsService.bestGame else {
            assertionFailure("error message")
            return ""
        }
        
        let accuracy = String(format: "%.2f", statisticsService.totalAccuracy)
        let currentGameResultLine = "Ваш результат: \(correctAnswers)\\\(questionsAmount)"
        let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticsService.gamesCount)"
        let bestGameInfoLine = "Рекорд: \(bestGame.correctAnswers)\\\(bestGame.totalAnswers)" + " " + "(\(bestGame.date.dateTimeString))"
        let averageAccuracyLine = "Средняя точность: \(accuracy)%"
        let components = [
            currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine]
        let resultMessage = components.joined(separator: "\n")
        
        return resultMessage
    }
    
}
