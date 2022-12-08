# Singleton

## 활용 예시

### Swift 에서

```swift
 UserDefaults.standard
 UIApplication.shared
 URLSession.shared
 
 // 기타 등등 많은 곳에서 사용
```



### Image Cache 를 위한

```swift
class ImageDownloadManager {
    static let shared = ImageDownloadManager()
    private init() {}

    private var imageCache = NSCache<NSString, UIImage>()
}
```





## 어떤 이유로 사용?

### static 으로 생성하므로...

* `ImageDownloadManager.shared` 이런 식으로 어디서든 **접근**할 수 있어 **편리**함

* **메모리 관리에 편함** (따로 초기화를 하지 않으므로); weak self 등 신경 쓰지 않아도 됌 (메모리에 계속 할당)

* 어디서든 접근하기 쉬워 **의존성**이 생길 수 있음

* 어디서든 접근하기 쉬워 **테스트하기 어려움**

* 스레드 관리를 해야 함
  
  * 예시처럼 `NSCache` 경우 **Thread safe** 하므로 신경쓰지 않아도 OK 그러나 Thread safe 하지 않은 (Array, NSDictionary ...) 것을 사용하면 Lock 등 로직을 추가해야 함
