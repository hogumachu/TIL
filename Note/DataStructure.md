자료구조
==========
# 1. HashTable
Key-Value 로 구성되어 있음

* Key 값을 해시 함수를 통해 index 로 만듦
* key 에 hasValue 를 얻음 (값이 음수일 수 있음)
* 이를 대부분 배열의 사이즈 (count) 로 mod 연산
* 절댓값으로 변경


```swift
func index(key: Key) -> Int {
    return abs(key.hashValue % buckets.count)
}
```

* 해당 index 에 value 를 저장
* 이 때 Collision 이 발생할 수 있음
* Chaining 과 Linear Probing 으로 해결 가능
* Bucket 을 2차원 배열로 설정하여 이를 해결함
```swift
private typealias Element = (key: Key, value: Value)
private typealias Bucket = [Element]
private var buckets: [Bucket]
```
* 모든 key 값들이 동일한 index (모두 Collision 이 일어남) 인 경우에 O (n) 의 시간 복잡도를 가짐.
* 평균 O (1)
* Swift 의 Dictionary 에서 Collision 이 발생할 때 Linear Probing 으로 해결한다 함 (검색어: hash collision in swift dictionary)

```swift
// Key - Value 타입
struct HashTable<Key: Hashable, Value> {
    private typealias Element = (key: Key, value: Value)
    private typealias Bucket = [Element]
    private var buckets: [Bucket]
    
    // hashTable 에 저장된 값의 수
    private var count = 0
    
    var isEmpty: Bool { return count == 0 }
    
    init(capacity: Int) {
        assert(capacity > 0)
        buckets = Array<Bucket>(repeating: [], count: capacity)
    }
    
    // 해당 key에 대한 value 를 리턴하는 함수
    func value(key: Key) -> Value? {
        let index = index(key: key)
        
        for element in buckets[index] {
            if element.key == key {
                return element.value
            }
        }
        return nil
    }
    
    // index 를 얻는 함수
    private func index(key: Key) -> Int {
        return abs(key.hashValue % buckets.count)
    }
    
    // 값을 업데이트함
    mutating func updateValue(value: Value, key: Key) {
        // 인덱스를 얻어
        let index = index(key: key)
        
        // 해당 index 에 enumertaed 를 함
        for (i, element) in buckets[index].enumerated() {
            // 해당 key에 대한 값이 존재하면
            if element.key == key {
                // value 를 변경함
                buckets[index][i].value = value
                return
            }
        }
        
        // 그렇지 않으면 해당 key에 대한 값이 없는 것이므로
        // 값을 추가하고
        buckets[index].append((key: key, value: value))
        // count 증가
        count += 1
        
        return
    }
    
    // 값을 제거함
    mutating func removeValue(value: Value, key: Key) {
        let index = index(key: key)
        
        for (i, element) in buckets[index].enumerated() {
            // 만약 값이 존재하면 제거하고 count 감소
            if element.key == key {
                buckets[index].remove(at: i)
                count -= 1
                return
            }
        }
        
        // 값이 없다면 아무 것도 하지 않고 종료
        return
    }
    
    // buckets 을 확인하기 위해 만든 함수
    func scanBuckets() {
        print(buckets)
    }
}

// 2개의 capacity를 가진 HashTable 생성
var hashTable = HashTable<String, String>(capacity: 2)

// 값을 업데이트함
hashTable.updateValue(value: "Apple", key: "A")
hashTable.updateValue(value: "Banana", key: "B")
hashTable.updateValue(value: "Hogumachu", key: "H")


print(hashTable.value(key: "A"))
// Optional("Apple")

print(hashTable.value(key: "B"))
// Optional("Banana")

print(hashTable.value(key: "H"))
// Optional("Hogumachu")

hashTable.scanBuckets()
//[
//    [(key: "A", value: "Apple")],
//    [(key: "B", value: "Banana"), (key: "H", value: "Hogumachu")]
//]
// "B" 와 "H" 가 Collision 이 일어나 같은 index 에 위치함을 알 수 있음
hashTable.updateValue(value: "Hi", key: "H")

print(hashTable.value(key: "H"))
// Optional("Hi")

hashTable.scanBuckets()
//[
//    [(key: "A", value: "Apple")],
//    [(key: "B", value: "Banana"), (key: "H", value: "Hi")]
//]
// 기존에 "H" Key 의 Value 인 "Hogumachu" 가 아닌 "Hi" 로 대체된 모습
```

참조: [Link](https://github.com/raywenderlich/swift-algorithm-club/blob/master/Hash%20Table/HashTable.playground/Sources/HashTable.swift)


# 2. Stack

* FILO (First-In-Last-Out)
* 처음에 들어간 값이 가장 나중에 나오고 가장 나중에 들어간 값이 가장 먼저 나옴
* Push (값을 추가), Pop (값을 제거), Top (가장 나중에 들어간 값) 이 있음

```swift
struct Stack<T> {
    private var arr: [T] = []
    
    func top() -> T? {
        return arr.last
    }
    
    mutating func push(element: T) {
        arr.append(element)
    }
    
    mutating func pop() -> T? {
        if arr.isEmpty {
            return nil
        }
        return arr.removeLast()
    }
    
    func empty() -> Bool {
        return arr.isEmpty
    }
}

var stack = Stack<Int>()

stack.push(element: 10)
stack.push(element: 5)

print(stack.pop())
// Optional(5)
// 나중에 들어간 5가 먼저 나옴

print(stack.pop())
// Optional(10)
// 가장 마지막에 들어간 10이 나옴

print(stack.pop())
// nil
// 값이 존재하지 않으므로 nil

stack.push(element: 1)
stack.push(element: 2)
stack.push(element: 5)

print(stack.pop())
// Optional(5)

print(stack.pop())
// Optional(2)

print(stack.pop())
// Optional(1)
```
