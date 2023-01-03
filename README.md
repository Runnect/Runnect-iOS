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
<br>

<p align = "center">
<img width = 700 alt="스크린샷 2023-01-03 오후 2 54 40" src="https://user-images.githubusercontent.com/77267404/210306409-1ecebc5d-2fdd-4bb9-b367-bf4df4165083.png">
</p?
