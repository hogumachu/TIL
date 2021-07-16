AutoLayout
==========
# 1. Extension, Anchor
## 1.1 Extension

```swift
func translatesAutoresizingMaskIntoConstraints(UIViews: [UIView]) {
    UIViews.forEach({ UIView in
        UIView.translatesAutoresizingMaskIntoConstraints = false
    })
}

extension UIView {
    func addSubViews(UIViews: [UIView]) {
        UIViews.forEach({ UIView in
            self.addSubview(UIView)
        })
    }
    
    func addSubViewsAndReturnSelf(UIViews: [UIView]) -> UIView {
        UIViews.forEach({ UIView in
            self.addSubview(UIView)
        })
        return self
    }
    
    func addSubViewAndReturnSelf(UIView: UIView) -> UIView {
        self.addSubview(UIView)
        return self
    }
}

```
* 오토레이아웃에 사용할 기능을 Extension 하여 배열로 받아 처리 하였음.

```swift
 view.addSubViews(UIViews: [
      backgroundImageView,
      bottomView.addSubViewAndReturnSelf(UIView:
          horizontalStackView.addSubViewsAndReturnSelf(UIViews: [
              chatView.addSubViewsAndReturnSelf(UIViews: [
                  chatImageView,
                  chatLabel
              ]),
              editView.addSubViewsAndReturnSelf(UIViews: [
                  editImageView,
                  editLabel
              ]),
              storyView.addSubViewsAndReturnSelf(UIViews: [
                  storyImageView,
                  storyLabel
              ])
          ])),
      topView.addSubViewsAndReturnSelf(UIViews: [
          closeButton,
          profileImageView,
          nameLabel,
          statusLabel,
    ]),
])
```
* addSubview를 addSubviews로 하여 [UIView]를 받음.
* 만약 addSubviews를 하고 자신도 하나의 Subview가 되는 상황이 필요하여 addSubViewAndReturnSelf 도 Extension 함.
* 가독성은 이전에 비해 좋아지고 View의 계층 구조를 조금 더 직관적으로 파악할 수 있으나 그래도 보기 어려운 느낌.

## 1.2 Anchor

```swift
NSLayoutConstraint.activate([

            // 중략
    
            chatImageView.topAnchor.constraint(equalTo: chatImageView.superview!.topAnchor),
            chatImageView.leadingAnchor.constraint(equalTo: chatImageView.superview!.leadingAnchor),
            chatImageView.trailingAnchor.constraint(equalTo: chatImageView.superview!.trailingAnchor),
//            chatImageView.heightAnchor.constraint(equalTo: chatImageView.superview!.heightAnchor, multiplier: 2 / 3),
            chatImageView.bottomAnchor.constraint(equalTo: chatLabel.layoutMarginsGuide.topAnchor, constant: -10),
            
            chatLabel.leadingAnchor.constraint(equalTo: chatLabel.superview!.leadingAnchor),
            chatLabel.trailingAnchor.constraint(equalTo: chatLabel.superview!.trailingAnchor),
            chatLabel.bottomAnchor.constraint(equalTo: chatLabel.superview!.bottomAnchor),
//            chatLabel.heightAnchor.constraint(equalTo: chatLabel.superview!.heightAnchor, multiplier: 1 / 3),
            
            // 중략
            
            
        ])
```
* constraint를 추가할 때 superview와 비교를 하는 것이 좋은지 아니면 다른 view와 비교를 해야 좋은지 기준을 모르겠음.
* Device 마다 내가 그렸던 느낌의 장면이 아니라 많이 다름.
* Orientation 에 따라 height를 고정시킨 view가 존재하여 고정시킨 view에 연관된 다른 view가 아예 없어짐.
<img src = "https://user-images.githubusercontent.com/74225754/125969813-60d8254f-bb92-457d-8c99-32a7dc5a3225.png" width="30%" height="30%"> <img src = "https://user-images.githubusercontent.com/74225754/125969946-345937cb-da33-43d0-bd4c-b9acd2ec1dd0.png" width="60%" height="60%">


