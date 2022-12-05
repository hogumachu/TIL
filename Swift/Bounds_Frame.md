# Bounds & Frame

## Bounds

* **자신만의 좌표 시스템**에서 View의 위치와 크기

* **Bounds의 Size는 View 자체의 크기**를 나타냄 (회전시키더라도 Size 유지)

## Frame

* **SuperView의 좌표 시스템**에서 View의 위치와 크기

* **Frame의 Size는 View를 감싸는 사각형 영역의 크기**를 나타냄 (회전시키면 Size 변경)



SuperView의 bounds 변화를 주었을 때 SubView 들이 움직이게 보이는 느낌

* ScrollView의 ContentOffset 원리

* A의 bounds의 y 값을 +50 하게 되면 A는 고정되어있고 A의 SubView들이 -50 이동하는 것처럼 보임
