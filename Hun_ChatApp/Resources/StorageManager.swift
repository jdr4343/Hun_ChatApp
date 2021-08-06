//
//  StorageManager.swift
//  Hun_ChatApp
//
//  Created by 신지훈 on 2021/08/06.
//

import Foundation
import FirebaseStorage
//항상 생성한 객체를 분리하여 재사용이 가능하고 애플리케이션 전체에서 모듈식으로 재활용 할것입니다.

//final 속성으로 상속이 불가능한 클래스를 만들고 정적속성인 shared를 만들겠습니다.
final class StorageManager {
    static let shared = StorageManager()
    //저장소
    private let storage = Storage.storage().reference()
    
//MARk - /images/jdr4343-naver-com_Profile_Picture.png
    
    //데이터에 바이트를 입력할 수 있는 함수를 추가하겠습니다.
    //Firebase 저장소에 사진을 업로드하고 URL로 반환을 완료 하겠습니다. / 문자열을 업로드 하는데 실패할수 있으므로 문자열을 반환하는 대신 결과 개체를 반환하고 실제로 성공하면 문자열을 반환합니다. 그렇지 않으면 오류를 반환합니다.Typealias로 타입으로 바꿔서 할당 하겠습니다.
    public typealias UPloadPictureCompletion = (Result<String, Error>) -> Void
    public func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping UPloadPictureCompletion) {
        storage.child("images/\(fileName)").putData(data, metadata: nil, completion: { metadata, error in
            guard error == nil else {
                //faild / 오류 전달 / 디버깅을 위한 출력문
                print("failed to upload data to firebase fot picture")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            //업로드에 성공 했다면 URL을 가져오겠습니다.
            self.storage.child("images/\(fileName)").downloadURL(completion: { url, error in
                guard let url = url else {
                    print("Failed to get download url")
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }
                let urlString = url.absoluteString
                print("download url returned: \(urlString)")
                
            })
        })
    }
    //오류 정의 업로드에 실패
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDownloadUrl
    }
    //지정한 경로를 기반으로 다운로드 URL을 반환할 함수를 만들겠습니다. 클로저 escaping에서 escaping은 여기에서 완료를 호출할때 firebase가 제공하는 실행 블록을 탈출할 수 있음을 의미합니다.
    public func downloadURL(for path: String, complation: @escaping (Result<URL, Error>) -> Void) {
        let reference = storage.child(path)
        reference.downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                complation(.failure(StorageErrors.failedToGetDownloadUrl))
                return
            }
            complation(.success(url))
        })
    }
 }



