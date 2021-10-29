//
//  FLStageViewUI.swift
//  flash
//
//  Created by Songwut Maneefun on 28/10/2564 BE.
//

import SwiftUI

class FLStageViewObs: ObservableObject {
    @Published var myMaterialFlash: MaterialFlashPageResult?
    var viewModel: FLFlashCardViewModel?
    var card: FLCardPageResult?
    
    func sendAnswer(_ answer: Any?) {
        guard let card = self.card else { return }
        guard let a = answer as? FLAnswerResult else { return }
        let parame = a.createJSON()
        print("sendAnswer param:\(parame?.jsonString ?? "")")
        self.viewModel?.callAPICardDetailAnswer(card, method: .post, param: parame, complete: { (answer) in
            print("sendAnswer:\(String(describing: answer))")
        })
    }
}

struct FLStageViewUI: View {
    @ObservedObject var viewModelObs = FLStageViewObs()
    
    @State var cardSize:CGSize = CGSize(width: 300, height: 400)
    @State var elementDeck = FLElementDeck()
    var flCreator: FLCreator =  FLCreator(isEditor: false)
    var viewModel: FLFlashCardViewModel
    var flColor: FLColorResult = MockObject.flColor
    var card: FLCardPageResult
    var cardDetail: FLCardPageDetailResult = MockObject.cardDetail
    
    var body: some View {
        ZStack {
            GeometryReader(content: { geometry in
                ForEach(elementDeck.component) { e in
                    if e.type == .text {
                        FLTextElementView(element: e)
                            .modifier(
                                FLSticker(
                                    element: e,
                                    stageSize: geometry.size
                                )
                            )
                        
                    } else if e.type == .image {
                        FLImageElementView(element: e)
                            .modifier(
                                FLSticker(
                                    element: e,
                                    stageSize: geometry.size
                                )
                            )
                        
                    } else if e.type == .shape {
                        FLImageElementView(element: e)
                            .modifier(
                                FLSticker(
                                    element: e,
                                    stageSize: geometry.size
                                )
                            )
                        
                    } else if e.type == .sticker {
                        FLImageElementView(element: e)
                            .modifier(
                                FLSticker(
                                    element: e,
                                    stageSize: geometry.size
                                )
                            )
                        
                    }  else if e.type == .video {
                        
                        
                    }  else if e.type == .quiz {
                        
                    }
                }
            })
        }
        .frame(width: cardSize.width, height: cardSize.height)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(Color(cardDetail.bgColor.hex))
                .background(Color.clear)
        )
        .onAppear(perform: {
            viewModelObs.viewModel = viewModel
            viewModelObs.card = card
            elementDeck.component = cardDetail.componentList
        })
    }
    
    
    func offset(for e: FlashElement) -> CGSize {
        if e != self.elementDeck.activeCard {return .zero}
        
        return elementDeck.topElementOffset
    }
}


struct FLElementDeck {
    var topElementOffset: CGSize = .zero
    var activeCard: FlashElement? = nil
    
    var topElement: FlashElement {
        return component[0]
    }
    
    var component: [FlashElement] = MockObject.cardDetail.componentList
    
    var count: Int {
        return component.count
    }
    
    func position(of e: FlashElement) -> Int {
        return component.firstIndex(of: e) ?? 0
    }
    
    func zIndex(of e: FlashElement) -> Double {
        return Double(count - position(of: e))
    }
    
    

}

struct FLStageViewUIRep: UIViewRepresentable {
    var frame: CGRect
    var flCreator: FLCreator
    var viewModel: FLFlashCardViewModel
    var flColor: FLColorResult
    var card: FLCardPageResult
    
    func makeUIView(context: Context) -> some UIView {
        let view = FLStageView(frame: frame)
        view.flCreator = flCreator
        view.viewModel = viewModel
        view.flColor = flColor
        view.card = card
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

struct FLStageViewUI_Previews: PreviewProvider {
    static var previews: some View {
        FLStageViewUI(cardSize: CGSize(width: 300, height: 400), flCreator: FLCreator(isEditor: false), viewModel: FLFlashCardViewModel(flashId: 6), flColor: MockObject.flColor, card: MockObject.cardDetail)
    }
}



