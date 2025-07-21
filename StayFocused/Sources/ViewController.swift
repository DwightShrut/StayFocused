//
//  ViewController.swift
//  StayFocused
//
//  Created by Макс Макеев on 17.07.2025.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var totalTime = 25
    private var remainingTime = 25
    private var timer: Timer?
    private var workFlag = true
    private var timerFlag = false
 
    
    private lazy var circularProgressBarView: CircularProgressBarView = {
        var circularProgressBarView = CircularProgressBarView(frame: CGRect(x: 100, y: 100, width: 150, height: 150))
        circularProgressBarView.translatesAutoresizingMaskIntoConstraints = false
        return circularProgressBarView
    }()
    
    private lazy var timerLabel: UILabel = {
        let timerLabel = UILabel()
        timerLabel.textAlignment = .center
        let minutes = remainingTime / 60
        let seconds = remainingTime % 60
        timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
        timerLabel.textColor = .lightGray
        timerLabel.font = .systemFont(ofSize: 36, weight: .bold)
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        return timerLabel
    }()
    
    private lazy var button: UIButton =  {
        let button = UIButton(type: .roundedRect)
        let iconConfiguration = UIImage.SymbolConfiguration(pointSize: 36, weight: .regular)
        let playImage = UIImage(systemName: "play.circle", withConfiguration: iconConfiguration)
        let pauseImage = UIImage(systemName: "pause.circle", withConfiguration: iconConfiguration)
        button.setImage(playImage, for: .normal)
        button.tintColor = .lightGray
        button.layer.opacity = 0.5
        button.addTarget(self, action: #selector(pressButton), for: .touchUpInside)
        button.addTarget(self, action: #selector(releaseButton), for: .touchDown)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

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

class CircularProgressBarView: UIView {
    
    var progress = CAShapeLayer()
    private var circleLayer = CAShapeLayer()
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularPath()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createCircularPath()
    }
    
    func changeColor(_ color: UIColor) {
        progress.strokeColor = color.cgColor
    }
    
    private func createCircularPath() {
        let circularPath = UIBezierPath(
            arcCenter: anchorPoint,
            radius: min(bounds.width, bounds.height),
            startAngle: -.pi / 2,
            endAngle: .pi * 3 / 2,
            clockwise: true
        )
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineWidth = 10
        circleLayer.strokeEnd = 1.0
        circleLayer.strokeColor = UIColor.darkGray.cgColor
        
        layer.addSublayer(circleLayer)
        
        progress.path = circularPath.cgPath
        progress.fillColor = UIColor.clear.cgColor
        progress.lineCap = .round
        progress.lineWidth = 10
        progress.strokeEnd = 0
        progress.strokeColor = UIColor.red.cgColor
        
        layer.addSublayer(progress)
    }
    
    internal func setProgressBar(value: CGFloat) {
        let newProgress = value
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = progress.strokeEnd
        animation.toValue = newProgress
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        progress.strokeEnd = newProgress
        progress.add(animation, forKey: "progressAnim")
    }
}
