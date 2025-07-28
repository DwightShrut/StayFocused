//
//  ViewController.swift
//  StayFocused
//
//  Created by Макс Макеев on 17.07.2025.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Texts {
        static let workText = "Let's Work"
        static let breakText = "Relax a bit"
        static let pauseText = "Pause"
        static let startText = "Press Play Button to Start work"
    }
    
    private enum Images {
        static let playImage = UIImage(systemName: "play.circle")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 36, weight: .regular))
        static let pauseImage = UIImage(systemName: "pause.circle")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 36, weight: .regular))
        static let backgroundImage = UIImage(named: "background")
    }
    
    // MARK: - Timer settings
    
    private lazy var totalTime = 25
    private var remainingTime = 25
    private var timer: Timer?
    private var workFlag = true
    private var timerFlag = false
    
    // MARK: - Create View elements
    private lazy var textLabel = UILabel()
    private lazy var imageView = UIImageView()
    private var timerLabel = UILabel()
    private lazy var button = UIButton()
    private lazy var circularProgressBar = CircularProgressBarView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setupHierarchy()
        setupConstraints()
    }
    
    // MARK: - Hierarchy method
    
    private func setupHierarchy() {
        view.addSubview(imageView)
        view.addSubview(circularProgressBar)
        view.addSubview(textLabel)
        view.addSubview(timerLabel)
        view.addSubview(button)
    }
    
    // MARK: - Setup Constraints
    
    private func setupConstraints() {
        
        imageView.addConstraints(
            top: view.topAnchor,
            topPadding: 0,
            left: view.leadingAnchor,
            leftPadding: 0
        )
        
        textLabel.addConstraints(
            centerX: view.centerXAnchor,
            top: view.topAnchor,
            topPadding: 150
        )
        
        timerLabel.addConstraints(
            centerX: view.centerXAnchor,
            centerY: view.centerYAnchor
        )
        
        button.addConstraints(
            top: timerLabel.bottomAnchor,
            topPadding: 50,
            left: view.leadingAnchor,
            leftPadding: 100,
            right: view.trailingAnchor,
            rightPadding: -100
        )
        
        circularProgressBar.addConstraints(
            centerX: view.centerXAnchor,
            centerY: view.centerYAnchor,
            width: 300,
            height: 300,
        )
    }
    
    // MARK: - Setup Views
    
    func setUpViews() {
        
        // MARK: - Setup Background
        
        imageView = UIImageView(image: Images.backgroundImage)
        imageView.contentMode = .scaleToFill
        
        // MARK: - Setup TextLabel
        
        textLabel.text = Texts.startText
        textLabel.textColor = .white
        textLabel.font = .systemFont(ofSize: 24, weight: .bold)
        textLabel.numberOfLines = 0
        textLabel.layer.opacity = 0.8
        
        // MARK: - Setup Timer label
        
        timerLabel.textAlignment = .center
        timerLabel.text = String(
            format: "%02d:%02d",
            remainingTime / 60,
            remainingTime % 60)
        timerLabel.textColor = .lightGray
        timerLabel.font = .systemFont(ofSize: 36, weight: .bold)
        
        // MARK: - Setup Button
        
        button.setImage(Images.playImage, for: .normal)
        button.tintColor = .lightGray
        button.layer.opacity = 0.5
        button.addTarget(self, action: #selector(pressButton), for: .touchUpInside)
        button.addTarget(self, action: #selector(releaseButton), for: .touchDown)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        totalTime = remainingTime
        setupHierarchy()
        setupApp()
        setUPCiicularProgressBarView()
        // Do any additional setup after loading the view.
    }
    
     private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimerLabel() {
        if remainingTime > 0 {
            remainingTime -= 1
            let minutes = remainingTime / 60
            let seconds = remainingTime % 60
            let minutesString = String(format: "%02d", minutes)
            let secondsString = String(format: "%02d", seconds)
            timerLabel.text = "\(minutesString):\(secondsString)"
        } else {
            if workFlag == true {
                workFlag = false
                totalTime = 10
                remainingTime = 10
                timerLabel.textColor = .green
                button.tintColor = .green
                circularProgressBarView.changeColor(.green)
            } else {
                circularProgressBarView.changeColor(.red)
                workFlag = true
                totalTime = 25
                remainingTime = 25
                timerLabel.textColor = .red
                button.tintColor = .red
            }
            let minutes = remainingTime / 60
            let seconds = remainingTime % 60
            let minutesString = String(format: "%02d", minutes)
            let secondsString = String(format: "%02d", seconds)
            timerLabel.text = "\(minutesString):\(secondsString)"
        }
        
        let progress = 1 - CGFloat(remainingTime) / CGFloat(totalTime)
        circularProgressBarView.setProgressBar(value: progress)
    }
    
    @objc private func pressButton(sender: UIButton) {
        if timerFlag == false {
            startTimer()
            let iconConfiguration = UIImage.SymbolConfiguration(pointSize: 36, weight: .regular)
            let pauseImage = UIImage(systemName: "pause.circle", withConfiguration: iconConfiguration)
            button.setImage(pauseImage, for: .normal)
            if workFlag == true {
                timerLabel.textColor = .red
                button.tintColor = .red
                circularProgressBarView.changeColor(.red)
            } else {
                timerLabel.textColor = .green
                button.tintColor = .green
                circularProgressBarView.changeColor(.green)
            }
            UIView.animate(withDuration: 0.1, animations: { self.button.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)})
            timerFlag = true
        } else {
            timer?.invalidate()
            button.tintColor = .lightGray
            timerLabel.textColor = .lightGray
            circularProgressBarView.changeColor(.lightGray)
            let iconConfiguration = UIImage.SymbolConfiguration(pointSize: 36, weight: .regular)
            let playImage = UIImage(systemName: "play.circle", withConfiguration: iconConfiguration)
            button.setImage(playImage, for: .normal)
            timerFlag = false
        }
    }
    
    private func setUPCiicularProgressBarView() {
        circularProgressBarView.center = view.center
        
    }
    
    @objc private func releaseButton(sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: { self.button.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)})
    }
    private func setupHierarchy() {
        view.addSubview(timerLabel)
        view.addSubview(button)
        view.addSubview(circularProgressBarView)
    }
    
    private func setupApp() {
        timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        timerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        button.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 50).isActive = true
        button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 100).isActive = true
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -100).isActive = true
        
        circularProgressBarView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        circularProgressBarView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

}

// MARK: - Progress Bar Class

class CircularProgressBarView: UIView {
    
    var progress = CAShapeLayer()
    var circleLayer = CAShapeLayer()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func createCircularPath() {
        let circularPath = UIBezierPath(
            arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
            radius: min(bounds.width, bounds.height) / 2,
            startAngle: -.pi / 2,
            endAngle: .pi * 3 / 2,
            clockwise: true
        )
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineWidth = 10
        circleLayer.strokeEnd = 1
        circleLayer.strokeColor = UIColor.lightGray.cgColor
        
        progress.path = circularPath.cgPath
        progress.fillColor = UIColor.clear.cgColor
        progress.lineCap = .round
        progress.lineWidth = 10
        progress.strokeEnd = 0
        progress.strokeColor = UIColor.lightGray.cgColor
    }
    
    override func layoutSubviews() {
           super.layoutSubviews()
           createCircularPath()
       }
    
    func setUpProgressBar() {
        layer.addSublayer(circleLayer)
        layer.addSublayer(progress)
    }
    
    func resetProgressWithoutAnimation() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        progress.strokeEnd = 0
        CATransaction.commit()
    }
    
    func changeColor(_ color: UIColor) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        circleLayer.strokeColor = color.cgColor
        CATransaction.commit()
    }
    
    func updateProgress(_ value: CGFloat) {
        progress.strokeEnd = value
    }
}
