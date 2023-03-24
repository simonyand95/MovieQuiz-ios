import UIKit

final class MovieQuizViewController: UIViewController,  QuestionFactoryDelegate  {
    // MARK: - Lifecycle
    
    private let questionsAmount: Int = 3
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var isCorrect: Bool = true
    private var allAmountOfCorrectAnswers: Int = 0
    private var resultText: String = ""
    private var currentQuestionIndex: Int = 0
    private var alertPresenter: AlertPresenterProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionLabel.font = UIFont(name:"YSDisplay-Bold",size:23)
        titleCounterLabel.font = UIFont(name:"YSDisplay-Medium",size:20)
        questionTitleLabel.font = UIFont(name:"YSDisplay-Medium",size:20)
        yesButton.titleLabel?.font = UIFont(name:"YSDisplay-Medium",size:20)
        noButton.titleLabel?.font = UIFont(name:"YSDisplay-Medium",size:20)
        
        questionFactory = QuestionFactory(delegate: self)
        alertPresenter = AlertPresenter(vc: self)
        
        questionFactory?.requestNextQuestion()
    }
    
    // MARK: - QuestionFactoryDelegate

    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    // функция выводящая каритинку и вопрос на экран
    private func show(quiz step: QuizStepViewModel) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
        imageView.image = step.image
        questionLabel.text = step.question
        titleCounterLabel.text = step.questionNumber
        
    }
    
    
    //Функция показывающая результат ответ (верно - зеленый, не верно - красный)
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8 // толщина рамки
        if isCorrect {
            allAmountOfCorrectAnswers += 1
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
        } else
        {
            imageView.layer.borderColor = UIColor.ypRed.cgColor}
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
            self.imageView.layer.borderWidth = 0
        }
    }
    
    
    func show(quiz result: QuizResultsViewModel) {
        
        let alert = UIAlertController(title: result.text, // заголовок всплывающего окна
                                      message: result.buttonText, // текст во всплывающем окне
                                      preferredStyle: .alert) // preferredStyle может быть .alert или .actionSheet

        // создаём для него кнопки с действиями
        let action = UIAlertAction(title: "Сыграть еще раз", style: .default) { _ in
            self.allAmountOfCorrectAnswers = 0
            self.currentQuestionIndex = 0
            self.questionFactory?.requestNextQuestion()
        }

        // добавляем в алерт кнопки
        alert.addAction(action)

        // показываем всплывающее окно
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    private func showNextQuestionOrResults() {
        
        var competion: (() -> Void) =  {
         self.allAmountOfCorrectAnswers = 0
         self.currentQuestionIndex = 0
         self.questionFactory?.requestNextQuestion()
             }
        if currentQuestionIndex ==  questionsAmount - 1 {
            let alertModel = AlertModel(title: "Этот раунд окончен!",
                                        message: "Ваш результат: \(allAmountOfCorrectAnswers) из \(questionsAmount)",
                                        buttonText: "Сыграть ещё раз",
                                        completion: competion)
            alertPresenter?.show(model: alertModel)
               /* let text = "Ваш результат: \(allAmountOfCorrectAnswers) из \(questionsAmount)"
                let viewModel = QuizResultsViewModel(
                    title: "Этот раунд окончен!",
                    text: text,
                    buttonText: "Сыграть ещё раз")*/
              //  show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            // увеличиваем индекс текущего урока на 1; таким образом мы сможем получить следующий урок
            questionFactory?.requestNextQuestion()
            // показать следующий вопрос
        }
    }
    
    
    @IBOutlet weak var noButton: UIButton!
    
    @IBOutlet weak var yesButton: UIButton!
    
    
    
    //Нажатие на кнопку "да"
    @IBAction private func yesButtonClicked(_ sender: UIButton){
        guard let currentQuestion = currentQuestion else {
            return
        }
        if currentQuestion.correctAnswer == true {isCorrect = true} else {isCorrect = false}
        showAnswerResult(isCorrect: isCorrect)
    }
    
    //Нажатие на кнопку "нет"
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        if currentQuestion.correctAnswer == false {isCorrect = true} else {isCorrect = false}
        showAnswerResult(isCorrect: isCorrect)
    }
    
    @IBOutlet private var imageView: UIImageView!
    
    @IBOutlet private var titleCounterLabel: UILabel!
    
    @IBOutlet weak var questionTitleLabel: UILabel!
    
    @IBOutlet weak var questionLabel: UILabel!
    

    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        // Попробуйте написать код конвертации сами
        
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
}


    


   /* private let currentQuestion = questions[currentQuestionIndex]*/


    


/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
