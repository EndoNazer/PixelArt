//
//  ViewController.swift
//  PixelArt
//
//  Created by Daniil on 04.06.2022.
//

import UIKit

class ViewController: UIViewController {
    private let gridView = GridView(frame: .zero)
    
    private let settingsStack = UIStackView(frame: .zero)
    private let colorStack = UIStackView(frame: .zero)
    private let colorLabel = UILabel(frame: .zero)
    private let colorButton = UIButton(frame: .zero)
    private let sizeSlider = UISlider(frame: .zero)
    
    private let minColumns = 2
    private let maxColumns = 30

    private var currentNumberOfColumns = 10
    
    private var selectedColor: UIColor = .black
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        sizeSlider.setValue(Float(currentNumberOfColumns) / Float(maxColumns), animated: false)
        
        view.addSubview(gridView)
        gridView.translatesAutoresizingMaskIntoConstraints = false
        gridView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapGridView)))
        gridView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(didPanGridView)))
        
        view.addSubview(settingsStack)
        settingsStack.axis = .vertical
        settingsStack.spacing = 10
        settingsStack.translatesAutoresizingMaskIntoConstraints = false
        settingsStack.addArrangedSubview(sizeSlider)
        settingsStack.addArrangedSubview(colorStack)
        
        sizeSlider.addTarget(self, action: #selector(sliderHandler), for: .valueChanged)

        colorStack.spacing = 10
        colorStack.axis = .horizontal
        colorStack.alignment = .center
        colorStack.distribution = .fillEqually
        colorStack.addArrangedSubview(colorLabel)
        colorStack.addArrangedSubview(colorButton)
        
        colorLabel.text = "Выберите цвет"
        colorLabel.textColor = .black
        
        colorButton.layer.borderColor = UIColor.black.cgColor
        colorButton.layer.borderWidth = 1
        colorButton.layer.cornerRadius = 5
        colorButton.backgroundColor = selectedColor
        colorButton.addTarget(self, action: #selector(didTapColorButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            gridView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            gridView.leftAnchor.constraint(equalTo: view.leftAnchor),
            gridView.rightAnchor.constraint(equalTo: view.rightAnchor),
            settingsStack.topAnchor.constraint(equalTo: gridView.bottomAnchor, constant: 20),
            settingsStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            settingsStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            settingsStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        configureGrid()
    }
    
    private func configureGrid() {
        let cellWidth = gridView.frame.width / CGFloat(currentNumberOfColumns)
        let numberOfRows = Int(gridView.frame.height / cellWidth)
        
        gridView.configure(
            rows: numberOfRows,
            columns: currentNumberOfColumns,
            cellSize: .init(width: cellWidth, height: cellWidth)
        )
    }
    
    @objc
    private func didTapGridView(_ sender: UITapGestureRecognizer) {
        gridView.handleTap(point: sender.location(in: gridView), color: selectedColor)
    }
    
    @objc
    private func didPanGridView(_ sender: UIPanGestureRecognizer) {
        gridView.handleTap(point: sender.location(in: gridView), color: selectedColor)
    }
    
    @objc
    private func sliderHandler(_ sender: UISlider) {
        let newNumberOfColumns = Int(sender.value * Float(maxColumns))
        guard newNumberOfColumns >= minColumns else {
            return
        }
        currentNumberOfColumns = newNumberOfColumns
        configureGrid()
    }
    
    @objc
    private func didTapColorButton() {
        let colorPickerController = UIColorPickerViewController()
        colorPickerController.delegate = self
        present(colorPickerController, animated: true)
    }
}

extension ViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        selectedColor = viewController.selectedColor
        colorButton.backgroundColor = selectedColor
    }
}
