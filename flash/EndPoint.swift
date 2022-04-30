//
//  FLRequest.swift
//  flash
//
//  Created by Songwut Maneefun on 2/8/2564 BE.
//

import Foundation

enum EndPoint:String {
    case ugcFlashCardDetail = "ugc/flash-card/%@/"
    case ugcCardIdDropbox = "ugc/flash-card/%@/card/%@/dropbox/"
    case ugcCardList = "ugc/flash-card/%@/card/"
    case ugcCardListDuplicate = "ugc/flash-card/%@/card/duplicate/"
    case ugcCardDetailUserAnswer = "ugc/flash-card/%@/card/%@/answer/"
    case ugcCardListDetail = "ugc/flash-card/%@/card/%@/"
    case ugcFlashCard = "ugc/flash-card/"
    case ugcFlashColor = "ugc/flash-card/color/"
    case ugcFlashSticker = "ugc/flash-card/sticker/"
    case ugcFlashShape = "ugc/flash-card/shape/"
    
    case ugcFlashPostSubmit = "ugc/flash-card/%@/content-request/submit/"
    case ugcFlashPostCancel = "ugc/flash-card/%@/content-request/cancel/"
    
    case userReadFlashCard = "flash-card/%@/"
    
    case myContent = "content/my-content/"
    case tagSelectList = "tag/type/MATERIAL_TYPE/"
    case learningContentCoverList = "learning-content/content-cover/"
    case subCategory = "sub-category/"
    case filterSubCategory = "filter/sub-category/"
    case learningMaterialDetail = "%@%@%@"//LM/type/id
    
    //create video
    case ugcVideo = "ugc/video/"
    case ugcVideoDetail = "ugc/video/%@/"
    case myContentV2 = "content/v2/my-content/"
    case ugcVideoPostSubmit = "ugc/video/%@/content-request/submit/"
    case ugcVideoPostCancel = "ugc/video/%@/content-request/cancel/"
    case ugcVideoResumable = "ugc/video/%@/resumable/"
    
    //create audio
    case ugcAudio = "ugc/audio/"
    case ugcAudioDetail = "ugc/audio/%@/"
    case ugcAudioPostSubmit = "ugc/audio/%@/content-request/submit/"
    case ugcAudioPostCancel = "ugc/audio/%@/content-request/cancel/"
    case ugcAudioResumable = "ugc/audio/%@/resumable/"
    
    //create audio
    case ugcDocument = "ugc/document/"
    case ugcDocumentDetail = "ugc/document/%@/"
    case ugcDocumentPostSubmit = "ugc/document/%@/content-request/submit/"
    case ugcDocumentPostCancel = "ugc/document/%@/content-request/cancel/"
    case ugcDocumentResumable = "ugc/document/%@/resumable/"
    
    func parentPath(parents: [Any?]) -> String {
        var parentPath = ""
        
        for parent in parents {
            if let lp = parent as? APIParam, let apiStr = lp.learningPathAPI() {//learning-path/secheule
                parentPath = "\(parentPath)\(apiStr)"
            }
            
            if let parent = parent as? Parent {//course, class
                let name = parent.name
                parentPath = parentPath + "\(parent.apiParam("\(name)"))"
            }
        }
        return parentPath
    }
    
    func path(code: ContentCode = .flashcard) -> String {
        switch code {
        case .video:
            return "video"
        case .audio:
            return"audio"
        default:
            return "flash-card" //create from flashcard
        }
    }
}


struct UGCPath {
    static func materialDetail(code: ContentCode) -> EndPoint {
        switch code {
        case .video:
            return .ugcVideoDetail
        case .audio:
            return .ugcAudioDetail
        case .flashcard:
            return .ugcFlashCardDetail
        case .pdf:
            return .ugcDocumentDetail
        default:
            return .ugcFlashCardDetail
        }
    }

    static func materialSubmit(code: ContentCode) -> EndPoint {
        switch code {
        case .audio:
            return .ugcAudioPostSubmit
        case .video:
            return .ugcVideoPostSubmit
        case .flashcard:
            return .ugcFlashPostSubmit
        case .pdf:
            return .ugcDocumentPostSubmit
        default:
            return .ugcFlashPostSubmit
        }
    }

    static func materialCancel(code: ContentCode) -> EndPoint {
        switch code {
        case .audio:
            return .ugcAudioPostCancel
        case .video:
            return .ugcVideoPostCancel
        case .flashcard:
            return .ugcFlashPostCancel
        case .pdf:
            return .ugcDocumentPostCancel
        default:
            return .ugcFlashPostCancel
        }
    }
    
    static func materialCreate(code: ContentCode) -> EndPoint {
        switch code {
        case .video:
            return .ugcVideo
        case .audio:
            return .ugcAudio
        case .pdf:
            return .ugcDocument
        default:
            return .ugcFlashCard
        }
    }
    
    static func materialUploadResume(code: ContentCode) -> EndPoint {
        switch code {
        case .video:
            return .ugcVideoResumable
        case .audio:
            return .ugcAudioResumable
        case .pdf:
            return .ugcDocumentResumable
        default:
            return .ugcFlashCard
        }
    }
}
