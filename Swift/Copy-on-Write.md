# Copy on Write

Collection (Array, Dictionary) 그리고 String은 최적화를 사용하여 복사 성능 비용을 줄임

**즉시 복사본을 만드는 것이 아닌 먼저 저장된 메모리를 공유함**

**복사본 중 값이 수정되면 수정 직전에 복사함**

```swift
import Foundation

func print(address o: UnsafeRawPointer) {
    print(String(format: "%p", Int(bitPattern: o)))
}

var array1: [Int] = [0, 1, 2, 3]
var array2 = array1
let immutableArray = array1

print(address: array1)
print(address: array2)
print(address: immutableArray)

array2.append(4) // 값이 수정되기 직전에 복사함

print(address: array2)


// 0x1011232b0 (array1 Address)
// 0x1011232b0 (array2 Address)
// 0x1011232b0 (immutableArray Address)
// 0x101123630 (값이 변경된 array2 Address)
```



## 출처

[iOS) [번역] Swift의 Copy-on-Write 메커니즘 – 유셩장](https://sihyungyou.github.io/iOS-copy-on-write/)

[Understanding Swift Copy-on-Write mechanisms](https://medium.com/@lucianoalmeida1/understanding-swift-copy-on-write-mechanisms-52ac31d68f2f)
