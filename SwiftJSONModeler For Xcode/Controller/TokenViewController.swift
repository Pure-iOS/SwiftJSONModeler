//
//  TokenViewController.swift
//  SwiftJSONModeler For Xcode
//
//  Created by Sven on 2020/8/20.
//  Copyright © 2020 Sven. All rights reserved.
//

import Cocoa

class TokenViewController: NSViewController {

    @IBOutlet weak var titleTextField: NSTextField!
    @IBOutlet weak var tokenTextField: NSTextField!
    @IBOutlet weak var stackView: NSStackView!
    @IBOutlet weak var tokenContentView: NSView!
    private let tokenContentLayer = CALayer()
    private let rowHeight: CGFloat = 40
    private var dataSource: [Token] = []
    
    private var tokenViews: [TokenView] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupToken()
    }
    
    override func viewWillLayout() {
        super.viewWillLayout()
        tokenContentLayer.frame = tokenContentView.bounds
    }
    
    private func setupView() {
        tokenContentLayer.borderWidth = 1.0
        tokenContentLayer.borderColor = NSColor.lightGray.cgColor
        tokenContentLayer.cornerRadius = 10
        tokenContentView.layer = tokenContentLayer
    }
    private func setupToken() {
        dataSource = getToken()
        dataSource.forEach { addTokenView($0) }
    }
    
    @IBAction func AddButtonTap(_ sender: NSButton) {
        addToken()
    }
}

// MARK: - 数据处理
private extension TokenViewController {
    func addToken() {
        let title = titleTextField.stringValue
        let token = tokenTextField.stringValue
        guard !title.isEmpty && !token.isEmpty else {
            showAlert()
            return
        }
        let willAddToken = Token(title: title, token: token)
        dataSource.append(willAddToken)
        updateToken()
        addTokenView(willAddToken)
        titleTextField.stringValue = ""
        tokenTextField.stringValue = ""
    }
    func addTokenView(_ token: Token) {
        let tokenView = TokenView()
        tokenView.heightAnchor.constraint(equalToConstant: rowHeight).isActive = true
        stackView.addArrangedSubview(tokenView)
        tokenView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1).isActive = true
        tokenViews.append(tokenView)
        tokenView.deleteClosure = {
           [weak self] index in
            self?.deleteTokenAddView(at: index)
        }
        tokenView.config(token: token)
    }
    func deleteTokenAddView(at index: Int) -> Void {
        dataSource.remove(at: index)
        updateToken()
        let willDeleteView = tokenViews[index]
        tokenViews.remove(at: index)
        stackView.removeArrangedSubview(willDeleteView)
        willDeleteView.removeFromSuperview()

    }
    
    func showAlert() -> Void {
        let alert = NSAlert()
        alert.messageText = "错误"
        alert.informativeText = "项目名和 token不能为空"
        alert.alertStyle = .warning
        alert.addButton(withTitle: "确定")
        alert.beginSheetModal(for: NSApplication.shared.keyWindow!) { (modal) in
            
        }
        
    }
}
extension UserDefaults {
    enum Key: String {
        case tokens
    }
}
// MARK: - 数据持久化
private extension TokenViewController {
    func updateToken() -> Void {
        Token.updateUserDefault(for: dataSource)
    }
    
    func getToken() -> [Token] {
        return Token.getTokenFormUserDefault()
    }
}
