//
//  ResultViewController.swift
//  PersonalQuize
//
//  Created by user on 09.03.2024.
//

import UIKit

final class ResultViewController: UIViewController {
    var questions: Question!
    var answersChosen: [Answer] = []

    var animals: [String] = [] //массив в котором собираю животных из массива chosenAnswers
    var countAnimals: [String: Int] = [:] //в массиве считаю животных
    var animalsChosen: [String] = [] //здесь повторяющиеся значения
    
    var animalCharacter: [Character] = [] //в массив собираю эмодзи
    var countAnimalsCharacter: [Character: Int] = [:]
    var animalChosenCharacter: [Character] = []
    
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var resultCharacter: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        for answer in answersChosen {
            let animal = answer.animal.definition
            animals.append(animal)
        }
        
        //здесь собираю эмодзи
        for answer in answersChosen {
            let animal = answer.animal
            animalCharacter.append(animal.rawValue)
        }
        
        
        for animal in animals {
            if let count = countAnimals[animal] {
                countAnimals[animal] = count + 1
            } else {
                countAnimals[animal] = 1
            }
        }
        
        
        // здесь считаю эмодзи
        for animal in animalCharacter {
            if let count = countAnimalsCharacter[animal] {
                countAnimalsCharacter[animal] = count + 1
            } else {
                countAnimalsCharacter[animal] = 1
            }
        }
        
        let duplicates = countAnimals.filter { $0.value > 1 }
        let repeatedValues = duplicates.map { $0.key }
        
        
        let duplicatesCharacter = countAnimalsCharacter.filter { $0.value > 1 }
        let repeatedValuesCharacter = duplicatesCharacter.map { $0.key }
        
        resultLabel.text = "Вы \(repeatedValues) "
        resultCharacter.text = "Вы \(repeatedValuesCharacter)"
         

    }
    
    

    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    
    
    deinit {
        print("\(type(of: self)) has been deallocation")
    }
}
