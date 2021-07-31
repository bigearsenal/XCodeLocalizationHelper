//
//  SelectLanguageView.swift
//  LocalizationHelper
//
//  Created by Chung Tran on 25/07/2021.
//

import SwiftUI

struct SelectLanguageView: View {
    @State var languages: [ISOLanguageCode]
    @Binding var isShowing: Bool
    let canSelectMultipleLanguages: Bool
    let completion: ([ISOLanguageCode]) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            listView
            Button("Done") {
                doneButtonDidTouch()
            }
                .disabled(languages.filter {$0.isSelected}.count > 0)
                .padding()
        }
    }
    
    private var headerView: some View {
        HStack {
            Spacer()
            Text("Select language").font(.title2)
            Spacer()
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .onTapGesture {
                    isShowing.toggle()
                }
                .frame(width: 20, height: 20)
                
        }
        .padding()
    }
    
    private var listView: some View {
        List{
            ForEach(0..<languages.count){ index in
                HStack {
                    Button(action: {
                        if !canSelectMultipleLanguages {
                            for i in 0..<languages.count where languages[i].isSelected == true
                            {
                                languages[i].isSelected = false
                            }
                        }
                        languages[index].isSelected.toggle()
                    }, label: {
                        HStack {
                            if languages[index].isSelected {
                                Text("✓")
                                    .animation(.easeIn)
                            } else {
                                Text(" ")
                                    .animation(.easeOut)
                            }
                            Text("[\(languages[index].code)] " + languages[index].name)
                        }
                    })
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
        }
    }
    
    // MARK: - Actions
    private func doneButtonDidTouch() {
        completion(languages.filter {$0.isSelected})
        isShowing = false
    }
}

struct SelectLanguageView_Previews: PreviewProvider {
    static var previews: some View {
        SelectLanguageView(
            languages: ISOLanguageCode.all,
            isShowing: .constant(true),
            canSelectMultipleLanguages: false)
        { languages in
            // do nothing
        }
    }
}
