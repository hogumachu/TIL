# Delegate

class 또는 struct 가 다른 타입의 인스턴스로 책임을 전달 (또는 위임) 할 수 있도록 하는 디자인 패턴

하나의 객체가 모든 일을 하는 것이 아닌 일부를 다른 객체에 넘김

UITabieVlewDelegate, UICollectionViewDelegate, UITextFieldDelegate 등 많은 Delegate 가 존재함



## Custom Delegate

protocol 로 Delegate 를 만들고 Delegate 를 위임하여 그 기능을 구현을 함

```swift
class NavigationView: UIView {

    weak var delegate: NavigationViewDelegate?

    // 생략

    // Delegate 로 이벤트 넘김
    @objc private func leftButtonDidTap(_ sender: UIButton) {
        self.delegate?.navigationViewDidClickLeftButton(self)
    }

    // Delegate 로 이벤트 넘김
    @objc private func rightButtonDidTap(_ sender: UIButton) {
        self.delegate?.navigationViewDidClickRightButton(self)
    }

}

protocol NavigationViewDelegate: AnyObject {

    func navigationViewDidClickLeftButton(_ view: NavigationView)
    func navigationViewDidClickRightButton(_ view: NavigationView)

}

class MyView: UIView {

    private func setup() {
        // Delegate
        self.navigationView.delegate = self
    }

    private let navigationView = NavigationView()
}

// Delegate 메소드 구현
extension MyView: NavigationViewDelegate {

    func navigationViewDidClickLeftButton(_ view: NavigationView) {
        // Do something
    }

    func navigationViewDidClickRightButton(_ view: NavigationView) {
        // Do something
    }

}
```
