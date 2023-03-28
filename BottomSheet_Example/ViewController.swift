//  ViewController.swift
//  BottomSheet_Example
//
//  Created by Aleksej Shapran on 28.03.23

import UIKit

class ViewController: UIViewController {
    
    lazy var titleLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Wir lernen Deutsch! 👀"
        label.font = .systemFont(ofSize: 41, weight: .bold)
        label.numberOfLines = 2
        
        return label
    }()
    
    lazy var textView: UITextView = {
        
        let textView = UITextView(frame: .zero)
        textView.font = .systemFont(ofSize: 18, weight: .light)
        textView.isEditable = false
        textView.showsVerticalScrollIndicator = false
        textView.text = "Неме́цкий язы́к — национальный язык немцев, австрийцев, лихтенштейнцев, германошвейцарцев и американских немцев; официальный язык Германии, Австрии, Лихтенштейна, один из официальных языков Швейцарии, Люксембурга и Бельгии. Является одним из самых распространённых языков в мире после китайского, арабского, хинди, английского, испанского, бенгальского, португальского, французского, русского и японского. Немецкий язык занимает седьмое место (после английского, русского, испанского, турецкого, персидского, французского) по использованию в Интернете. Является самым распространённым языком в Западной Европе (более 90 миллионов носителей). Также немецкий — один из официальных и рабочих языков Европейского союза и ряда других международных организаций."
        
        return textView
    }()
    
    lazy var infoButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Узнать больше", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleShadowColor(.white, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = CGColor(red: 0/255, green: 80/255, blue: 200/255, alpha: 1)
        button.clipsToBounds = true
        
        return button
    }()
    
    lazy var startButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Начать обучение", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = view.tintColor
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
       
        return button
    }()
    
    lazy var containerStackView: UIStackView = {
        
        let spacer = UIView()
        let stackView = UIStackView(arrangedSubviews: [titleLabel, textView, spacer, startButton, infoButton])
        stackView.axis = .vertical
        stackView.spacing = 15
        
        return stackView
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureView()
        configureConstraints()
        
        // MARK: Actions
        
        infoButton.addTarget(self, action: #selector(presentModalController), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(startMessage), for: .touchUpInside)
    }
    
    @objc private func startMessage () {
        
        let message = UIAlertController(title: "Уведомление", message: "Вы уверены, что хотите начать обучение в ветке Немецкий язык?", preferredStyle: .actionSheet)
        message.addAction(UIAlertAction(title: NSLocalizedString("Да", comment: "Yes"), style: .default, handler: { _ in NSLog("YES button pressed.")}))
        message.addAction(UIAlertAction(title: NSLocalizedString("Нет", comment: "No"), style: .destructive, handler: { _ in NSLog("NO button pressed.")}))
            self.present(message, animated: true, completion: nil)
        }
    
    func configureView() {
        
        view.backgroundColor = .systemBackground
        
    }
    
    func configureConstraints() {
        
        view.addSubview(containerStackView)
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0),
            containerStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -19),
            containerStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 19),
            containerStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -19),
            infoButton.heightAnchor.constraint(equalToConstant: 55),
            startButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    @objc func presentModalController() {
        
        let vc = CustomModalViewController()
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
        
    }
}
