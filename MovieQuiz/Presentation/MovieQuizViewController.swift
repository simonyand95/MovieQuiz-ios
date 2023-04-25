import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol  {
    
    // MARK: - Lifecycle
    
   // private let questionsAmount: Int = 10
   // private var questionFactory: QuestionFactoryProtocol?
    //private var currentQuestion: QuizQuestion?
   // private var isCorrect: Bool = true
    //private var allAmountOfCorrectAnswers: Int = 0
    private var resultText: String = ""
 //   private var currentQuestionIndex: Int = 0
   // private var alertPresenter: AlertPresenterProtocol?
   // private var statisticServiceImplementation: StatisticService?
    private var presenter: MovieQuizPresenter!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewController: self)
       // presenter.viewController = self
        questionLabel.font = UIFont(name:"YSDisplay-Bold",size:23)
        titleCounterLabel.font = UIFont(name:"YSDisplay-Medium",size:20)
        questionTitleLabel.font = UIFont(name:"YSDisplay-Medium",size:20)
        yesButton.titleLabel?.font = UIFont(name:"YSDisplay-Medium",size:20)
        noButton.titleLabel?.font = UIFont(name:"YSDisplay-Medium",size:20)
        
        //questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
       // alertPresenter = AlertPresenter(vc: self)
       // statisticServiceImplementation = StatisticServiceImplementation()
        
        showLoadingIndicator()
       // questionFactory?.loadData()
      }


    
    // MARK:
    /*  func makeButtonsInactive() {
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    
    func makeButtonsActive() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    */
    
    
 /*   func didLoadDataFromServer() {
            activityIndicator.isHidden = true // скрываем индикатор загрузки
            questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
        
    }
    
   func didReceiveNextQuestion(question: QuizQuestion?) {
   presenter.didRecieveNextQuestion(question: question)
        }*/
    
    // функция выводящая каритинку и вопрос на экран
 /*   func show(quiz step: QuizStepViewModel) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
        imageView.image = step.image
        questionLabel.text = step.question
        titleCounterLabel.text = step.questionNumber
        //print(step.questionNumber)
        
    }*/
    
    
    //Функция показывающая результат ответ (верно - зеленый, не верно - красный)
 /*   func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8 // толщина рамки
        if isCorrect {
            presenter.allAmountOfCorrectAnswers += 1
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
        } else
        {
            imageView.layer.borderColor = UIColor.ypRed.cgColor}
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                    guard let self = self else { return }
                    self.presenter.showNextQuestionOrResults()
                }
    }*/
    
  /*
    func show(quiz result: QuizResultsViewModel) {
        
        let alert = UIAlertController(title: result.text, // заголовок всплывающего окна
                                      message: result.buttonText, // текст во всплывающем окне
                                      preferredStyle: .alert) // preferredStyle может быть .alert или .actionSheet

        // создаём для него кнопки с действиями
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            self.presenter.restartGame()
        }

        // добавляем в алерт кнопки
        alert.addAction(action)

        // показываем всплывающее окно
        self.present(alert, animated: true, completion: nil)
    }
    */
    
    
    
    func show(quiz step: QuizStepViewModel) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = step.image
        questionLabel.text = step.question
        titleCounterLabel.text = step.questionNumber
    }

        func show(quiz result: QuizResultsViewModel) {
            let message = presenter.makeResultsMessage()

            let alert = UIAlertController(
                title: result.title,
                message: message,
                preferredStyle: .alert)

                let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
                    guard let self = self else { return }

                    self.presenter.restartGame()
                }

            alert.addAction(action)

            self.present(alert, animated: true, completion: nil)
        }
    
    
    /* private func showNextQuestionOrResults() {
        
      
         let competion: (() -> Void) =  {
         self.allAmountOfCorrectAnswers = 0
         self.presenter.resetQuestionIndex()
         self.questionFactory?.requestNextQuestion()
         self.makeButtonsActive()
             }

        
        if presenter.isLastQuestion() {
            statisticServiceImplementation!.store(correct: allAmountOfCorrectAnswers, total: presenter.questionsAmount, date: Date())
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "dd.MM.YY hh:mm"
           
            statisticServiceImplementation!.bestGame = GameRecord(correct: UserDefaults.standard.integer(forKey:  Keys.bestGameCountCorrect.rawValue),
                                                                  total:
                                                                    UserDefaults.standard.integer(forKey: Keys.bestGameTotalAmount.rawValue),
                                                                  date:  UserDefaults.standard.object(forKey: Keys.bestGameDate.rawValue) as! Date)
            

            let thisBestGame = statisticServiceImplementation!.bestGame
            
            
            let alertModel = AlertModel(title: "Этот раунд окончен!",
                                        message: "Ваш результат: \(allAmountOfCorrectAnswers) из \(presenter.questionsAmount) \n Количество сыгранных квизов: \(String(describing: statisticServiceImplementation!.gamesCount))  \n Рекорд: \(String(describing: thisBestGame.correct)) / \(String(describing: thisBestGame.total)) (\(dateFormatterPrint.string(from: thisBestGame.date)) ) \n Средняя точность: \(String(format: "%.2f", statisticServiceImplementation!.totalAccuracy))%",
                                        buttonText: "Сыграть ещё раз",
                                        completion: competion)
            alertPresenter?.show(model: alertModel)
            
        } else {
            makeButtonsActive()
            presenter.switchToNextQuestion()
            // увеличиваем индекс текущего урока на 1; таким образом мы сможем получить следующий урок
            questionFactory?.requestNextQuestion()
            // показать следующий вопрос
        }
       }*/

    
    
    @IBOutlet weak var noButton: UIButton!
    
    @IBOutlet weak var yesButton: UIButton!
    
    
    
    //Нажатие на кнопку "да"
    @IBAction private func yesButtonClicked(_ sender: UIButton){
       //presenter.currentQuestion = currentQuestion
        presenter.yesButtonClicked()
       // makeButtonsInactive()
    }
    
    //Нажатие на кнопку "нет"
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
      //  makeButtonsInactive()
    }
    
    @IBOutlet private var imageView: UIImageView!
    
    @IBOutlet private var titleCounterLabel: UILabel!
    
    @IBOutlet weak var questionTitleLabel: UILabel!
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    func hideLoadingIndicator() {
            activityIndicator.isHidden = true
        }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()

        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert)

            let action = UIAlertAction(title: "Попробовать ещё раз",
            style: .default) { [weak self] _ in
                guard let self = self else { return }

                self.presenter.restartGame()
            }

        alert.addAction(action)
    }
}
