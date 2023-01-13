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
 
   ![%E1%84%8F%E1%85%A9%E1%84%89%E1%85%B3%E1%84%87%E1%85%A1%E1%86%AF%E1%84%80%E1%85%A7%E1%86%AB_ios](https://user-images.githubusercontent.com/77267404/212248971-e7d9d6dd-39d2-475e-ba57-014ba776cfd3.png)

   `코스 발견` 탭에 있는 뷰들을 구현했습니다. 

   네비게이션바와 탭바는 세진이가 프로젝트 세팅 시에 구현해놓았던 뷰를 재사용했습니다.

   1. **CourseDiscoveryVC UI**
   - `CollectionView`를 활용하여 구현했습니다. 3개의 섹션으로 나누어 각 섹션에 UIViewCell을 만들어 Cell안에 View가 들어가도록 했습니다. 즉, 이 View에는 CollectionView 하나만 존재하며, 1번째 섹션에는 광고 이미지뷰가, 2번째 섹션에는 헤더가, 3번째 섹션에는 MapListCell들이 들어가있습니다. MapListCell 은 CourseListCVC를 재사용하여 구현했습니다.
   - API 연결
   이 View 에는 MapListCell을 View에 뿌려주는 API와 스크랩이 되었는지 안되었는지를 보여주는 API , 2개를 연결해놓았습니다. `Moya` 를 사용하여 Provider를 통해 서버와 통신시켜놓았습니다.

   2. **SearchVC UI**
   - 기능명세서대로 CourseDiscoveryVC에서 돋보기 버튼을 누르면 이 뷰가 Push 되도록 구현했습니다. - 프로젝트 세팅 시에 구현해놓은 NavigationBar 에 검색 타입으로 뷰를 재사용 하였고, `PlaceHolder`를 추가해주었습니다. 검색버튼을 누르면 CourseListCVC를 또 재사용하여 collectionView를 불러오는 방식으로 구현했습니다.
   - API 연결
   이 View 에는 검색을 하면 `keword`에 맞는 MapListCell을 보여주는 API를 연결했습니다. API 명세서대로 파라미터를 keword로 설정해놓고 서버와 통신시켜놓는 방식으로 구현했습니다.

   3. **MyCourseSelectVC UI**

    1) 코스그리기 뷰에서 그렸던 코스들을 불러와, 이 중에서 업로드하고 싶은 코스 1개를 select 하고,

    2) 선택하기 버튼을 누르면,

    3) CourseUploadVC UI로 push 되게 구현했습니다.

   - 뷰는 CourseListCVC를 재사용하여 `CollectionView`로 구현했습니다. 그리고 컬렉션뷰 셀에서 셀을 선택하면 셀 내 imageView에 bounder가 생기게 함수를 구현했습니다. 이 때 cell 을 선택하면 그 전에 선택한 cell은 취소가 되게 구현했습니다. 그리고 추가로 cell을 1개 선택하면 업로드하기 버튼이 보라색이 되는 방식으로 구현했습니다.
   - API 연결
   내가 그렸던 코스들을 불러와 view에 뿌려주는 API를 연결했습니다.

   4. **CourseUploadVC UI**
   - 사용자가 select한 코스에 Title과 description을 작성하는 View입니다. 제목을 적는 `TitleTextField`와 설명을 적는 `UITextView`를 활용하여 구현했습니다.
   - 각각 기능명세서에 명시된대로 글자수 제한 함수를 걸어놓고, 디자인해놓은 대로 PlaceHolder를 구현했습니다. 그리고 사용자가 Text를 입력하기 시작할 때와 끝날 때 함수를 구현해놓아 Text를 입력하기 시작하면, 1) Placeholder가 사라지고 2) 업로드하기 버튼이 보라색으로 활성화되고  2) 키보드가 올라오되 View를 키보드를 올린만큼 올려서 View가 키보드에 의해 가려지지 않게 구현했습니다. Upload버튼을 누르면 Discovery VC로 돌아가게 해주었습니다.
   - API 연결
   `POST` 메소드를 이용한 API를 연결해놓았습니다.

 </div>
</details>

<details>
 <summary> ⭐️ 재현 </summary>
 <div markdown="1">    
   <img width="905" alt="%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7_2023-01-13_%EC%98%A4%ED%9B%84_1 46 30" src="https://user-images.githubusercontent.com/77267404/212249228-a2eacb8c-e4ac-4c31-80bb-34f726d47e37.png">

   저는 마이페이지 뷰를 담당했습니다. 

   - `마이페이지` - `메인` : MyPageVC
       - 사용자의 진척도를 나타내기 위해 UIProgressView를 처음 사용해보았습니다 .. 🥴
       - UI가 반복되는 목표 보상, 활동 기록, 업로드한 코스의 레이아웃을 그리는 함수를 만들어 활용해보았습니다.
   - `마이페이지` - `메인` - `닉네임 수정` : NicknameEditorVC
       - 텍스트가 입력 되었을 때만 return 키가 활성화되도록 구현했습니다.
       - 키보드의 return 키가 눌렸을 때, 팝업창 뒷쪽의 백그라운드 뷰를 눌렀을 때 값이 return 될 수 있도록 구현했습니다.
       - 백그라운드 뷰에 투명도가 설정되어 있어 viewWillAppear를 쓸 수 없었고, delegate를 사용했습니다.
   - `마이페이지` - `목표 보상` : GoalRewardInfoVC
       - UICollectionView를 활용해 스탬프를 나타냈습니다.
       - 시뮬레이터 화면의 크기가 커졌을 때 콜렉션뷰가 깨지는 이유와, 이를 해결하기 위해 셀의 너비값 대비 비율을 활용해서 크기를 유동적으로 설정하는 법을 배웠습니다.
       - 서버에서 보내주는 스탬프 id만 스탬프 사진을 나타내고, 나머지는 잠금 이미지로 나타낼 수 있도록 구현했습니다. (어려웠습니다..)
   - `마이페이지` - `활동 기록` : ActivityRecordInfoVC
       - UITableView를 활용해 활동 기록을 나타냈습니다.
       - 셀 안에 들어가는 요소들을 일정한 간격으로 배치하기 위해 UIStackView를 활용했습니다.
       - DateFormatter를 활용해 서버에서 보내주는 날짜 데이터를 UI에 맞추어 변경하는 법을 배우고, NSMutableAttributedString를 처음 써보았습니다 ~.~
   - `마이페이지` - `업로드한 코스` : UploadedCourseInfoVC
       - UICollectionView를 활용해 업로드한 코스를 나타냈습니다.
   - `코스 발견` - `추천 코스 상세 페이지` : CourseDetailVC


 </div>
</details>
 

<br>

## 어려웠던 부분과 극복 과정

<details>
 <summary> ⭐ 세진 </summary>
 <div markdown="1">
 
 - 협업
   - 프로젝트 초반 기능 회의에서 서비스의 전반적인 목표 설정과 필수 기능에 대한 모호함이 있었으나 지속적인 의사소통과 각 파트 간 배려로 기획 및 기능을 잘 정립하고 개발에 집중할 수 있었습니다.
   - 깃 사용에 있어서 팀원들의 경험이 부족하여 프로젝트 초반에 걱정을 하였으나 지속적으로 깃 플로우에 대한 설명을 하고 직접 흐름을 시범을 통해 보여주면서 전반적인 이해도를 높일 수 있었습니다. 이러한 사전 준비를 통해 프로젝트를 진행하면서 깃으로 인한 큰 트러블이 발생하지 않았습니다.
  
- 공통 UI Components
  - Navigation Bar, 버튼, 통계 뷰 등 다양한 곳에서 중복적으로 사용되는 UI를 별도의 객체로 생성하여 필요한 곳에서 쉽게 사용할 수 있도록 했습니다. `@discardableResult` 를 이용하여 메소드 체이닝 형식으로 UI를 선언하고 사용할 수 있도록 Component들을 구현하여 효율성과 가독성을 높였습니다.
  
- 로그인/회원가입 기능 구현
  - iOS 에서는 앱 재설치를 하면 `device uuid`가 변경되는 이슈가 있었는데 최초 설치시 `keychain`에 device uuid를 저장하는 방식으로 문제를 해결했습니다.
 
- 지도 뷰 구현
  - 네이버 지도를 커스텀하는 과정에서 네이버 지도에서 사용하는 좌표 객체인 `NMGLatLng` 과 iOS에서 사용하는 `CLLocation`의 상호 전환이 필요했는데 이를 위해 Location 정보의 처리를 담당하는 Util 파일을 생성하고 이곳에 다양한 좌표 클래스를 확장하여 문제를 해결했습니다.
  - 지도 위에 보여줄 커스텀한 마커 구현을 위해 네이버에서 제공하는 기본 Marker 클래스를 상속하여 구현했습니다.
  - 러닝 통계를 위한 뷰에서는 중복되는 UI가 많아서 UIComponents 폴더에 별도로 분리하여 구현하여 재사용성을 높였습니다.
  - 지도 뷰를 UIImage로 변환하기 위해 좌표들 위치에 맞게 지도 뷰의 카메라를 이동시켜야 했는데 이를 위해 네이버 지도 SDK에서 제공하는 기능인 `NMGLatLngBounds` 를 사용했습니다. 좌표들의 가장 남서쪽 위치와 북동쪽 위치를 이용하여 바운더리를 생성하고 이곳으로 카메라를 이동시켜 뷰를 캡쳐하는 방식을 사용했습니다. 이때, 카메라가 미쳐 이동을 완료하기 전에 UIImage로 변환을 시도하면 이미지가 정상적으로 생성되지 않는 점을 방지하기 위해 `DispatchQueue.main.asyncAfter`로 2초의 딜레이를 주었습니다.
 
- 보관함 - ViewPager
  - 코스 보관함에 필요한 ViewPager를 Component화 하여 구현하였습니다. 하단의 컬렉션 뷰를 좌우로 스콜하면 버튼 밑의 IndicatorView의 위치가 자연스럽게 이동하는 것을 구현하기 위해`scrollViewDidScroll` 에서 전체 컬렉션 뷰(스크롤 뷰)에서 스크롤된 만큼의 percent를 계산하여 ViewPager 클래스에 전달하였습니다. 이러한 바인딩을 편리하게 하기 위해 Combine을 사용하였습니다.
 
- 이벤트 처리
  - 버튼의 터치 액션과 ViewPager의 스크롤 여부 등의 이벤트 비동기 처리를 위해 부분적으로 Combine을 사용했습니다.
 
 </div>
</details>

<details>
 <summary> ⭐ 연우 </summary>
 <div markdown="1">
   Git을 활용하여 협업을 하는 방법이 익숙치 않았고, 코드가 중복되는 것들을 하나로 묶어서 재사용하는 방식이 익숙하지 않아 코드를 효율적으로 짜는 부분이 어려웠습니다. CollectionView를 사용할 일이 많았는데 view자체를 구현하는 것은 배웠던 것을 활용하면 되었지만 Cell 내에서 함수를 구현하여 적용하는 것은 처음해봐서 어려움이 많았습니다. 특히 유저가 코스에 대한 제목과 설명을 쓰는 뷰에서 TextView에 여러 함수를 걸어놓았어야 했는데 글자수 제한을 걸어놓고, placeholder 가 있다가 사라져야 하고 View의 크기도 계산해서 키보드를 올려야 하고  … 생각해야 하는 부분이 많아서 구현이 오래걸렸습니다. 
  먼저 구글링을 해서 다른 사람들이 짠 코드를 분석해보고 따라쳐보고, 내 것에 맞게 바꿀 부분은 바꿔서 사용했고, 리드 친구가 짠 코드를 분석해서 모르는 부분은 물어보며 코드를 적용했습니다.
 <div>
  <img width="700" alt="%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-01-13_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_2 25 55" src="https://user-images.githubusercontent.com/77267404/212250974-30513a80-1326-4e3a-83ca-39c22aff2da7.png">
 </div>
  
  
 나중에 또봐야지…하고 메모도 해놓았습니다

 서버통신구현은 특히 제일 난관일 것이라 생각했는데 리드친구가 다시 처음부터 차근차근 다 알려주어서 어느정도 이해를 한 상태에서 코드를 작성하였습니다. 중간중간 헷갈리는 것도 있었지만 그럴 때는 다시 리드가 짠 코드를 보며 이해하려고 노력하고.. 그래도 이해가 안되면 리드친구한테 물어보며 해결해나갔습니다.. 

 이번 프로젝트를 하면서 언어를 활용하여 앱을 개발한다는 것이 단순히 몇 가지 컴포넌트를 활용해서 주먹구구로 짜는 건 누구나 할 수 있지만 이 언어 자체를 완벽히 이해하고 swift에서 제공하는 여러 기능들을 활용하는 것이 중요하다는 것을 알게 되었고 이 부분에 대해 무지했음을 알고 … 훨씬 더 많이 언어를 공부해야겠다는 생각을 했습니다.
 </div>
</details>

<details>
 <summary> ⭐ 재현 </summary>
 <div markdown="1">
 
 </div>
</details>
 

<br>
<br>

<p align = "center">
<img width = 700 alt="스크린샷 2023-01-03 오후 2 54 40" src="https://user-images.githubusercontent.com/77267404/210306409-1ecebc5d-2fdd-4bb9-b367-bf4df4165083.png">
</p?
