알고리즘
==========
# 1. Insertion Sort

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


# 2. Merge Sort

```swift
func mergeSort(_ arr: [Int]) -> [Int] {
    // 배열의 크기가 1 이하 일 때는 배열 그대로 return -> 정렬할 필요 없음
    if arr.count <= 1 {
        return arr
    }
    
    
    // 분할 정복을 위해 index 를 반으로 나눔
    let mid = arr.count / 2
    
    // mid 를 중심으로 왼쪽 오른쪽으로 나누어 mergeSort 를 호출 (recursive)
    let left = mergeSort(Array(arr[0..<mid]))
    let right = mergeSort(Array(arr[mid..<arr.count]))
    
    // left 와 right 를 merge함
    return merge(left, right)
}

func merge(_ left: [Int], _ right: [Int]) -> [Int] {
    // left 의 값과 right 의 값을 비교할 index 를 각각 생성
    var l = 0
    var r = 0
    
    // 정렬된 배열을 저장할 빈 배열 생성
    var arr: [Int] = []
    
    
    // l 이 left 의 count 와 같아지거나 right 의 count 와 같아지면 배열 index 를 넘어감
    while l < left.count && r < right.count {
        
        // left 가 작으면 left 에 있는 값을 append 하고 l 증가
        if left[l] < right[r] {
            arr.append(left[l])
            l += 1
            
            // right 가 작으면 right 에 있는 값을 append 하고 r 증가
        } else if left[l] > right[r] {
            arr.append(right[r])
            r += 1
            
            // 그 외 (left[l] == right[l]) 에는 두 값을 모두 append 하고 각 index 증가
        } else {
            arr.append(left[l])
            arr.append(right[r])
            l += 1
            r += 1
        }
    }
    
    // 만약 left 의 배열 끝까지 가지 않았다면 남은 left 배열의 값들을 append 함
    while l < left.count {
        arr.append(left[l])
        l += 1
    }
    
    // 만약 right 의 배열 끝까지 가지 않았다면 남은 right 배열의 값들을 append 함
    while r < right.count {
        arr.append(right[r])
        r += 1
    }
    
    return arr
}

//MergeSort: [5, 4, 3, 2, 1]
// -> mid 로 나뉘어 MergeSort (left, right) 호출

//MergeSort: [5, 4]
// -> mid 로 나뉘어 MergeSort (left, right) 호출

//MergeSort: [5]
// -> arr.count 가 1이므로 그대로 arr return

//MergeSort: [4]
// -> arr.count 가 1이므로 그대로 arr return

//Left: [5]
//Right: [4]
// -> Merge(Left, Right) 진행
//Merged: [4, 5]
// -> [4, 5] 로 Merge 되어서 return

//MergeSort: [3, 2, 1]
// -> mid 로 나뉘어 MergeSort (left, right) 호출

//MergeSort: [3]
// -> arr.count 가 1이므로 그대로 arr return

//MergeSort: [2, 1]
// -> mid 로 나뉘어 MergeSort (left, right) 호출

//MergeSort: [2]
// -> arr.count 가 1이므로 그대로 arr return

//MergeSort: [1]
// -> arr.count 가 1이므로 그대로 arr return

//Left: [2]
//Right: [1]
// -> Merge(Left, Right) 진행
//Merged: [1, 2]
// -> [1, 2] 로 Merge 되어서 return

//Left: [3]
//Right: [1, 2]
// -> Merge(Left, Right) 진행
//Merged: [1, 2, 3]
// -> [1, 2, 3] 로 Merge 되어서 return

//Left: [4, 5]
//Right: [1, 2, 3]
// -> Merge(Left, Right) 진행
//Merged: [1, 2, 3, 4, 5]
// -> [1, 2, 3, 4, 5] 로 Merge 되어서 return

//[1, 2, 3, 4, 5]
// -> 정상적으로 정렬 되었음
```
* 시간 복잡도:  `평균 O(n log n)`, `최악 O(n log n)`
* 공간 복잡도: `O(n)`
* 분할 정복 (Divide & Conquer) 알고리즘


# 3. Maximum Subarray Problem

## 3.1. Brute Force

```swift
func bruteForceMaximumSubarray(_ arr: [Int]) -> Int {
    var maxSum = 0
    
    for i in 0..<arr.count {
        for j in 0..<arr.count - i {
            var sum = 0
            for k in j...j+i {
                sum += arr[k]
            }
            maxSum = max(sum, maxSum)
        }
    }
    
    return maxSum
}
```

* 시간 복잡도: `O(n^3)`
* 3중 반복문을 사용하여 찾음
* 매우 비효율적 -> 사용 X

## 3.2. Divide & Conquer

```swift
func divideConquerMaximumSubarray(_ arr: [Int]) -> Int {
    if arr.count == 1 {
        return arr[0]
    }
    
    let mid = arr.count / 2
    var left = -Int.max
    var right = -Int.max
    var sum = 0
    
    for i in stride(from: mid, through: 0, by: -1) {
        sum += arr[i]
        left = max(left, sum)
    }
    
    sum = 0
    
    for i in mid + 1..<arr.count {
        sum += arr[i]
        right = max(right, sum)
    }
    
    let recursive = max(divideConquerMaximumSubarray(Array(arr[0..<mid])), divideConquerMaximumSubarray(Array(arr[mid..<arr.count])))
    
    return max(left + right, recursive)
}
```

* 시간 복잡도: `O(n^2)`
* 분할 정복을 이용하여 찾음
* 비효율적이며 Kadane 알고리즘 보다 복잡함


## 3.3. Kadane's Algorithm

```swift
func kadaneMaximumSubarray(_ arr: [Int]) -> Int {
    var sum = arr[0]
    var maxSum = arr[0]
    for i in 1..<arr.count {
        sum = max(arr[i] + sum, arr[i])
        maxSum = max(maxSum, sum)
    }
    
    return maxSum
}
```

* 시간 복잡도: `O(n)`
* Dynamic Programing 을 이용한 방법
* 현재 `arr[index] 의 값과 index - 1 까지의 합 (sum)` vs. `arr[index] 의 값 중 최대 값`을 `sum` 에 넣음
* 현재 `index 를 포함한 합 (sum)` 과 기존에 설정되어 있는 `최대 값 (maxSum)` 을 비교하여 `maxSum` 을 갱신
