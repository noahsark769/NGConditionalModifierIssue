# NGConditionalModifierIssue
ButtonStyles which modify the view tree using ViewBuilder may not have their action activated when applied to Buttons

In Swift 5.2+, the `body` property of a custom view can be annotated with @ViewBuilder. Consider the following code which uses a custom view with a @ViewBuilder body:

```swift
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
```

When applied to a ButtonStyle like the following, the button's tap action ceases to work (clicking the button does not trigger the callback):

```swift
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
```

Platforms: Tested on macOS 10.15.5, Xcode 12 beta 3

Steps to reproduce:

1. Clone the project at https://github.com/noahsark769/NGConditionalModifierIssue
2. Open the project
3. Run the NGConditionalModifierIssue target
4. Tap on the "Hello" button text

Expected: "Hello" is printed to the console

Actual: Nothing is printed

Note: Removing the @ViewBuilder annotation from the body, wrapping the body return views in AnyView, or returning a Group with both views nested doesn't seem to have any effect

Note: This issue doesn't seem to happen on iOS (tested on the 14.0 simulator). The NGConditionalModifierIssue-iOS target demonstrates an iOS app with the same content view.
