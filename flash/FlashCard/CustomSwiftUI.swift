//
//  CustomSwiftUI.swift
//  flash
//
//  Created by Songwut Maneefun on 10/9/2564 BE.
//

import SwiftUI

struct CustomSwiftUI: View {
    var body: some View {
        VStack(spacing: 16) {
            Button("Button 1") {}
            
            Button("Button 2") {}
                .buttonStyle(ButtonFill(color: .red))
            
            Button("Button 3") {}
                .frame(width: 300, height: 42, alignment: .center)
                .buttonStyle(ButtonBorder(color: .red))
            
            Button(action: {
                
            }, label: {
                Image("ic_v2_check")
                    .resizable()
                    .frame(width: 18, height: 18, alignment: .center)
                
            })
            .buttonStyle(ButtonBorder(color: UIColor.config_primary().color, cornerRadius: 4))
            
            VStack(content: {
                Text("Placeholder")
                
                Button(action: {
                    
                }, label: {
                    Image("ic_v2_check")
                        .resizable()
                        .padding(.all, 2)
                        .frame(width: 18, height: 18, alignment: .center)
                    
                })
                .buttonStyle(ButtonCheckBox(isChecked: true))
                
                
                Button(action: {
                    
                }, label: {
                    Image("ic_v2_check")
                        .resizable()
                        .padding(.all, 2)
                        .frame(width: 18, height: 18, alignment: .center)
                    
                })
                .buttonStyle(ButtonCheckBox(isChecked: false))
            }).background(Color.gray.opacity(0.3))
            
        }
    }
}

struct ButtonFill: ButtonStyle {
    var color: Color
    var textColor: Color = .white
    
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .foregroundColor(configuration.isPressed ? .gray : textColor)
            .padding()
            .background(
                RoundedRectangle(
                    cornerRadius: 8,
                    style: .circular
                )
                .fill(color)
            )
    }
}

struct ButtonBorder: ButtonStyle {
    var color: Color
    var cornerRadius: CGFloat?
    
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .foregroundColor(configuration.isPressed ? .gray : color)
            .background(
                RoundedRectangle(
                    cornerRadius: cornerRadius ?? 8,
                    style: .continuous
                ).stroke(color)
            )
    }
}

struct ButtonCheckBox: ButtonStyle {
    
    var isChecked: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .padding(.all, 2)
            .foregroundColor(isChecked ? .white : . clear)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(isChecked ? .clear : Color("A9A9A9"), lineWidth: 1)
            )
            .background(
                RoundedRectangle(
                    cornerRadius: 4,
                    style: .continuous
                )
                .fill(isChecked ? UIColor.config_primary().color : Color.white)
            )
    }
}

struct ButtonGradient: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(15.0)
    }
}

struct CustomSwiftUI_Previews: PreviewProvider {
    static var previews: some View {
        CustomSwiftUI()
            .previewLayout(.fixed(width: 300.0, height: 500))
            .environment(\.sizeCategory, .small)
    }
}
