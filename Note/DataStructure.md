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

* FILO (First-In-Last-Out), LIFO (Last-In-First-Out)
* 처음에 들어간 값이 가장 나중에 나오고 가장 나중에 들어간 값이 가장 먼저 나옴
* Array 와 매우 유사하지만 Stack 은 제한적임
* Push (값을 추가), Pop (값을 제거), Peak or Top (가장 나중에 들어간 값) 이 있음

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
* BFS 에 사용
* 처음 들어간 값이 먼저 나옴
* Enqueue (값 추가), Dequeue (값 제거)
* 단순하게 removeFirst() 로 배열의 가장 처음 값을 내보내면 dequeue 마다 O(n) 의 시간이 
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

# 4. Heap

* 최댓값 또는 최솟값을 쉽게 찾기 위해 고안된 자료 구조
* 완전 이진 트리, 최대 힙, 최소 힙 존재

```swift
struct Heap<T> {
    // 데이터를 저장하는 배열
    private var nodes: [T] = []
    
    // 최대 힙인지 최소 힙인지에 대해 저장
    private var order: (T, T) -> Bool
    
    // 처음 생성할 때 order 설정함
    init(order: @escaping (T, T) -> Bool) {
        self.order = order
    }
    
    var isEmpty: Bool {
        return nodes.isEmpty
    }
    
    var count: Int {
        return nodes.count
    }
    
    func top() -> T? {
        return nodes.first
    }
    
    mutating func insert(_ element: T) {
        // 값을 추가할 때 배열에 가장 뒤에 넣고
        nodes.append(element)
        
        // 가장 아래에서 그 값을 올림 (order 에 맞춰 값을 정렬함)
        shiftUp()
    }
    
    mutating func remove() -> T? {
        // 만약 비어있으면 nil 리턴
        guard !nodes.isEmpty else {
            return nil
        }
        
        // 먼저 가장 상위에 있는 값과 가장 마지막에 있는 값을 교체하고
        nodes.swapAt(0, nodes.count - 1)
        
        // 가장 마지막에 있는 값을 제거함
        let removeValue = nodes.removeLast()
        
        // 가장 처음에 있는 값이 정렬되지 않은 값이므로 그 값을 내림
        shiftDown()
        return removeValue
        
    }
    
    mutating func shiftUp() {
        // 가장 마지막에 있는 값을 올리기 위해 index 를 설정
        var index = nodes.count - 1
        
        // index 가 0 보다 클 때 반복 (0과 같거나 작으면 parentIndex 가 존재하지 않음)
        while index > 0 {
            // 먼저 parentIndex 를 설정하고
            let parentIndex = (index - 1) / 2
            
            // parentIndex 와 index 를 비교했을 때 index 의 값이 order 하게 되면
            if order(nodes[index], nodes[parentIndex]) {
                // 값을 교체하고
                nodes.swapAt(index, parentIndex)
                // index 도 교체함
                index = parentIndex
            } else {
                return
            }
        }
    }
    
    mutating func shiftDown() {
        // 가장 상위에 있는 값을 선택하고
        var index = 0
        
        // 그 index 와 교체할 swapIndex 도 설정함
        var swapIndex = index
        
        // 배열의 크기를 넘지 않는 동안 반복함
        while index < nodes.count {
            // 자신의 왼쪽 오른쪽 childNode 의 index 를 설정함
            let childIndices = [index * 2 + 1, index * 2 + 2]
            
            // childIndex 를 반복하여
            childIndices.forEach { cIndex in
                // 만약 childIndex 의 값이 크기보다 작고 childIndex 가 swapIndex 보다 order 하면
                if cIndex < nodes.count && order(nodes[cIndex], nodes[swapIndex]) {
                    // 교체함
                    swapIndex = cIndex
                }
            }
            
            // 만약 index 와 swapIndex 가 같지 않다면
            if index != swapIndex {
                // 둘이 값을 교체하고
                nodes.swapAt(index, swapIndex)
                // index 도 교체함
                index = swapIndex
                
            // 같다면 childIndex 중 해당 사항이 없던 것이므로 종료
            } else { return }
        }
        
    }
    
    // nodes 확인을 위해 만들었음
    func scanNodes() {
        print(nodes)
    }
}
```

```swift
// maxHeap 으로 Heap 을 생성
var heap = Heap<Int>(order: >)

heap.insert(1)
heap.insert(2)
heap.insert(3)

heap.scanNodes()
// [3, 1, 2]
print(heap.remove())
// Optional(3)

heap.scanNodes()
// [2, 1]

heap.insert(4)
heap.scanNodes()
// [4, 1, 2]

heap.insert(5)
heap.scanNodes()
// [5, 4, 2, 1]

heap.insert(3)
heap.scanNodes()
// [5, 4, 2, 1, 3]

print(heap.remove())
// Optional(5)

heap.scanNodes()
// [4, 3, 2, 1]

print(heap.remove())
// Optional(4)

heap.scanNodes()
// [3, 1, 2]

print(heap.remove())
// Optional(3)

heap.scanNodes()
// [2, 1]

```

# 5. Priority Queue
* 우선순위 큐는 가장 중요한 요소가 항상 front 에 있는 큐
* 우선순위 큐는 `리스트` 나 `맵` 처럼 추상적인 개념
* 우선순위 큐는 `추상적 자료형 (Abstract Data Type, ADT)`
* 추상적 자료형은 구현 방법을 명시하지 않는다는 점에서 자료 구조와 다름
* 우선순위 큐는 Heap 이나 다양한 방법을 이용해 구현될 수 있음
* Heap 은 자료 구조
* Heap 으로 구현 시 remove, insert 대신 dequeue, enqueue 로 사용

```swift
struct PriorityQueue<T> {
    private var nodes: [T] = []
    private var order: (T, T) -> Bool
    
    init(order: @escaping (T, T) -> Bool) {
        self.order = order
    }
    
    var isEmpty: Bool {
        return nodes.isEmpty
    }
    
    var count: Int {
        return nodes.count
    }
    
    func top() -> T? {
        return nodes.first
    }
    
    mutating func enqueue(_ element: T) {
        nodes.append(element)
        shiftUp()
    }
    
    mutating func dequeue() -> T? {
        guard !nodes.isEmpty else {
            return nil
        }
        
        nodes.swapAt(0, nodes.count - 1)
        let removeValue = nodes.removeLast()
        shiftDown()
        return removeValue
        
    }
    
    mutating func shiftUp() {
        var index = nodes.count - 1
        
        while index > 0 {
            let parentIndex = (index - 1) / 2
            
            if order(nodes[index], nodes[parentIndex]) {
                nodes.swapAt(index, parentIndex)
                index = parentIndex
            } else {
                return
            }
        }
    }
    
    mutating func shiftDown() {
        var index = 0
        var swapIndex = index
        
        while index < nodes.count {
            let childIndices = [index * 2 + 1, index * 2 + 2]
            
            childIndices.forEach { cIndex in
                if cIndex < nodes.count && order(nodes[cIndex], nodes[swapIndex]) {
                    swapIndex = cIndex
                }
            }
            
            if index != swapIndex {
                nodes.swapAt(index, swapIndex)
                index = swapIndex
            } else { return }
        }
        
    }
    
    func scanNodes() {
        print(nodes)
    }
}
```
