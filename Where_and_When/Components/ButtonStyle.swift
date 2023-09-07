import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    var width: CGFloat
    var color: Color = Color(hex:"#ffcda6")
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: width, height: 10)
            .padding()
            .background(color)
            .foregroundStyle(.black)
            .clipShape(Capsule())

    }
}
