//
//  PhotoRealmServices.swift
//  MyBodyMap
//
//  Created by Иван on 12.07.2025.
//

import Foundation
import RealmSwift
import ComposableArchitecture

protocol PhotoStoring {
    func addPhoto(_ data: Data, _ date: Date)
    func fetchAll() -> [Data]
}

final class PhotoRealmService: PhotoStoring {
    func addPhoto(_ data: Data, _ date: Date) {
        let realm = try! Realm()
        let entry = ProgressPhoto()
        entry.date = date
        entry.data = data
        try! realm.write { realm.add(entry) }
    }
    func fetchAll() -> [Data] {
        let realm = try! Realm()
        return realm.objects(ProgressPhoto.self)
            .sorted(byKeyPath: "date", ascending: true)
            .map { $0.data }
    }
}

private enum PhotoServiceKey: DependencyKey {
    static let liveValue: PhotoStoring = PhotoRealmService()
}
extension DependencyValues {
    var photoService: PhotoStoring {
        get { self[PhotoServiceKey.self] }
        set { self[PhotoServiceKey.self] = newValue }
    }
}
