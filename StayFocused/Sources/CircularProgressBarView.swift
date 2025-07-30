//
//  CircularProgressBarView.swift
//  StayFocused
//
//  Created by Макс Макеев on 30.07.2025.
//

import UIKit

class CircularProgressBarView: UIView {
    
    // MARK: - Layers
    
    var progress = CAShapeLayer()
    var circleLayer = CAShapeLayer()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        createCircularPath()
    }
    
    // MARK: - Setup
    
    /// Добавляем наши слои на основной
    
    func setUpProgressBar() {
        layer.addSublayer(circleLayer)
        layer.addSublayer(progress)
    }
    
    // MARK: - ProgressBar work methods
    
    /// Сбрасываем прогресс с отключенной анимацией чтобы избежать того самого отката к нулю
    
    func resetProgressWithoutAnimation() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        progress.strokeEnd = 0
        CATransaction.commit()
    }
    
    /// Метод для изменения цвета. Добавил так же отключение анимации так как столкнулся с проблемой мигания при изменении цвета
    
    func changeColor(_ color: UIColor) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        circleLayer.strokeColor = color.cgColor
        CATransaction.commit()
    }
    
    /// Метод для обновления прогресса заполнения
    
    func updateProgress(_ value: CGFloat) {
        progress.strokeEnd = value
    }
    
    // MARK: - Create circle path method
    
    /// Создаем круговой путь и настраиваем слои
    
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
        circleLayer.lineWidth = 7
        circleLayer.strokeEnd = 1
        circleLayer.strokeColor = UIColor.lightGray.cgColor
        
        progress.path = circularPath.cgPath
        progress.fillColor = UIColor.clear.cgColor
        progress.lineCap = .round
        progress.lineWidth = 7
        progress.strokeEnd = 0
        progress.strokeColor = UIColor.lightGray.cgColor
    }
}
