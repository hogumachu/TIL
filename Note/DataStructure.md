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


# 3. Queue

* FIFO (First-In-First-Out)
* 처음 들어간 값이 먼저 나옴
* Enqueue (값 추가), Dequeue (값 제거)
* 단순하게 removeFirst() 로 배열의 가장 처음 값을 내보내도 되지만 그렇게 하면 시간이 오래 걸림
* 이를 해결하기 위해 현재 head 를 가리키는 (가장 처음의 값을 가리키는) cursor 라는 값을 생성하여 사용함
* cursor 의 위치가 queue 안에 있는 배열의 count 가 되었을 때 배열과 cursor 를 초기화 시킴

```swift
struct Queue<T> {
    private var arr: [T] = []
    // 현재 First 위치를 나타내기 위한 커서 생성
    private var cursor = 0
    
    // 전체 데이터의 수에서 cursor 를 뺀 값이 count 값
    var count: Int {
        return arr.count - cursor
    }
    
    // 비어있는 지에 대한 값
    // arr.count - curosr == 0 이 맞지만
    // arr.count == 0 이라고 해도 상관 없음 (dequeue 에서 arr.count == cursor 일 때 계속 배열을 지우고 있기 떄문)
    var isEmpty: Bool {
        return arr.count - cursor == 0
    }
    
    mutating func enqueue(element: T) {
        arr.append(element)
    }
    
    mutating func dequeue() -> T? {
        // 만약 커서 위치가 배열의 count 보다 작으면
        if cursor < arr.count {
            // 먼저 dequeue 할 값을 정하고
            let deq = arr[cursor]
            // cursor 를 한 칸 앞으로 옮김
            cursor += 1
            
            // 만약 커서 위치가 배열의 count 와 같아지면
            if cursor == arr.count {
                // 커서와 배열을 초기화 함
                cursor = 0
                arr = []
            }
            
            return deq
        } else {
            // 만약 배열의 count 가 0이 아니면 초기화함
            if arr.count != 0 {
                cursor = 0
                arr = []
            }
            return nil
        }
    }
    
    func scanQueue() {
        print(arr)
    }
}

var queue = Queue<Int>()
queue.enqueue(element: 3)
queue.enqueue(element: 4)
queue.enqueue(element: 5)

queue.scanQueue()
// [3, 4, 5]

// 현재 3, 4, 5 의 값이 들어가 있으므로 count = 3
print(queue.count)
// 3

print(queue.dequeue())
// Optional(3)
queue.scanQueue()
// [3, 4, 5]

// 현재 3, 4, 5 의 값이 있지만 cursor 의 위치가 1이 되었으므로 count = 2
print(queue.count)
// 2


print(queue.dequeue())
// Optional(4)
queue.scanQueue()
// [3, 4, 5]
print(queue.count)
// 1


queue.enqueue(element: 6)
queue.enqueue(element: 7)
queue.enqueue(element: 8)

queue.scanQueue()
// [3, 4, 5, 6, 7, 8]

// 현재 3, 4, 5, 6, 7, 8 의 값이 있지만 cursor의 위치가 2 이므로 count = 4
print(queue.count)
// 4
queue.scanQueue()
// [3, 4, 5, 6, 7, 8]
print(queue.dequeue())
// Optional(5)
queue.scanQueue()
// [3, 4, 5, 6, 7, 8]
print(queue.dequeue())
// Optional(6)
queue.scanQueue()
// [3, 4, 5, 6, 7, 8]
print(queue.dequeue())
// Optional(7)
queue.scanQueue()
// [3, 4, 5, 6, 7, 8]
print(queue.dequeue())
// Optional(8)
queue.scanQueue()
// []
print(queue.dequeue())
// nil
queue.scanQueue()
// []
```
