//
//  MockData.swift
//  flash
//
//  Created by Songwut Maneefun on 24/10/2564 BE.
//

import Foundation


struct MockObject {
    static var createList: [LMCreateItem] {
        return JSON.loadItemList("create-list.json")
    }
    
    //item
//    static var createList: [LMCreateItem] = [
//        LMCreateItem(JSON: [
//                        "name" : "flash",
//                        "code" : "flashcard.flashcard",
//                        "is_available": true,
//                        "image": "https://develop.conicle.co/media/default/content/default_flash_card_material.png"])!,
//        LMCreateItem(JSON: ["name" : "video", "code" : "video.video"])!,
//        LMCreateItem(JSON: ["name" : "video", "code" : "audio.audio"])!,
//        LMCreateItem(JSON: ["name" : "external_video", "code" : "video.video"])!,
//        LMCreateItem(JSON: ["name" : "video", "code" : "video.video"])!
//    ]
    
    static var flColor: FLColorResult = FLColorResult(JSON: ["code" : "color_01", "cl_code": "FFFFFF"])!
    static var detail = FLDetailResult(JSON: ["name" : "detail.name"])!
    
    static var userAnswerPage: UserAnswerPageResult {
        let data: [String: Any] = [
            "api": "web",
            "config_datetime_update": "2021-10-28T18:24:48.189536Z",
            "datetime_update": "2021-10-28T18:24:48.189536Z",
            "dict_datetime_update": "2021-10-22T10:29:21.737542Z",
            "id": 337,
            "image": "https://develop.conicle.co/media/flash_card/card/2021/10/a5c00f92-027.jpg",
            "sort": 1
        ]
        let item = UserAnswerPageResult(JSON: data)!
        
        return item
    }
    
    
    static var cardList = [
        FLCardPageResult(JSON: ["name" : "Any", "sort": 1])!,
        FLCardPageResult(JSON: ["name" : "Any", "sort": 2])!,
        FLCardPageResult(JSON: ["name" : "Any", "sort": 3])!,
        FLCardPageResult(JSON: ["name" : "Any", "sort": 4])!,
        FLCardPageResult(JSON: ["name" : "Any", "sort": 5])!
    ]
    
    static var cardDetail: FLCardPageDetailResult {
        let data: [String: Any] = [
            "api": "web",
            "config_datetime_update": "2021-10-28T18:24:48.189536Z",
            "datetime_update": "2021-10-28T18:24:48.189536Z",
            "dict_datetime_update": "2021-10-22T10:29:21.737542Z",
            "id": 337,
            "image": "https://develop.conicle.co/media/flash_card/card/2021/10/a5c00f92-027.jpg",
            "sort": 1
        ]
        let componentList = [
            stickerElement,
            textElement,
            shapeElement
        ]
        let item = FLCardPageDetailResult(JSON: data)!
        item.bgColor = FLColorResult(JSON: ["cl_code" : "B5E6EA"])!
        item.componentList = componentList
        //item.owner = OwnerResult(JSON: ["id": 1323, "name": "camp ios"])
        //item.contentCode = ./
        //item.requestStatus = .completed
        return item
    }
    
    static var stickerElement: FlashElement {
        let data: [String: Any] = [
            "code": "sticker_03",
            "type": "sticker",
            "sort": 3,
            "width": 37.399711225937374,
            "height": 25.06137886704988,
            "position_y": 58.890520554093385,
            "position_x": 26.425436923378392,
            "rotation": 45,
            "src": "https://develop.conicle.co/media/flashcard/images/sticker/sticker_03.png"
        ]
        return FlashElement(JSON: data)!
    }
    
    static var shapeElement: FlashElement {
        let data: [String: Any] = [
            "code" : "shape_01",
            "height" : "20.10286554004409",
            "position_x" : "23.5745580572831",
            "position_y" : "19.50771267321249",
            "rotation" : 0,
            "sort" : 1,
            "src" : "https://develop.conicle.co/media/flashcard/images/shape/shape_01.png",
            "type" : "shape",
            "width" : 30,
        ]
        return FlashElement(JSON: data)!
    }
    
    static var textElement: FlashElement {
        let data: [String: Any] = [
            "font_size" : 36,
            "height" : "17.48714180749449",
            "position_x" : "64.36403676083214",
            "position_y" : "21.49155145178465",
            "rotation" : 0,
            "scale" : 0,
            "sort" : 4,
            "text" : "Love",
            "text_alignment" : "center",
            "text_color" : "F4F4F4",
            "type" : "text",
            "width" : "60.19736842105263",
            "text_style" : ["bold", "italic", "underline"]
        ]
        return FlashElement(JSON: data)!
    }
    
    static var materialFlash: LMMaterialResult {
        let data: [String: Any] = [
            "name" : "10 Figma Tricks I Wish I Knew Earlier",
            "id": 199,
            "code": "CARD00002",
            "image": "https://develop.conicle.co/media/flash_card/2021/10/d5af4102-abe.png",
            "name": "Untitled - 01",
            "desc": "desc",
            "tag_list": [],
            "category": "category",
            "provider": "provider",
            "datetime_create": "2021-10-28T13:23:46.251647+07:00",
            "datetime_update": "2021-10-28T13:23:46.251692+07:00",
            "request_status": "completed"
        ]
        let item = LMMaterialResult(JSON: data)!
        item.owner = OwnerResult(JSON: ["id": 1323, "name": "camp ios"])
        item.contentCode = .flash
        item.requestStatus = .completed
        return item
    }
    
    
    static var myMaterialFlash: MaterialFlashPageResult {
        return JSON.loadItem("my-content.json")//item
    }
}
