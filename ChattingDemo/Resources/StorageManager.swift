//
//  StorageManager.swift
//  ChattingDemo
//
//  Created by 陳冠甫 on 2022/4/29.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    static let shared = StorageManager()
    private var storage = Storage.storage().reference()
    public typealias UploadPicCompletion = (Result<String, Error>) -> Void
    
    /// upload pic to firebase and return string to downlaod
    public func uploadProfilePic(with data: Data, fileName: String, completion: @escaping UploadPicCompletion) {
        storage.child("images/\(fileName)").putData(data, metadata: nil) { [weak self] metadata, error in
            // failed
            guard error == nil else {
                print("failed to upload pics to firebase.")
                completion(.failure(StorageError.failToUpload))
                return
            }
            // success
            self?.storage.child("images/\(fileName)").downloadURL { url, error in
                guard let url = url else {
                    print("failed to get download Url.")
                    completion(.failure(StorageError.failToGetDownloadUrl))
                    return
                }
                
                let urlString = url.absoluteString
                print("download url returned \(urlString)")
                completion(.success(urlString))
            }
        }
    }
    
    public enum StorageError: Error {
        case failToUpload
        case failToGetDownloadUrl
    }
    
    public func downloadURL(for path: String, _ completion: @escaping (Result<URL, Error>) -> Void) {
        let reference = storage.child(path)
        
        reference.downloadURL { url, error in
            guard let url = url, error == nil else {
                completion(.failure(StorageError.failToGetDownloadUrl))
                return
            }
            
            completion(.success(url))
        }
    }
    /// upload image that will be sent in a conversation message
    public func uploadMessagePhoto(with data: Data, fileName: String, completion: @escaping UploadPicCompletion) {
        storage.child("message_images/\(fileName)").putData(data, metadata: nil) { [weak self] metadata, error in
            // failed
            guard error == nil else {
                print("failed to upload data to firebase.")
                completion(.failure(StorageError.failToUpload))
                return
            }
            // success
            self?.storage.child("message_images/\(fileName)").downloadURL { url, error in
                guard let url = url else {
                    print("failed to get download Url.")
                    completion(.failure(StorageError.failToGetDownloadUrl))
                    return
                }
                
                let urlString = url.absoluteString
                print("download url returned \(urlString)")
                completion(.success(urlString))
            }
        }
    }
    /// upload video that will be sent in a conversation message
    public func uploadMessageVideo(with fileUrl: URL, fileName: String, completion: @escaping UploadPicCompletion) {
        storage.child("message_videos/\(fileName)").putFile(from: fileUrl, metadata: nil) { [weak self] metadata, error in
            // failed
            guard error == nil else {
                print("failed to upload video to firebase.")
                completion(.failure(StorageError.failToUpload))
                return
            }
            // success
            self?.storage.child("message_videos/\(fileName)").downloadURL { url, error in
                guard let url = url else {
                    print("failed to get download Url.")
                    completion(.failure(StorageError.failToGetDownloadUrl))
                    return
                }
                
                let urlString = url.absoluteString
                print("download url returned \(urlString)")
                completion(.success(urlString))
            }
        }
    }
}
