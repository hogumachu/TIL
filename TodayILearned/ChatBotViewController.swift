//
//  ChatBotViewController.swift
//  TodayILearned
//
//  Created by 홍성준 on 2021/07/21.
//


import UIKit

struct data: Codable {
    let data: String
}

class ChatBotViewController: UIViewController {
    
    let chatTextField = UITextField()
    let sendButton = UIButton()
    let botTextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        draw()
    }
    
    func encodedData() -> Data? {
//        TextField에 있는 text를 encoding 함.
        let text = chatTextField.text!
        if text == "" {
            print("Empty Text")
            return nil
        }
        let data = data(data: text)
        
        let encoder = JSONEncoder()
        return try? encoder.encode(data)
    }
    
    @objc func sendText(sender: UIButton) {
        let urlStr = "http://127.0.0.1:8000/get_info/?data=\(chatTextField.text!)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//        Django Local 서버로 연결하여 Django 안에 있는 get_info 함수에 text를 줌.
        
        guard let url = URL(string: urlStr) else {
            fatalError("Invalid URL")
        }
        
        var request = URLRequest(url: url)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encodedData()
        
        let task = URLSession.shared.dataTask(with: request) { closureData, response, error in
//            JSON 구조 이름이 다 data 라 closureData 라고 이름을 칭했음.
            if error != nil {
                print("Error in Task")
                return
            }
            guard let reponse = response as? HTTPURLResponse else {
                print("Error in Task #Response")
                return
            }
            
            guard (200...299).contains(reponse.statusCode) else {
                print("Error in Task #Response + \(reponse.statusCode)")
                return
            }
            
//            guardData라 한 것도 동일.
            guard let guardData = closureData else {
                print("Error in Tast #data")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                
                let dataString = try decoder.decode(data.self, from: guardData)
                DispatchQueue.main.async {
//                    UI를 수정하기 위해 Main Thread에서 진행.
                    self.botTextView.text = dataString.data
                    print("data:", dataString.data)
                }
            } catch {
                print("Error")
                return
            }
        }
        task.resume()
    }
    
    func draw() {
        view.backgroundColor = .white
        view.addSubViews(UIViews: [chatTextField, sendButton, botTextView])
        translatesAutoresizingMaskIntoConstraints(UIViews: [chatTextField, sendButton, botTextView])

        
        sendButton.setTitle("Send", for: .normal)
        sendButton.setTitleColor(.systemBlue, for: .normal)
        sendButton.addTarget(self, action: #selector(sendText(sender:)), for: .touchUpInside)
        
        chatTextField.placeholder = "Text 를 입력하세요."
        chatTextField.backgroundColor = .systemPink
        
        botTextView.font = .systemFont(ofSize: 20)
        
        NSLayoutConstraint.activate([
            sendButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            sendButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            sendButton.heightAnchor.constraint(equalToConstant: 40),
            
            chatTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            chatTextField.bottomAnchor.constraint(equalTo: sendButton.bottomAnchor),
            chatTextField.heightAnchor.constraint(equalTo: sendButton.heightAnchor),
            chatTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor),
            
            botTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            botTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            botTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            botTextView.bottomAnchor.constraint(equalTo: sendButton.topAnchor)
            
        ])
    }
}
