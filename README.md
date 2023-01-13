# Runnect-iOS
![소개](https://user-images.githubusercontent.com/77267404/210302977-b0c11a10-e695-4614-bf03-a0ee1c57823b.png)

# 한줄 소개
🏃Runnect는 Run과 connect의 합성어로 직접 코스를 그리고 공유하며  서로를 연결해주고 함께 달릴 수 있는 서비스입니다.


> 31th IN SOPT APP JAM <br>
> 프로젝트 기간 : 2022.12.11 ~ 2023.01.15

<br>
<br>

##  Team Runnect iOS Developers
![미모티콘](https://user-images.githubusercontent.com/77267404/210303677-1354bea7-fba4-4824-a22a-27ba56327370.png) | ![KakaoTalk_Photo_2023-01-03-14-20-26](https://user-images.githubusercontent.com/77267404/210303710-db640ea4-a716-4947-812a-9b19aae8d2a4.png) | ![KakaoTalk_Photo_2023-01-03-14-18-19](https://user-images.githubusercontent.com/77267404/210303572-f9581df7-c3c0-46a8-9c63-219384d6dd64.png) |
 :---------:|:----------:|:---------:
 이세진 | 이연우 | 이재현 |


<br>
<br>

## Development Environment and Using Library
- Development Environment
<p align="left">
<img src ="https://img.shields.io/badge/Swift-5.7-orange?logo=swift">
<img src ="https://img.shields.io/badge/Xcode-14.0-blue?logo=xcode">
<img src ="https://img.shields.io/badge/iOS-14.0-green.svg">

<br>
<br>

- Library

라이브러리 | 사용 목적 | Version | Management Tool
:---------:|:----------:|:---------: |:---------:
 Moya | 서버 통신 | 15.0.0 | CocoaPods
 SnapKit | UI Layout | 5.6.0 | CocoaPods
 Then | UI 선언 | 3.0.0 | CocoaPods
 Kingfisher | 이미지 처리 | 7.4.1| CocoaPods
 NMapsMap  | 네이버 지도 SDK | 3.16.1| CocoaPods
 
 <br>

- framework

프레임워크 | 사용 이유 
:---------:|:----------:
 UIKit | UI 구현

<br>
<br>

## Coding Convention
<details>
 <summary> ⭐️ Git Branch Convention </summary>
 <div markdown="1">       

 ---
 
 - **Branch Naming Rule**
    - Issue 작성 후 생성되는 번호와 Issue의 간략한 설명 등을 조합하여 Branch 이름 결정
    - `[previx]/<#IssueNumber>-<Description>`
- **Commit Message Rule**
    - `[Prefix] <#IssueNumber>-<Description>`
- **Code Review Rule**
    - 코드 리뷰를 최대한 달고 반영하자! 
   
 <br>

 </div>
 </details>

 <details>
 <summary> ⭐️ Git Flow </summary>
 <div markdown="1">       

 ---
 
 ```
1. 작업 단위별 Issue 생성 : 담당자, 라벨, 프로젝트 연결 

2. Fork 받은 로컬 레포에서 develop 브랜치 최신화 : git pull (origin develop) 

3. Branch 생성 : git switch -c Prefix/#IssueNumber-description 
   > 예시) chore/#3-Project-Setting

4. 로컬 환경에서 작업 후 Add -> Commit -> Push -> Pull Request의 과정을 거친다.
   
   Prefix의 의미
   > [Feat] : 새로운 기능 구현
   > [Chore] : 그 이외의 잡일/ 버전 코드 수정, 패키지 구조 변경, 파일 이동, 파일이름 변경
   > [Add] : 코드 변경 없는 단순 파일 추가, 에셋 및 라이브러리 추가
   > [Setting] : 프로젝트 세팅
   > [Fix] : 버그, 오류 해결, 코드 수정
   > [Style] : 코드 포맷팅, 코드 변경이 없는 경우, 주석 수정
   > [Docs] : README나 WIKI 등의 문서 개정
   > [Refactor] : 전면 수정이 있을 때 사용합니다
   > [Test] : 테스트 모드, 리펙토링 테스트 코드 추가

5. Pull Request 작성 
   - closed : #IssueNumber로 이슈 연결, 리뷰어 지정

6. Code Review 완료 후 Pull Request 작성자가 develop Branch로 merge하기
   - Develop Branch protection rules : Merge 전 최소 1 Approve 필요

7. 종료된 Issue와 Pull Request의 Label과 Project를 관리
```
   
 <br>

 </div>
 </details>

<details>
 <summary> ⭐️ Naming & Code Convention </summary>
 <div markdown="1">       

 ---
 
- 함수, 메서드 : **lowerCamelCase** 사용하고, 동사로 시작한다.
- 변수, 상수 : **lowerCamelCase** 사용한다.
- 클래스, 구조체, enum, extension 등 :  **UpperCamelCase** 사용한다.
- 기본 MVC 폴더링 구조에 따라 파일을 구분하여 사용한다.
- 파일, 클래스 명 약어 사용. 단, UI 선언 구문과 메소드에서는 약어를 사용하지 않는다.
    - 예시) ViewController → `VC`
    - 예시) CollectionViewCell → `CVC`
- 뷰 설정을 위한 함수에서는 **set** 키워드를 사용한다.
    - 예시) func configureUI → `func setUI`
    - 예시) func setDelegate ... → `func configureDelegate`
- 이외 기본 명명규칙은 [Swift Style Guide](https://google.github.io/swift/), [API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/) , [Swift Style Guide](https://github.com/StyleShare/swift-style-guide)를 참고한다.
- 상속받지 않는 클래스는 **final 키워드**를 붙인다.
- 단일 정의 내에서만 사용되는 특정 기능 구현은 **private 접근 제한자**를 적극 사용한다.
- 퀵헬프기능을 활용한 마크업 문법을 활용한 주석을 적극 사용한다.
- 이외는 커스텀한 **SwiftLint Rule**을 적용한다.
   
   
 <br>

 </div>
 </details>

<details>
 <summary> ⭐️ Project Foldering </summary>
 <div markdown="1">       

 ---
```
📦Runnect-iOS
 ┣ 📂Base.lproj
 ┣ 📂Global
 ┃ ┣ 📂Extension
 ┃ ┃ ┣ 📂Combine+
 ┃ ┃ ┣ 📂Foundation+
 ┃ ┃ ┗ 📂UIKit+
 ┃ ┣ 📂Literal
 ┃ ┣ 📂Protocols
 ┃ ┣ 📂Resource
 ┃ ┣ 📂Supports
 ┃ ┣ 📂UIComponents
 ┃ ┗ 📂Utils
 ┣ 📂Network
 ┃ ┣ 📂Dto
 ┃ ┣ 📂Foundation
 ┃ ┣ 📂Model
 ┃ ┣ 📂Router
 ┃ ┗ 📂Service
 ┣ 📂Presentation
 ┃ ┣ 📂CourseDetail
 ┃ ┃ ┣ 📂VC
 ┃ ┃ ┗ 📂Views
 ┃ ┣ 📂CourseDiscovery
 ┃ ┃ ┣ 📂VC
 ┃ ┃ ┗ 📂Views
 ┃ ┣ 📂CourseDrawing
 ┃ ┃ ┣ 📂VC
 ┃ ┃ ┗ 📂Views
 ┃ ┣ 📂CourseStorage
 ┃ ┃ ┣ 📂VC
 ┃ ┃ ┗ 📂Views
 ┃ ┣ 📂MyPage
 ┃ ┃ ┣ 📂VC
 ┃ ┃ ┗ 📂Views
 ┃ ┣ 📂SignIn
 ┃ ┃ ┣ 📂VC
 ┃ ┃ ┗ 📂Views
 ┃ ┣ 📂Splash
 ┃ ┃ ┗ 📂VC
 ┃ ┗ 📂TabBar
 ┗ 📜Info.plist
```
   
 <br>

 </div>
 </details>

###

<br>

## 맡은 뷰와 기능

<details>
 <summary> ⭐ 세진 </summary>
 <div markdown="1">
 
   1. **로그인 뷰**
       ![Untitled](https://user-images.githubusercontent.com/77267404/212248243-b331aebd-3f41-459e-9830-ed65b864addc.png)

       - 닉네임과 `device uuid` 를 이용하여 임시 로그인 기능을 구현했습니다.
       - UI 요소에는 닉네임을 위한 `UITextField`와 닉네임 글자 수 제한 기능을 추가했습니다.
       - 글자 입력 시 텍스트 필드의 테두리 색이 바뀌고 하단의 시작하기 버튼이 활성화 되도록 했습니다.
       
   2. **코스 보관함 뷰**

       ![Untitled 1](https://user-images.githubusercontent.com/77267404/212248300-0ab1ac8e-1333-4039-9962-c8cf7ca0fc2c.png)

       - 커스텀 한 `ViewPager`를 이용하여 코스 보관함 뷰를 구현했습니다. 상단은 `UIButton`, 하단 부분은 `CollectionView`를 이용하여 스크롤이 가능하도록 했습니다. 버튼 하단의 `IndicatorView`를 위치시켜 사용자가 어떠한 탭을 선택했는지 확인할 수 있도록 했습니다.
       - `CollectionView Cell`내부에는 코스 리스트를 담은 또 다른 `CollectionView`를 담아 내가 그린 코스와 스크랩한 코스를 리스트 형식으로 볼 수 있게 했습니다.
       - 서버로부터 받아온 데이터가 없을 때를 위한 `EmptyView`를 구현하여 사용성을 높였습니다.
       - 해당 Cell을 클릭하면 상세한 러닝 코스를 볼 수 있도록 하는 `DetailView`로 이동하도록 했습니다.
       - Cell 내부에는 하트 버튼을 위치시켜 해당 버튼을 누르면 스크랩을 하거나 스크랩을 취소할 수 있는 기능을 추가했습니다. 이를 위해 Protocol-Delegate 패턴을 사용했습니다.
       - 러닝 코스 경로에 필요한 좌표들은 서버로부터 배열 형식으로 받아와 이것을 `NMGLatLng`로 변환하여 지도에 마커를 생성했습니다.
   3. **코스 그리기 뷰**

       ![Untitled 2](https://user-images.githubusercontent.com/77267404/212248325-15e2737f-4524-44ec-a95a-9264b63ba771.png)

       ![Untitled 3](https://user-images.githubusercontent.com/77267404/212248337-3717a174-5dda-4b8b-8a1c-97215c30a579.png)

       - 런넥트의 핵심 기능인 코스 그리기 뷰를 구현했습니다.
       - `네이버 지도 SDK`를 활용하셔 지도 위에 달릴 경로를 그리고 러닝을 하는 동안 러너의 위치를 확인할 수 있는 기능을 구현했습니다. 러닝이 끝나면 경로 이미지와 함께 총거리, 이동 시간, 평균 페이스 등의 수치와 사용자가 입력한 제목을 업로드하여 기록으로 남길 수 있도록 했습니다.
       - UI적 요소로는 중복되는 지도 뷰를 위해 네이버 지도를 `UIView`로 한번 감싼 `RNMapView`를 구현했습니다. 이를 통해 지도 위 마커와 사용자 위치 오버레이, 경로 오버레이, 카메라 이동 버튼 등을 커스텀 하여 여러 `ViewController`에서 쉽게 불러와 사용할 수 있었습니다.
       - 러닝 코스의 출발지 검색 기능은 `카카오 주소 API`를 이용하여 구현했습니다. 사용자가 키워드로 검색을 하면 해당 키워드에 연관된 여러 주소들을 리스트 형식으로 보여줍니다. 여기서 사용자가 특정 위치를 선택하면 해당 위치를 출발지로 설정하고 지도를 터치하여 러닝 코스를 그릴 수 있습니다. 지도를 터치하면 마커가 생성되고 해당 마커 사이를 지나가는 경로선이 자동으로 생성됩니다. 실수로 터치하여 마커가 생성되었다면 우측 하단의 취소 버튼을 눌러 행동을 취소할 수 있습니다.
       - 마커가 생성될 때마다 이전 마커와의 직선거리를 Km 단위로 계산하여 러닝 코스의 총거리를 좌측 하단에서 확인할 수 있도록 구현했습니다. 이를 위해 `CLLocation`을 사용했습니다.
       - 이동 시간을 구하기 위해 Stopwatch 클래스를 구현하였습니다.
       - 시간과 관련된 데이터의 포맷팅을 위해 `RNTimeFormatter` 클래스를 구현하고 이곳에 시간 관련 데이터를 원하는 형태로 포맷팅하는 기능을 추가했습니다. `DateComponentsFormatter` 와 `DateFormatter` 를 사용했습니다.
       - 러닝 기록 작성 뷰에서 저장하기 버튼을 누르면 `Multipart/form-data` 를 이용하여 서버 통신을 진행합니다. 이때 코스 이미지와 러닝 기록 데이터를 서버로 전송합니다.
       - 코스 이미지는 러닝 종료 버튼을 누르는 순간 지도 뷰를 UIImage로 변환하여 다음 뷰로 전달하는 방식을 사용했습니다.
 </div>
</details>

<details>
 <summary> ⭐️ 연우 </summary>
 <div markdown="1">    

 </div>
</details>

<details>
 <summary> ⭐️ 재현 </summary>
 <div markdown="1">    

 </div>
</details>
 
 
<br>
<br>

<p align = "center">
<img width = 700 alt="스크린샷 2023-01-03 오후 2 54 40" src="https://user-images.githubusercontent.com/77267404/210306409-1ecebc5d-2fdd-4bb9-b367-bf4df4165083.png">
</p?
