//  ContentView.swift
//  SwiftUINotesAppClone
//  Created by Karl Jay on 9/27/21.
// SwiftUI - build a notes app clone Coding in a nutshell
// @ 8:20, converting folders to a separate file and using @ObservableObject
// second video uses UIkit to edit the notes
// SwiftUI interfacing with UIKit UIViewRepresentable
import SwiftUI

struct ContentView: View {

    @ObservedObject var myNotes: MyNotes
    @State var searchString: String = ""
    @State var newFolderName: String = ""
    @State var showingPopover: Bool = false
    
    var body: some View {
        ZStack {
            NavigationView {
                List {
                    TextField("Search", text: $searchString)
                    Section(header:
                                Text("On My iPhone")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.black)) {
                        if myNotes.folders.count > 0 {
                            FolderCell(name: "All on My iPhone")
                        }
                        FolderCell(name: "Notes")
                        ForEach (myNotes.folders) { folder in
                            FolderCell(name: folder.name)
                        }
                        .onDelete(perform: { IndexSet in
                            myNotes.folders.remove(atOffsets: IndexSet)
                        })
                    }
                    .textCase(nil)
                }
                .listStyle(InsetGroupedListStyle())
                .navigationTitle("Folders")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing)  {
                        EditButton()
                    }
                    ToolbarItemGroup(placement: .bottomBar)  {
                        Image(systemName: "folder.badge.plus")
                            .onTapGesture {
                                showingPopover.toggle()
                            }
                        Spacer()
                        HStack {
                            Text("") // bug fix? @5:39 2nd video
                            NavigationLink(destination: NoteView()) {
                                Image(systemName: "square.and.pencil")
                            }
                        }
                    }
                }
            }
            if showingPopover {
                //showingPopover = true
                CreateNewFolder($showingPopover, with: myNotes)
            }
        }
    }
}


struct FolderCell: View {
    var name: String
    var body: some View {
        NavigationLink(destination: FolderView(folderName: name)) {
            HStack {
                Image(systemName: "folder")
                Text(name)
            }
        }
    }
}


struct CreateNewFolder: View {
    @ObservedObject var myNotes: MyNotes
    @Binding var showingPopover: Bool
    @State var newFolderName = ""
    // @ 11:27
    init( _ showingPopover: Binding<Bool>, with myNotes: MyNotes) {
        self._showingPopover = showingPopover
        self.myNotes = myNotes
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                RoundedRectangle(cornerRadius: 7)
                    .fill(Color(.systemGray4))
                    .frame(width: geo.size.width * 0.70, height: geo.size.width * 0.40, alignment: .center)
                VStack {
                    Text("New Folder")
                        .font(.headline)
                    Text("Enter a name for this folder")
                        .font(.subheadline)
                    Spacer()
                    TextField("Name", text: $newFolderName)
                        .frame(width: 200, height: 10)
                        .padding()
                        .background(Color(.white))
                        .cornerRadius(7)
                    Spacer()
                    Color.gray.frame(width: 200, height: CGFloat(1))
                    HStack {
                        Button( action: { print("Cancel") } ){
                            Text("Cancel")
                                .frame(maxWidth: .infinity)
                        }
                        Button( action: {
                            myNotes.folders.append(Folder(name: newFolderName))
                            showingPopover.toggle()
                        }) {
                            Text("Save")
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                .frame(width: geo.size.width * 0.70, height: geo.size.width * 0.35)
                
            } // end GeometryReader
            .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let testNotes = MyNotes()
        //testNotes.folders = testFolders
        testNotes.folders = testFolders
        return ContentView(myNotes: testNotes)
    }
}
