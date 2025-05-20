import SwiftUI
import AppKit

struct ContentView: View {
    @State private var inputText = ""
    @State private var outputText = ""
    @State private var copyStatus = ""
    @State private var showSettings = false
    @State private var windowOpacity: Double = 0.85
    @State private var windowColor: Color = Color.blue.opacity(0.2)

    let hebrewToEnglish: [Character: Character] = [
        "ק": "e", "ר": "r", "א": "t", "ט": "y", "ו": "u", "ן": "i", "ם": "o", "פ": "p",
        "ש": "a", "ד": "s", "ג": "d", "כ": "f", "ע": "g", "י": "h", "ח": "j", "ל": "k",
        "ך": "l", "ף": ";", "ז": "z", "ס": "x", "ב": "c", "ה": "v", "נ": "b", "מ": "n",
        "צ": "m", "ת": ",", "ץ": ".", "׳": "w", "/": "q", "'": "w"
    ]

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VisualEffectBlur(material: .hudWindow, blendingMode: .behindWindow)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Hebrew Gibberish Fixer")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top)

                TextField("Paste gibberish (e.g. אקדא or ׳ישא?)", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .padding(.top, 10)

                HStack(spacing: 15) {
                    Button("Convert") {
                        outputText = String(inputText.map { hebrewToEnglish[$0] ?? $0 })
                        copyStatus = ""
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Copy Output") {
                        let pasteboard = NSPasteboard.general
                        pasteboard.clearContents()
                        pasteboard.setString(outputText, forType: .string)
                        copyStatus = "Copied!"
                    }
                    .disabled(outputText.isEmpty)
                    .buttonStyle(.bordered)
                }

                Text("Output: \(outputText)")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .padding()

                if !copyStatus.isEmpty {
                    Text(copyStatus)
                        .font(.caption)
                        .foregroundColor(.green)
                }

                Spacer()
            }
            .padding()
            .frame(width: 500, height: 340)
            .background(windowColor.opacity(windowOpacity))
            .cornerRadius(25)
            .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
            .padding()

            Button(action: {
                showSettings.toggle()
            }) {
                Image(systemName: "gearshape")
                    .imageScale(.large)
                    .foregroundColor(.white)
                    .padding(12)
            }
            .popover(isPresented: $showSettings) {
                VStack(alignment: .leading, spacing: 15) {
                    Text("Settings")
                        .font(.headline)

                    HStack {
                        Text("Transparency")
                        Slider(value: $windowOpacity, in: 0.3...1.0)
                    }

                    ColorPicker("Window Tint", selection: $windowColor)

                    Spacer()
                }
                .padding()
                .frame(width: 250, height: 150)
            }
        }
    }
}

struct VisualEffectBlur: NSViewRepresentable {
    var material: NSVisualEffectView.Material
    var blendingMode: NSVisualEffectView.BlendingMode

    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        view.isEmphasized = true
        view.wantsLayer = true
        view.layer?.cornerRadius = 25
        view.layer?.masksToBounds = true
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
