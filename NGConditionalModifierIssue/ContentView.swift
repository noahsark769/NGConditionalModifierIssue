//
//  ContentView.swift
//  NGConditionalModifierTreeHoverIssue
//
//  Created by Noah Gilmore on 7/28/20.
//

import SwiftUI

struct ConditionalContent<TrueContent: View, FalseContent: View>: View {
    let value: Bool
    let trueContent: () -> TrueContent
    let falseContent: () -> FalseContent

    @ViewBuilder var body: some View {
        if value {
            trueContent()
        } else {
            falseContent()
        }
    }
}

extension View {
    func conditionally<TrueContent: View>(
        _ value: Bool,
        content: @escaping (Self) -> TrueContent
    ) -> ConditionalContent<TrueContent, Self> {
        return ConditionalContent(
            value: value,
            trueContent: { content(self) },
            falseContent: { self }
        )
    }
}

struct MyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .conditionally(configuration.isPressed) { view in
                view.background(Color.blue)
            }
            .padding()
    }
}

struct ContentView: View {
    var body: some View {
        Button("Hello") {
            print("Hello")
        }.buttonStyle(MyButtonStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
