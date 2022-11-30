# Struct & Class



## 공통점

* <u>프로퍼티</u>를 정의할 수 있음

* <u>메서드</u>를 정의할 수 있음

* <u>서브스크립트</u>를 정의할 수 있음

* <u>extension</u> 을 사용할 수 있음

* <u>프로토콜</u>을 구현할 수 있음



## 차이점

* <u>자동으로 생겨난 멤버 초기자</u> (memberwise initializer) 를 <u>Struct</u> 만 가지고 있음 (Class 는 X)

* 값을 전달할 때 <u>Struct 는 복사</u>하고 <u>Class 는 참조</u>함
  
  * Struct 는 Value 타입
  
  * Class 는 Reference 타입: 값을 참조할 때 Reference Count 증가

* <u>Class 는 특성을 다른 Class에 상속</u>시킬 수 있지만 구조체는 불가능

* <u>타입 캐스팅</u>: <u>실행 시 컴파일러가 Class 인스턴스의 타입을 미리 파악</u>하고 검사할 수 있음

* <u>Class 는 deinit 되기 직전</u>에 처리해야 할 <u>구문을 등록할 수 있음</u>
