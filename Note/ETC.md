깨알 공부 추가
==========
## 1. 화면 전환 (ViewController)

```swift
@objc func gotoAutoLayoutViewController(sender: UIButton) {
    let AutolayoutViewController = AutolayoutViewController()
    AutolayoutViewController.modalPresentationStyle = .fullScreen
    AutolayoutViewController.modalTransitionStyle = .coverVertical
    self.present(AutolayoutViewController, animated: true, completion: nil)
}

```
* self.present에 VC 넣음.
* VC.modalPresentationStyle 로 화면 구성 (.fullScreen 등) 설정 가능.
* VC.modalTransitionStyle 로 화면이 어떤식으로 등장 (.coverVertical 등) 할 지 애니메이션 설정 가능.


```swift
override func viewDidLoad() {
    super.viewDidLoad()
    
//        중략
    autoLayoutButton.addTarget(self, action: #selector(gotoAutoLayoutViewController), for: .touchUpInside)
//        중략
    
}
```
* addTarget으로 Action 추가 가능.

```swift
@objc func cancelButtonAction(sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
}
```
* dismiss 로 이전 VC로 돌아감.
