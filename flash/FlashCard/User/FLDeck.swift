//
//  FLDeck.swift
//  flash
//
//  Created by Songwut Maneefun on 29/10/2564 BE.
//

import SwiftUI

struct FLDeck {
    let maxNumberShow = 2
    var topCardOffset: CGSize = .zero
    var activeCard: FLCardPageResult? = nil
    
    var cards = MockObject.cardList
    
    var topCard: FLCardPageResult {
        return cards[0]
    }
    
    var count: Int {
        return cards.count
    }
    
    func position(of card: FLCardPageResult) -> Int {
        return cards.firstIndex(of: card) ?? 0
    }
    
    func scale(of card: FLCardPageResult) -> CGFloat {
        let deckPosition = position(of: card)
        let scale = CGFloat(deckPosition) * 0.02
        return CGFloat(1 - scale)
    }
    
    func deckOffsetY(of card: FLCardPageResult) -> CGFloat {
        let deckPosition = position(of: card)
        if deckPosition < maxNumberShow {
            let offset = deckPosition * 18
            return CGFloat(offset)
        } else {
            return CGFloat(deckPosition)
        }
    }
    
    func deckOffsetX(of card: FLCardPageResult) -> CGFloat {
        let deckPosition = position(of: card)
        if deckPosition < maxNumberShow {
            let offset = deckPosition * 18
            return CGFloat(offset)
        } else {
            return CGFloat(deckPosition)
        }
    }
    
    func opacity(of card: FLCardPageResult) -> Double {
        let deckPosition = position(of: card)
        if deckPosition < maxNumberShow {
            return Double(1)
        } else {
            return Double(0)
        }
    }
    
    func zIndex(of card: FLCardPageResult) -> Double {
        return Double(count - position(of: card))
    }
    
    func rotation(for card: FLCardPageResult, offset: CGSize = .zero) -> Angle {
        return .degrees(Double(offset.width) / 20.0)
    }
    
    mutating func moveToBack(_ state: FLCardPageResult) {
        let topCard = cards.remove(at: position(of: state))
        cards.append(topCard)
    }
    
    mutating func moveToFront(_ state: FLCardPageResult) {
        let topCard = cards.remove(at: position(of: state))
        cards.insert(topCard, at: 0)
    }
}


