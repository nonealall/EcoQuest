import UIKit

enum GameLevel {
    case recycling
    case energyConservation
    case wildlifeConservation
}

class GameViewController: UIViewController {
    
    var currentLevel: GameLevel = .recycling
    
    var score: Int = 0
    
    let levelLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Level: Recycling"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let scoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Score: 0"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let playButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Play", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 10
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
    }
    
    private func setupViews() {
        view.addSubview(levelLabel)
        view.addSubview(scoreLabel)
        view.addSubview(playButton)
        
        NSLayoutConstraint.activate([
            levelLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            levelLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            scoreLabel.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: 16),
            scoreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 100),
            playButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func playButtonTapped() {
        switch currentLevel {
        case .recycling:
            playRecyclingLevel(on: view)
        case .energyConservation:
            playEnergyConservationLevel()
        case .wildlifeConservation:
            playWildlifeConservationLevel()
        }
    }
    
    struct Question {
        let text: String
        let answers: [String]
        let correctAnswer: Int
    }
    
    private var currentQuestionIndex = 0
    
    private var score = 0
    
    private func playRecyclingLevel(on view: UIView) {
        // set up questions and answers about recycling
        let question1 = Question(text: "What items should be recycled?", answers: ["Plastic bottles", "Styrofoam cups", "Pizza boxes"], correctAnswer: 0)
        let question2 = Question(text: "What is a common mistake people make when recycling?", answers: ["Putting recyclables in the trash", "Recycling dirty containers", "Leaving caps on bottles"], correctAnswer: 1)
        let question3 = Question(text: "How can you reduce waste when grocery shopping?", answers: ["Use reusable bags", "Buy single-use plastics", "Get plastic bags at checkout"], correctAnswer: 0)
        let question4 = Question(text: "Recyclables should be bagged, not loose.", answers: ["True","False", "Depends on the type of material"], correctAnswer: 0)
        let question5 = Question(text: "How long does it take for a typical glass bottle to decompose?", answers: ["200 years", "1500 years", "4000 years"], correctAnswer: 2)
        
        let question6 = Question(text: "Which of the sources listed are not considered sources of renewable energy?", answers: ["Hydropower","Wind","Natural gas"], correctAnswer: 2)
        let question7 = Question(text: "Which of the following is the fastest growing renewable energy sector globally?", answers: ["Solar","Biomass", "Geothermal"], correctAnswer: 0)
        let question8 = Question(text: "How many countries could run solely on wind, solar, and water power by 2050", answers: ["70", "110", "140"], correctAnswer: 2)
        let question9 = Question(text: "Which of the countries listed produce the most solar energy?", answers: ["USA", "China", "Denmark"], correctAnswer: 1)
        let question10 = Question(text: "What percent of the world’s electricity comes from renewable sources?", answers: ["20%","30%", "40% "], correctAnswer: 1)
        
        // create an array of questions
        let questions = [question1, question2, question3,question4, question5, question6,question7, question8, question9,question10]
        
        // set up UI elements for displaying the current question and answer options
        let questionLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = questions[currentQuestionIndex].text
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.textAlignment = .center
            label.numberOfLines = 0
            return label
        }()
        
        let answerButtons: [UIButton] = {
            var buttons: [UIButton] = []
            for i in 0...2 {
                let button = UIButton()
                button.translatesAutoresizingMaskIntoConstraints = false
                button.setTitleColor(.white, for: .normal)
                button.backgroundColor = .systemGreen
                button.layer.cornerRadius = 10
                button.setTitle(questions[currentQuestionIndex].answers[i], for: .normal)
                button.tag = i
                button.addTarget(self, action: #selector(answerButtonTapped(_:)), for: .touchUpInside)
                buttons.append(button)
            }
            return buttons
        }()
        
        // set up UI elements for displaying the current score and progress
        let progressLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "\(currentQuestionIndex + 1)/\(questions.count)"
            label.font = UIFont.systemFont(ofSize: 16)
            label.textAlignment = .center
            return label
        }()
        
        let scoreLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Score: \(score)"
            label.font = UIFont.systemFont(ofSize: 16)
            label.textAlignment = .center
            return label
        }()
        
        // add subviews to the view hierarchy
        view.addSubview(questionLabel)
        NSLayoutConstraint.activate([
            questionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            questionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
        
        for (index, button) in answerButtons.enumerated() {
            view.addSubview(button)
            NSLayoutConstraint.activate([
                button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                button.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 32 + CGFloat(index) * 64),
                button.widthAnchor.constraint(equalToConstant: 200),
                button.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
        
        view.addSubview(progressLabel)
        NSLayoutConstraint.activate([
            progressLabel.centerXAnchor.constraint])
        
        // add progress and score labels
        view.addSubview(progressLabel)
        NSLayoutConstraint.activate([
            progressLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            progressLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
        
        view.addSubview(scoreLabel)
        NSLayoutConstraint.activate([
            scoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
        
        // set the current question label and answer buttons as the first subview to become first responder
        view.subviews.first?.becomeFirstResponder()
    }
    
    @objc private func answerButtonTapped(_ sender: UIButton) {
        guard let questions = getCurrentQuestions() else {
            return
        }
        // check if the selected answer is correct and update the score and progress labels
        if sender.tag == questions[currentQuestionIndex].correctAnswer {
            score += 1
            scoreLabel.text = "Score: \(score)"
        }
        currentQuestionIndex += 1
        progressLabel.text = "\(currentQuestionIndex + 1)/\(questions.count)"
        
        // check if there are any more questions, and if so, update the question label and answer buttons
        if currentQuestionIndex < questions.count {
            let question = questions[currentQuestionIndex]
            questionLabel.text = question.text
            for (index, button) in answerButtons.enumerated() {
                button.setTitle(question.answers[index], for: .normal)
            }
            view.subviews.first?.becomeFirstResponder()
        } else {
            // if there are no more questions, end the game and show the final score
            let alert = UIAlertController(title: "Game Over", message: "Your final score is \(score)!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
            }
    private func showAnswerDescription(for question: Question) {
        let description = question.answers[question.correctAnswer]
        let alert = UIAlertController(title: "Correct Answer", message: description, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    @objc private func answerButtonTapped(_ sender: UIButton) {
        let question = questions[currentQuestionIndex]
        if sender.tag == question.correctAnswer {
            score += 1
            scoreLabel.text = "Score: \(score)"
            showAnswerDescription(for: question)
        } else {
            showAnswerDescription(for: question)
        }
        currentQuestionIndex += 1
        if currentQuestionIndex < questions.count {
            questionLabel.text = questions[currentQuestionIndex].text
            for (index, button) in answerButtons.enumerated() {
                button.setTitle(questions[currentQuestionIndex].answers[index], for: .normal)
            }
            progressLabel.text = "\(currentQuestionIndex + 1)/\(questions.count)"
        } else {
            let alert = UIAlertController(title: "Game Over", message: "You have finished the level with a score of \(score) out of \(questions.count).", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }

    
    private func getCurrentQuestions() -> [Question]? {
        switch currentLevel {
        case .recycling:
            let question1 = Question(text: "What items should be recycled?", answers: ["Plastic bottles", "Styrofoam cups", "Pizza boxes"], correctAnswer: 0)
            let question2 = Question(text: "What is a common mistake people make when recycling?", answers: ["Putting recyclables in the trash", "Recycling dirty containers", "Leaving caps on bottles"], correctAnswer: 1)
            let question3 = Question(text: "How can you reduce waste when grocery shopping?", answers: ["Use reusable bags", "Buy single-use plastics", "Get plastic bags at checkout"], correctAnswer: 0)
            return [question1, question2, question3]
        case .energyConservation:
            let question1 = Question(text: "What is one way to conserve energy at home?", answers: ["Unplugging devices when not in use", "Leaving the lights on all night", "Using a space heater in the summer"], correctAnswer: 0)
            let question2 = Question(text: "What type of light bulb is the most energy-efficient?", answers: ["Incandescent", "LED", "Halogen"], correctAnswer: 1)
            let question3 = Question(text: "What appliance uses the most energy?", answers: ["Refrigerator", "Microwave", "Blender"], correctAnswer: 0)
            return [question1, question2, question3]
        }
    }
}
        

// define the Question struct
struct Question {
let text: String
let answers: [String]
let correctAnswer: Int
}

private func updateUIForCurrentQuestion() {
    let currentQuestion = questions[currentQuestionIndex]
    questionLabel.text = currentQuestion.text
    for (index, button) in answerButtons.enumerated() {
        button.setTitle(currentQuestion.answers[index], for: .normal)
        button.tag = index
        button.addTarget(self, action: #selector(answerButtonTapped(_:)), for: .touchUpInside)
    }
    progressLabel.text = "\(currentQuestionIndex + 1)/\(questions.count)"
    scoreLabel.text = "Score: \(score)"
}

@objc private func answerButtonTapped(_ sender: UIButton) {
    let currentQuestion = questions[currentQuestionIndex]
    if sender.tag == currentQuestion.correctAnswer {
        score += 10
    }
    currentQuestionIndex += 1
    if currentQuestionIndex < questions.count {
        updateUIForCurrentQuestion()
    } else {
        endRecyclingLevel()
    }
}

private func endRecyclingLevel() {
    let alertController = UIAlertController(title: "Congratulations!", message: "You have completed the Recycling level!", preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
}
private struct Question {
    let text: String
    let answers: [String]
    let correctAnswer: Int
}
   
    private func playEnergyConservationLevel() {
        // add game mechanics for energy conservation level
        // display questions about energy conservation and points for correct answers
        // update scoreLabel with the new score
        // if player reaches a certain score, go to the next level
        score += 10
        scoreLabel.text = "Score: \(score)"
        if score >= 30 {
            currentLevel = .wildlifeConservation
            levelLabel.text = "Level: Wildlife Conservation"
            score = 0
            scoreLabel.text = "Score: 0"
        }
    }
    
    private func playWildlifeConservationLevel() {
    // add game mechanics for wildlife conservation level
    // display questions about wildlife conservation and points for correct answers
    // update scoreLabel with the new score
    // if player completes all levels, show a message congratulating them on their environmental knowledge
    score += 10
    scoreLabel.text = "Score: (score)"
    if score >= 30 {
    let alertController = UIAlertController(title: "Congratulations!", message: "You have completed all levels and have shown a strong understanding of sustainability and environmental conservation!", preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alertController, animated: true, completion: nil)
    }
    }

