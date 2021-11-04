//
//  ListSeparatorStyleNoneModifier.swift
//  flash
//
//  Created by Songwut Maneefun on 4/11/2564 BE.
//

import SwiftUI

public struct ListSeparatorStyleNoneModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content.onAppear {
            UITableView.appearance().tableFooterView = UIView()
            UITableView.appearance().separatorColor = .clear
            UITableView.appearance().separatorStyle = .none
        }.onDisappear {
            UITableView.appearance().separatorStyle = .none
        }
    }
}

extension View {
    public func listSeparatorStyleNone() -> some View {
        modifier(ListSeparatorStyleNoneModifier())
    }
}
