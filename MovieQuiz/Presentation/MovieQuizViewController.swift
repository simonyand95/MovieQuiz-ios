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
    private var statisticServiceImplementation: StatisticService?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionLabel.font = UIFont(name:"YSDisplay-Bold",size:23)
        titleCounterLabel.font = UIFont(name:"YSDisplay-Medium",size:20)
        questionTitleLabel.font = UIFont(name:"YSDisplay-Medium",size:20)
        yesButton.titleLabel?.font = UIFont(name:"YSDisplay-Medium",size:20)
        noButton.titleLabel?.font = UIFont(name:"YSDisplay-Medium",size:20)
        
        questionFactory = QuestionFactory(delegate: self)
        alertPresenter = AlertPresenter(vc: self)
        statisticServiceImplementation = StatisticServiceImplementation()
        
        questionFactory?.requestNextQuestion()
        //UserDefaults.standard.set(true, forKey: "viewDidLoad")
        var jsonURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        jsonURL.appendPathComponent("top250MoviesIMDB.json")
        if FileManager.default.fileExists(atPath: jsonURL.path) {
            let jsonString = try? String(contentsOf: jsonURL)
            guard let json = jsonString else {return }
            let data = json.data(using: .utf8)!
            let movieItems = try? JSONDecoder().decode(Top.self, from: data)
          
      }

    }
    
    // MARK: - QuestionFactoryDelegate
    private func makeButtonsInactive() {
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    private func makeButtonsActive() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
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
        
        let competion: (() -> Void) =  {
         self.allAmountOfCorrectAnswers = 0
         self.currentQuestionIndex = 0
         self.questionFactory?.requestNextQuestion()
         self.makeButtonsActive()
             }

        
        if currentQuestionIndex ==  questionsAmount - 1 {
            statisticServiceImplementation!.store(correct: allAmountOfCorrectAnswers, total: questionsAmount, date: Date())
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "dd.MM.YY hh:mm"
           
            statisticServiceImplementation!.bestGame = GameRecord(correct: UserDefaults.standard.integer(forKey: "recordCountCorrect"), total:
                                                                    UserDefaults.standard.integer(forKey: "recordTotalAmount"), date:  UserDefaults.standard.object(forKey: "recordDate") as! Date)
            

            
            let alertModel = AlertModel(title: "Этот раунд окончен!",
                                        message: "Ваш результат: \(allAmountOfCorrectAnswers) из \(questionsAmount) \n Количество сыгранных квизов: \(String(describing: statisticServiceImplementation!.gamesCount))  \n Рекорд: \(String(describing: statisticServiceImplementation!.bestGame.correct)) / \(String(describing: statisticServiceImplementation!.bestGame.total)) (\(dateFormatterPrint.string(from: statisticServiceImplementation!.bestGame.date)) ) \n Средняя точность: \(String(format: "%.2f", statisticServiceImplementation!.totalAccuracy))%",
                                        buttonText: "Сыграть ещё раз",
                                        completion: competion)
            alertPresenter?.show(model: alertModel)
            
        } else {
            makeButtonsActive()
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
        makeButtonsInactive()
    }
    
    //Нажатие на кнопку "нет"
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        if currentQuestion.correctAnswer == false {isCorrect = true} else {isCorrect = false}
        showAnswerResult(isCorrect: isCorrect)
        makeButtonsInactive()
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
