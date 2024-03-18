//
//  ViewController.swift
//  PersonalQuize
//
//  Created by user on 09.03.2024.
//

import UIKit

final class QuestionsViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var questionProgressView: UIProgressView!
    
    
    @IBOutlet var singleStackView: UIStackView!
    @IBOutlet var singleButtons: [UIButton]!
    
    
    @IBOutlet var multipleStackView: UIStackView!
    @IBOutlet var multipleLabels: [UILabel]!
    @IBOutlet var multipleSwitches: [UISwitch]!
    
    
    @IBOutlet var rangedStackView: UIStackView!
    @IBOutlet var rangedSlider: UISlider!
    @IBOutlet var rangedLabels: [UILabel]!
    
    
    // MARK: - Private properties
    private let questions = Question.getQuestions()
    private var answersChosen: [Answer] = [] // этот массив надо передать на другой экран через метод препаре фор сигвей. этого метода нет, его надо реализовать, взять массив передать на другой экран, на экране ресалт он инициализируется, имея данные из этого массива необходимо перебрать его, извлечь из массива животных и определть какие животные хранятся
    // взять массив ансверчоузен и перебрать его извлекая животных которых выбирал пользователь, определить из полувшихся какое животное чаще выбиралось и передать его на экран в лейбл
    private var questionIndex = 0
    private var currentAnswer: [Answer]{
        questions[questionIndex].answers
    }
    

    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        let answerCount = Float(currentAnswer.count - 1)//количество ответов для бегунка в 3 вопросе
        rangedSlider.maximumValue = answerCount
        rangedSlider.value = answerCount / 2
        
            
    }
    
    
    //MARK: - Method prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResult" {
            if let resultVC = segue.destination as? ResultViewController {
                resultVC.answersChosen = self.answersChosen
            }
        }
    }

    
    // MARK: - IB Actions
    @IBAction func singelAnswerButtonPressed(_ sender: UIButton) {
        guard let buttonIndex = singleButtons.firstIndex(of: sender) else { return }
        let currentAnswer = currentAnswer [buttonIndex] // извлекаем текущий ответ
        answersChosen.append(currentAnswer)
        nextQuestion()// метод определяет будет следующий вопрос или переход на другой экран
    }
    
    
    @IBAction func multipleAnswerButtonPressed(_ sender: Any) {
        for (multipleSwitch, answer) in zip(multipleSwitches, currentAnswer) {
            if multipleSwitch.isOn {
                answersChosen.append(answer)
                
            }
        }
        nextQuestion()
    }
    
    
    @IBAction func rangedAnswerButtonPressed(_ sender: Any) {
        let index = lrintf(rangedSlider.value)
        answersChosen.append(currentAnswer[index])
        nextQuestion()
    }

    
    deinit {
        print("\(type(of: self)) has been deallocated")
    }
}



// MARK: - Private Methods
private extension QuestionsViewController {
   func updateUI() {
       // Hide everything
       for stackView in [singleStackView, multipleStackView, rangedStackView] {
           stackView?.isHidden = true
           
       }
       // Set navigation title
       title = "Вопрос № \(questionIndex + 1) из \(questions.count)"
       
       // Get current question
       let currentQuestion = questions[questionIndex]
       
       // Set current question for question label
       questionLabel.text = currentQuestion.title
       
       // Calculate progress
       let totalProgress = Float(questionIndex) / Float(questions.count)
       
       
       // Set progress for questionProgressView
       questionProgressView.setProgress(totalProgress, animated: true)
       
       
       // Show stacks corresponding to question type
       showCurrentAnswers(for: currentQuestion.type)
       
   }
    
    
    /// Choice of answers category
    ///
    /// Displaying answers to a question according to a category
    ///
    /// - Parameter type: Specifies the category of responses
    func showCurrentAnswers(for type: ResponseType ) {
        switch type {
        case .single: showSingleStackView(with: currentAnswer) //вызываем метод
        case .multiple: showMultipleStackView(with: currentAnswer)
        case .ranged: showRangeStackView(with: currentAnswer)
        }
    }
    
    func showSingleStackView(with answers: [Answer]) {
        singleStackView.isHidden.toggle()
        
        for (button, answer) in zip(singleButtons, answers) {
            button.setTitle(answer.title, for: .normal) //сопоставили ответы с кнопками
        }
    }
    
    func showMultipleStackView(with answers: [Answer]) {
        multipleStackView.isHidden.toggle()
        
        for (label, answer) in zip(multipleLabels, answers) {
            label.text = answer.title
        }
    }
    
    func showRangeStackView(with answers: [Answer]) {
        rangedStackView.isHidden.toggle()
        
        rangedLabels.first?.text = answers.first?.title
        rangedLabels.last?.text = answers.last?.title
    }
    
    
    // метод опредляет будет след вопрос или мы дошли до конца
    func nextQuestion() {
        questionIndex += 1//когда пользователь нажимает на кнопку для перехода к следующему вопросу
        
        if questionIndex < questions.count { // сравнивает текущий индекс с количеством элементов в массиве
            updateUI()//если не закончили со всеми вопросами, то вызываем этот метод
            return
        }
        //если не попали в предыдущее условие, то переходим на следующий экран
        performSegue(withIdentifier: "showResult", sender: nil)
    }
    
    
}
