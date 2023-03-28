//  CustomModalViewController.swift
//  BottomSheet_Example
//
//  Created by Aleksej Shapran on 28.03.23

import UIKit

class CustomModalViewController: UIViewController {
    
    lazy var titleLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Немецкий язык"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        
        return label
    }()
    
    lazy var notesLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Немецкий язык восходит к прагерманскому языку, который, в свою очередь, является ответвлением от праиндоевропейского. Изменение фонетической и морфологической систем языка в результате второго передвижения согласных привело к его обособлению от родственных германских языков. В Средние века происходит формирование фонетики и морфологии, лексического строя и синтаксиса средневерхненемецкого, а за ним — ранненововерхненемецкого языка. Современный немецкий язык, история которого начинается примерно со второй половины XVII века, иначе называют нововерхненемецким языком. Большую роль в его становлении сыграли перевод Библии Мартина Лютера, творчество Иоганна Вольфганга фон Гёте, Фридриха Готлиба Клопштока и Иоганна Кристофа Готтшеда, лингвистические труды Иоганна Кристофа Аделунга, братьев Гримм и Конрада Дудена. 1 августа 1996 года в Германии были введены новые правила немецкой орфографии. Первый план реформы предусматривал замену ß на ss после кратких гласных (например, как в словах Fluss, muss, dass), однако эсцет сохранялся после долгих гласных и дифтонгов (Fuß, heiß). При образовании новых слов или форм основа слова сохраняется (nummerieren пишется с удвоенной mm, так как основа Nummer)."
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.textColor = .black
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var contentStackView: UIStackView = {
        
        let spacer = UIView()
        let stackView = UIStackView(arrangedSubviews: [titleLabel, notesLabel, spacer])
        stackView.axis = .vertical
        stackView.spacing = 13.0
        
        return stackView
    }()
    
    lazy var containerView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.9)
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        
        return view
    }()
    
    let maxDimmedAlpha: CGFloat = 0.6
    
    lazy var dimmedView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = maxDimmedAlpha
        
        return view
    }()
    
    let defaultHeight: CGFloat = 300
    let dismissibleHeight: CGFloat = 200
    let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 64
    var currentContainerHeight: CGFloat = 300
    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureView()
        configureConstraints()
        setupPanGesture()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCloseAction))
        dimmedView.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func handleCloseAction() {
        
        animateDismissView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        animateShowDimmedView()
        animatePresentContainer()
    }
    
    func configureView() {
        
        view.backgroundColor = .systemBlue.withAlphaComponent(0.4)
        
    }
    
    func configureConstraints() {
        
        view.addSubview(dimmedView)
        view.addSubview(containerView)
        
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(contentStackView)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 32),
            contentStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            contentStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 18),
            contentStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -18),
        ])
        
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
    }
    
    func setupPanGesture() {
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        
        view.addGestureRecognizer(panGesture)
        
    }
    
    // MARK: Pan gesture handler
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: view)
        print("Pan gesture y offset: \(translation.y)")
        
        let isDraggingDown = translation.y > 0
        print("Dragging direction: \(isDraggingDown ? "going down" : "going up")")
        
        let newHeight = currentContainerHeight - translation.y
        switch gesture.state {
        case .changed:
            if newHeight < maximumContainerHeight {
                containerViewHeightConstraint?.constant = newHeight
                view.layoutIfNeeded()
            }
        case .ended:
            if newHeight < dismissibleHeight {
                self.animateDismissView()
            }
            else if newHeight < defaultHeight {
                animateContainerHeight(defaultHeight)
            }
            else if newHeight < maximumContainerHeight && isDraggingDown {
                animateContainerHeight(defaultHeight)
            }
            else if newHeight > defaultHeight && !isDraggingDown {
                animateContainerHeight(maximumContainerHeight)
            }
        default:
            break
        }
    }
    
    func animateContainerHeight(_ height: CGFloat) {
        
        UIView.animate(withDuration: 0.2) {
            self.containerViewHeightConstraint?.constant = height
            self.view.layoutIfNeeded()
        }
        
        currentContainerHeight = height
        
    }
    
    func animatePresentContainer() {
        
        UIView.animate(withDuration: 0.2) {
            self.containerViewBottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func animateShowDimmedView() {
        
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.2) {
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }
    
    func animateDismissView() {
        
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.1) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
        }
        UIView.animate(withDuration: 0.1) {
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            self.view.layoutIfNeeded()
        }
    }
}
