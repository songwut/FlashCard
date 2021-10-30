//
//  CardSwipeLoopView.swift
//  CardSwipeLoopView
//
//  Created by Songwut Maneefun on 23/10/2564 BE.
// ref: https://github.com/Swift-Compiled/SwiftUI-Cards

import SwiftUI

struct Card: Identifiable, Equatable {
    let id = UUID()
    let question: String
    let color: Color
}

struct Deck {
    let maxNumberShow = 2
    var topCardOffset: CGSize = .zero
    var activeCard: Card? = nil
    
    var cards = [
        Card(question: "The tallest building in the world is located in which city?", color: .purple),
        Card(question: "Which year was the original Toy Story film released?", color: .red),
        Card(question: "Which film was the first to be recognised as part of the Marvel Cinematic Universe?", color: .green),
        Card(question: "Name the longest river in the UK.", color: .blue),
        Card(question: "In which year was the popular video game Fortnite first released?", color: .orange)
    ]
    
    var topCard: Card {
        return cards[0]
    }
    
    var count: Int {
        return cards.count
    }
    
    func position(of card: Card) -> Int {
        return cards.firstIndex(of: card) ?? 0
    }
    
    func scale(of card: Card) -> CGFloat {
        let deckPosition = position(of: card)
        let scale = CGFloat(deckPosition) * 0.02
        return CGFloat(1 - scale)
    }
    
    func deckOffsetY(of card: Card) -> CGFloat {
        let deckPosition = position(of: card)
        if deckPosition < maxNumberShow {
            let offset = deckPosition * 18
            return CGFloat(offset)
        } else {
            return CGFloat(deckPosition)
        }
    }
    
    func deckOffsetX(of card: Card) -> CGFloat {
        let deckPosition = position(of: card)
        if deckPosition < maxNumberShow {
            let offset = deckPosition * 18
            return CGFloat(offset)
        } else {
            return CGFloat(deckPosition)
        }
    }
    
    func opacity(of card: Card) -> Double {
        let deckPosition = position(of: card)
        if deckPosition < maxNumberShow {
            return Double(1)
        } else {
            return Double(0)
        }
    }
    
    func zIndex(of card: Card) -> Double {
        return Double(count - position(of: card))
    }
    
    func rotation(for card: Card, offset: CGSize = .zero) -> Angle {
        return .degrees(Double(offset.width) / 20.0)
    }
    
    mutating func moveToBack(_ state: Card) {
        let topCard = cards.remove(at: position(of: state))
        cards.append(topCard)
    }
    
    mutating func moveToFront(_ state: Card) {
        let topCard = cards.remove(at: position(of: state))
        cards.insert(topCard, at: 0)
    }
}

struct CardSwipeLoopView: View {
    @State var deck: FLDeck = FLDeck()
    @State var cardSize:CGSize = CGSize(width: 300, height: 400)
    
    var flCreator: FLCreator
    var viewModel: FLFlashCardViewModel
    var flColor: FLColorResult?
    //var card: FLCardPageResult
    
    var body: some View {
        ZStack {
            ForEach(deck.cards) { card in
                //CardView(card: card, cardSize: cardSize)
                FLStageViewUI(
                    flCreator: flCreator,
                    viewModel: viewModel,
                    flColor: flColor ?? MockObject.flColor,
                    card: card)
                    .zIndex(self.deck.zIndex(of: card))
                    .shadow(radius: 2)
                    .offset(x: self.offset(for: card).width, y: self.offset(for: card).height)
                    //position change here
                    .offset(
                        x: self.deck.deckOffsetX(of: card),
                        y: self.deck.deckOffsetY(of: card)
                    )
                    .opacity(self.deck.opacity(of: card))
                    .scaleEffect(x: self.deck.scale(of: card), y: self.deck.scale(of: card))
                    .rotationEffect(self.rotation(for: card))
                    .background(Color.clear)
                    .gesture(
                        DragGesture()
                            .onChanged({ (drag) in
                                if self.deck.activeCard == nil {
                                    self.deck.activeCard = card
                                }
                                if card != self.deck.activeCard {return}

                                withAnimation(.spring()) {
                                    self.deck.topCardOffset = drag.translation
                                    if
                                        drag.translation.width < -200 ||
                                            drag.translation.width > 200 ||
                                            drag.translation.height < -250 ||
                                            drag.translation.height > 250 {
                                        self.deck.moveToBack(card)
                                    } else {
                                        self.deck.moveToFront(card)
                                    }
                                }
                            })
                            .onEnded({ (drag) in
                                withAnimation(.spring()) {
                                    self.deck.activeCard = nil
                                    self.deck.topCardOffset = .zero
                                }
                            })
                )
            }
        }
        .background(Color.clear)
    }
    
    func offset(for card: FLCardPageResult) -> CGSize {
        if card != self.deck.activeCard {return .zero}
        
        return deck.topCardOffset
    }
    
    func rotation(for card: FLCardPageResult) -> Angle {
        guard let activeCard = self.deck.activeCard
            else {return .degrees(0)}
        
        if card != activeCard {return .degrees(0)}
        
        return deck.rotation(for: activeCard, offset: deck.topCardOffset)
    }
}

struct CardView: View {
    let card: Card
    @State var cardSize:CGSize = CGSize(width: 300, height: 400)
    
    var body: some View {
        VStack {
            VStack {
                Text("QUIZ NIGHT")
                    .font(.title)
                    .foregroundColor(.white)
                    .bold()
                Divider()
                Spacer()
                Text(card.question)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Spacer()
            }
        }
        .padding()
        .frame(width: cardSize.width, height: cardSize.height)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(card.color)
                .background(Color.clear)
        )
    }
}

struct CardSwipeLoopView_Previews: PreviewProvider {
    static var previews: some View {
        CardSwipeLoopView(flCreator: FLCreator(isEditor: false), viewModel: FLFlashCardViewModel(), flColor: MockObject.flColor)
    }
}

