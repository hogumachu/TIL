알고리즘
==========
# 1. 정렬
## 1.1 Insertion Sort

```swift
func insertionSort(_ arr: [Int]) -> [Int] {
    var arr = arr
    
    for i in 1..<arr.count {
        var index = i
        
        while index > 0 && arr[index] < arr[index - 1] {
            arr.swapAt(index, index - 1)
            index -= 1
        }
    }
    return arr
}
```
* 시간 복잡도: `최선 O(n)`, `평균 O(n^2)`, `최악 O(n^2)`
* 공간 복잡도: `O(n)`
* 배열의 index 1 부터 시작해서 index - 1 의 값이 index 의 값보다 크면 변경 (swapAt)
* index 가 0 보다 크고 arr[index] 의 값이 arr[index - 1] 보다 작을 때만 진행
* index 가 0 이라면 자신의 앞에 있는 값이 없다는 것
* arr[index - 1] 의 값이 arr[index] 의 값보다 크지 않다는 것은 이 앞으로는 이미 정렬되어 있다는 뜻
* `var arr = [3, 4, 5, 1, 2]` 를 예를 들어보면
* Index 가 1, 2 일 때는 정렬을 하지 않음
* `Index 가 3`일 때 arr 은 `[3, 4, 1, 5, 2], [3, 1, 4, 5, 2], [1, 3, 4, 5, 2]` 이렇게 정렬
* `Index 가 4`일 때 `[1, 3, 4, 2, 5], [1, 3, 2, 4, 5], [1, 2, 3, 4, 5]` 이렇게 정렬되어 끝이남.
