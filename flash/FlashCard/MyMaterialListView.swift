//
//  MyMaterialListView.swift
//  flash
//
//  Created by Songwut Maneefun on 21/9/2564 BE.
//

import SwiftUI

struct MyMaterialListView: View {
    @ObservedObject var viewModel = MyMaterialListViewModel()
    
    var myMaterialFlash: MaterialFlashPageResult
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                VStack(alignment: .leading, spacing: nil, content: {
                    let items = myMaterialFlash.list
                    let count =  items.count
                    let total = "total".localized()
                    let totalText =  count.textNumber(many: "learning_material".localized())
                    Text("\(total) \(totalText)")
                        .frame(height: 40)
                        .foregroundColor(UIColor.text75().color)
                        .font(FontHelper.getFontSystem(.l, font: .text).font)
                })
                .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
                
                CreateView
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
                
                let items = myMaterialFlash.list
                ForEach(items) { item in
                    ZStack {
                        FLMaterialView(isEditor: true, flash: item)
                            .background(Color.white)
                            .onAppear {
                                if items.isLastItem(item) {
                                    //TODO: fix pagination
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                        viewModel.callAPIMyFlashCard(next: myMaterialFlash.next)
                                    }
                                }
                            }
                        NavigationLink(destination: FLFlashEditorView(flashId:item.id)) {
                            Rectangle()
                        }
                        .buttonStyle(PlainButtonStyle())
                        .opacity(0.0)
                    }
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
                    .frame(width: .infinity, height: FlashStyle.flashItemHeight)
                }
            }
            
            if viewModel.isListFull == false {
                //ActivityIndicator(isAnimating: $viewModel.isLoading)
                ActivityIndicator(isAnimating: .constant(viewModel.isLoading))
//                    .onAppear {
//                        viewModel.callAPIMyFlashCard(next: myMaterialFlash.next)
//                    }
            }
        }
        //.listStyle(SidebarListStyle()) //ios 14
        .padding(.leading, 16)
        .padding(.trailing, 16)
        .background(Color.clear)
        .navigationBarTitle("My Material", displayMode: .automatic)
        .onAppear(perform: {
            viewModel.next = myMaterialFlash.next
            viewModel.previous = myMaterialFlash.previous
            viewModel.pageSize = myMaterialFlash.pageSize
        })
        
    }
    
    var CreateView: some View {
        VStack(alignment: .leading, spacing: nil, content: {
            ZStack {
                //TODO: change image cover waiting Desige export
                let createList = [
                    FLCreateItem(coverName: "flash-create-cover", title: "Flash Card", isReady: true),
                    FLCreateItem(coverName: "flash-create-cover", title: "Flash Card", isReady: true),FLCreateItem(coverName: "flash-create-cover", title: "Flash Card", isReady: true),
                    FLCreateItem(coverName: "flash-create-cover", title: "Flash Card", isReady: true)
                ]
                FLCreateMaterialView()
                    .frame(height: 122)
                    .padding(.bottom, 8)
                NavigationLink(destination: FLCreateMaterialListView(list: createList)) {
                    Rectangle()
                }
                .buttonStyle(PlainButtonStyle())
                .opacity(0.0)
            }
        })
    }
    
    var listView: some View {
        VStack(alignment: .leading, spacing: 8, content: {
            
        })
    }
}

struct MyMaterialListView_Previews: PreviewProvider {
    
    static var previews: some View {
        MyMaterialListView(myMaterialFlash: MockObject.myMaterialFlash)
    }
}
