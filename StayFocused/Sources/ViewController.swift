//
//  ViewController.swift
//  StayFocused
//
//  Created by Макс Макеев on 17.07.2025.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Create View elements
    
    private lazy var textLabel = UILabel()
    private lazy var imageView = UIImageView()
    private var timerLabel = UILabel()
    private lazy var button = UIButton()
    private lazy var circularProgressBar = CircularProgressBarView()
    
    // MARK: - Timer settings
    
    private lazy var totalTime = 25
    private var remainingTime = 25
    private var timer: Timer?
    private var workFlag = true
    private var timerFlag = false
    
    
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
            remainingTime % 60
        )
        timerLabel.textColor = .lightGray
        timerLabel.font = .systemFont(ofSize: 36, weight: .bold)
        
        // MARK: - Setup Button
        
        button.setImage(Images.playImage, for: .normal)
        button.tintColor = .lightGray
        button.layer.opacity = 0.5
        button.addAction(UIAction { [weak self] _ in
            self?.pressButton()
        }, for: .touchUpInside)
        button.addAction(UIAction { [weak self] _ in
            self?.releaseButton()
        }, for: .touchDown)
        
        // MARK: - Setup Progress Bar
        circularProgressBar.setUpProgressBar()
        circularProgressBar.layer.opacity = 0.6
    }
    
    // MARK: - Work Logick
    
    /// Start timer method
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(updateTimerLabel),
            userInfo: nil,
            repeats: true
        )
    }
    
    /// Update timer label method
    
    @objc private func updateTimerLabel() {
        if remainingTime > 0 {
            remainingTime -= 1
            updateViews()
        } else {
            switchPeriod()
            updateViews()
        }
    }
    
    /// Switch period method(work/relax)
    
    func switchPeriod() {
        if workFlag == true {
            updateBreakPeriod()
        } else {
            updateWorkPeriod()
        }
        circularProgressBar.resetProgressWithoutAnimation()
    }
    
    /// UpdateViews method
    
    private func updateViews() {
        let minutesString = String(format: "%02d", remainingTime / 60)
        let secondsString = String(format: "%02d", remainingTime % 60)
        timerLabel.text = "\(minutesString):\(secondsString)"
        let progress = CGFloat(totalTime - remainingTime) / CGFloat(totalTime)
        circularProgressBar.updateProgress(progress)
    }
    
    private func updateBreakPeriod() {
        textLabel.text = Texts.breakText
        textLabel.textColor = .green
        timerLabel.textColor = .green
        button.tintColor = .green
        circularProgressBar.changeColor(.green)
        workFlag = false
        totalTime = 10
        remainingTime = 10
    }
    
    private func updateWorkPeriod() {
        textLabel.text = Texts.workText
        textLabel.textColor = .red
        timerLabel.textColor = .red
        button.tintColor = .red
        circularProgressBar.changeColor(.red)
        workFlag = true
        totalTime = 25
        remainingTime = 25
    }
    

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
    private func updateViewsToWork() {
        startTimer()
        button.setImage(Images.pauseImage, for: .normal)
        textLabel.text = workFlag ? Texts.workText : Texts.breakText
        textLabel.textColor = workFlag ? .red : .green
        timerLabel.textColor = workFlag ? .red : .green
        button.tintColor = workFlag ? .red : .green
        circularProgressBar.changeColor(workFlag ? .red : .green)
        UIView.animate(
            withDuration: 0.1,
            animations: { self.button.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)}
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
    private func updateViewsToPause() {
        timer?.invalidate()
        button.tintColor = .lightGray
        textLabel.text = Texts.pauseText
        textLabel.textColor = .lightGray
        timerLabel.textColor = .lightGray
        circularProgressBar.changeColor(.lightGray)
        button.setImage(Images.playImage, for: .normal)
        timerFlag = false
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
    private func pressButton() {
        if !timerFlag {
            updateViewsToWork()
        } else {
            updateViewsToPause()
        }
    }
    
    func updateProgress(_ value: CGFloat) {
        progress.strokeEnd = value
    private func releaseButton() {
        UIView.animate(
            withDuration: 0.1,
            animations: { self.button.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)}
        )
    }
}
