//
//  FLCreateMaterialListView.swift
//  flash
//
//  Created by Songwut Maneefun on 22/9/2564 BE.
//

import SwiftUI
import Combine

class FLCreateMaterialListViewModel: ObservableObject {
    @Published var list = [LMCreateItem]()
    var isLoaded = false
    
    func callAPILearningCoverList() {
        let viewModel = FLFlashCardViewModel()
        viewModel.callAPILearningCoverList { (listResult: [LMCreateItem]?) in
            if var list = listResult {
                self.isLoaded = true
                self.list = list
            }
            
        }
        
    }
}

struct FLCreateMaterialListView: View {
    @ObservedObject var viewModel: FLCreateMaterialListViewModel
    
    private let column = UIDevice.isIpad() ? 3 : 2
    private let margin: CGFloat = 16
    
    var body: some View {
        VStack(alignment: .center, content: {
            if viewModel.isLoaded {
                ContentView
            }
        })
        .onAppear(perform: {
            viewModel.callAPILearningCoverList()
        })
    }
    
    var ContentView: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: true, content: {
                
                let superW = geometry.frame(in: .global).width
                let hWidth = superW - (margin * CGFloat(column))
                let cellWidth = CGFloat(hWidth / CGFloat(column))
                let cellHeight = CGFloat(cellWidth * (200 / 164))
                
                let list = viewModel.list
                let row = Float(list.count / column)
                VStack(alignment: .center, spacing: nil, content: {
                    ForEach(0..<Int(row.rounded(.up))) { rowIndex in
                        VStack(alignment: .leading, spacing: 0, content: {
                            HStack(alignment: .top, spacing: margin, content: {
                                ForEach(0..<column) { columnIndex in
                                    let index = (rowIndex * self.column) + columnIndex
                                    let item = list[index]
                                    if item.isReady {
                                        NavigationLink(destination: FLFlashEditorView()) {
                                            NewMaterialView(item: item)
                                                .frame(maxWidth: cellWidth, maxHeight: cellHeight)
                                                .cornerRadius(8)
                                        }
                                    } else {
                                        NewMaterialView(item: item)
                                            .frame(maxWidth: cellWidth, maxHeight: cellHeight)
                                            .cornerRadius(8)
                                    }
                                }
                            })
                            .frame(maxWidth: .infinity, maxHeight: cellHeight)
                        })
                        .frame(height: cellHeight)
                        .padding([.bottom], margin / 2)
                    }
                })
                .padding(.all, margin)
            })
            .background(Color.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
    
}

struct FLCreateMaterialListView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = FLCreateMaterialListViewModel()
        FLCreateMaterialListView(viewModel: vm)
    }
}
