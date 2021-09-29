//  NoteView.swift
//  NoteView
//  Created by Karl Jay on 9/28/21.
import SwiftUI

struct NoteView: View {
    @State var title = ""
    @State var noteText = "-Lorem ipsum dolor sit amet-, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut -labore et dolore- magnaaliqua.\r #bThis sentence will be in bold#b\r #iThis will be in Italics#i\r #uThis will be underlined#u"
    
    
    
    var body: some View {
        //TextEditor(text: $noteText)
        TextView(text: $noteText)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        print("Done")
                    }
                }
            }
    }
}

// @ 6:58 use typealias UIViewType = UITextView to get the protocol error that will fill in the funcs for you.

struct TextView: UIViewRepresentable {
    @Binding var text: String
    
    let textStorage = NSTextStorage()
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let attrs =
        [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
        let attrString = NSAttributedString(string: text, attributes: attrs)
        textStorage.append(attrString)
        
        let layoutManager = NSLayoutManager()
        let container = NSTextContainer(size: CGSize())
        container.widthTracksTextView = true
        layoutManager.addTextContainer(container)
        textStorage.addLayoutManager(layoutManager)
        
        let textView = UITextView(frame: CGRect(), textContainer: container)
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        context.coordinator.updateAttributedString()
        //uiView.attributedText = context.coordinator.updateAttributedString()
    }

    
    class Coordinator: NSObject {
        var parent: TextView
        
        var replacements: [String: [NSAttributedString.Key:Any]] = [:]
        
        init(_ textView: TextView) {
            self.parent = textView
            super.init()
            let strikeThroughAttributes = [NSAttributedString.Key.strikethroughStyle: 1]
            let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body)
            var descriptorWithTrait = fontDescriptor.withSymbolicTraits(.traitBold)
            
            var font = UIFont(descriptor: descriptorWithTrait!, size: 0)
            let boldAttributes = [NSAttributedString.Key.font:font]
            
            descriptorWithTrait = fontDescriptor.withSymbolicTraits(.traitBold)
            
            font = UIFont(descriptor: descriptorWithTrait!, size: 0)
            
            let italicAttributes = [ NSAttributedString.Key.font:font]
            let underlineAttributes = [NSAttributedString.Key.underlineStyle: 1]
            //boldAttributes = [NSAttributedString.Key.font:font]
            
            replacements = ["(-\\w+(\\s\\w+)*-)":strikeThroughAttributes,
                            "(#b\\w+(\\s\\w+)*#b)":strikeThroughAttributes,
                            "(#u\\w+(\\s\\w+)*#u)":strikeThroughAttributes,
                            "(#i\\w+(\\s\\w+)*#i)":strikeThroughAttributes]
        }
        
        //@7:58 3rd video
        func updateAttributedString() {
            for (pattern, attributes) in replacements {
                do {
                    let regex = try NSRegularExpression(pattern: pattern)
                    
                    let range = NSRange(parent.text.startIndex..., in: parent.text)
                    regex.enumerateMatches(in: parent.text, range: range){
                        match, flags, stop in
                        
                        if let matchRange = match?.range(at: 1) {
                            print("matched \(pattern)")
                            parent.textStorage.addAttributes(attributes, range: matchRange)
                        }
                    }
                } catch {
                    print("error occurred")
                }
            }
        }
        
//        func updateAttributedString() -> NSAttributedString {
//            // single attribute version
//            //let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .largeTitle)]
//            // several attribute version using an array
//            let attrs:[NSAttributedString.Key : Any] =
//            [NSAttributedString.Key.font:UIFont.preferredFont(forTextStyle: .largeTitle), NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
//                NSAttributedString.Key.strikethroughColor: UIColor.red]
//            let attrString = NSAttributedString(string: parent.text, attributes: attrs)
//            return attrString
//        }
    }
    
    typealias UIViewType = UITextView
    
}

struct NoteView_Previews: PreviewProvider {
    static var previews: some View {
        NoteView()
    }
}
