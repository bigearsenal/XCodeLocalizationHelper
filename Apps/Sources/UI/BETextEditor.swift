//
//  BETextEditor.swift
//  LocalizationHelper
//
//  Created by Chung Tran on 02/08/2021.
//

import SwiftUI

private struct ViewHeightKey: PreferenceKey {
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout CGFloat, nextValue: () -> Value) {
        value += nextValue()
    }
}

struct BETextEditor: View {
    let placeholder: String
    let lineLimit: Int
    
    @State fileprivate var height: CGFloat = .zero
    @Binding var text: String
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .frame(maxHeight: height)
                // following line is a hack to force TextEditor to appear
                //  similar to .textFieldStyle(RoundedBorderTextFieldStyle())...
                .cornerRadius(6.0)
                .foregroundColor(Color(.labelColor))
                .multilineTextAlignment(.leading)
            Text(text.isEmpty ? placeholder: text)
                .lineLimit(lineLimit)
                // following line is a hack to create an inset similar to the TextEditor inset...
                .padding(.leading, 4)
                .foregroundColor(Color(.placeholderTextColor))
                .opacity(text.isEmpty ? 1 : 0)
                .background(GeometryReader {
                    Color.clear.preference(key: ViewHeightKey.self, value: $0.frame(in: .local).height)
                })
                .allowsHitTesting(false)
        }
            .font(.body)
            .onPreferenceChange(ViewHeightKey.self) {
                height = $0
            }
    }
}

#if DEBUG
struct BETextEditor_Previews: PreviewProvider {
    static var previews: some View {
        BETextEditor(placeholder: "Enter text", lineLimit: 3, text: .constant("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum"))
            .previewLayout(.fixed(width: 500, height: 500))
    }
}
#endif
