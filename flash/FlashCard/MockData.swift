//
//  MockData.swift
//  flash
//
//  Created by Songwut Maneefun on 24/10/2564 BE.
//

import Foundation


struct MockObject {
    
    
    static var myMaterialFlash: MaterialFlashPageResult {
        let item = MaterialFlashPageResult(JSON: ["count" : 3])!
        item.list = MockObject.myMaterialFlashList
        return item
    }
        
    
    static var myMaterialFlashList: [MaterialFlashResult] {
        return [
            MaterialFlashResult(JSON: [
                "id": 167,
                "code": "CARD00137",
                "image": "https://develop.conicle.co/media/flash_card/2021/10/5abf5d07-f46.png",
                      "name": "Untitled - 01"
            ])!,
            MaterialFlashResult(JSON: [
                "id": 166,
                "code": "CARD00136",
                "image": "https://develop.conicle.co/media/flash_card/2021/10/0b2bd6c8-bd7.png",
                      "name": "Untitled - 02"
            ])!,
            MaterialFlashResult(JSON: [
                "id": 165,
                "code": "CARD00135",
                "image": "https://develop.conicle.co/media/flash_card/2021/10/e49105c8-39e.png",
                "name": "Untitled - 03"
            ])!,
        ]
        
    }
}
