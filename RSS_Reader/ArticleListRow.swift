//
//  ArticleListRow.swift
//  RSS_Reader
//
//  Created by Emircan Duman on 04.11.20.
//

import SwiftUI

/**
 View that represents a article cell
 */
struct ArticleListRow: View {
    
    /**Model singleton*/
    @ObservedObject var model: Model = .shared
    
    /**article*/
    @ObservedObject var article: ArticleData
    
    /**State value that changes case if bookmarks value changes*/
    @State private var bookmarked: Bool = false
    
    /**State value that changes case if read value changes*/
    @State private var read: Bool = false
    
    var body: some View {
        // undelaying navigation link and on top the content in HStack
        ZStack {
            // hacky way to hide the navigation link arrow
            NavigationLink(destination: ArticleView(article: article)){
                EmptyView()
            }
            .opacity(0)
            .buttonStyle(PlainButtonStyle())
            
            // VStack with text to the left and image to the right
            HStack {
                
                // article.title on top following by HStack and article.description
                VStack(alignment: .leading, spacing: 8.0){
                    HStack{
                        Text(article.title)
                            .font(.subheadline)
                            .bold()
                            .lineLimit(4)
                            .layoutPriority(1)
                    }
                    // parent_feed indicators to the left than seperator and pubdate to the right
                    HStack {
                        if self.bookmarked{
                            Image(systemName: "bookmark.fill").resizable()
                                .frame(width:5, height: 7)
                        }
                        Text("\(article.parent_feeds[0].parent_feed!.token) - \(article.parent_feeds[0].name)")
                            .font(.caption2)
                            .lineLimit(1)
                        Text("|").font(.caption2)
                        Text(article.time_ago_date_to_string())
                            .font(.caption2)
                            .italic()
                            .lineLimit(1)
                        
                    }
                    
                    Text(article.description)
                        .font(.caption)
                        .lineLimit(4)
                }
                
                Spacer()
                
                article.image?
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 110, maxHeight: 180, alignment: .center)
                
            }
            .frame(minHeight: 0, maxHeight: 200)
            .padding(.all, 10.0)
            .background(Color(UIColor(named: "ArticleColor")!))
            .cornerRadius(10)
            .foregroundColor(self.read ? .gray: .black)
        }
        .onAppear(perform: {
            self.bookmarked = article.bookmarked
            self.read = article.read
        })
        .onChange(of: article.bookmarked){value in
            self.bookmarked = value
            self.model.refreshFilter()
        }
        .onChange(of: article.read){value in
            self.read = value
            self.model.refreshFilter()
        }
        .contextMenu{
            Button(action: {
                self.setBookmarked(article: article)
                print("Button Bookmark/Unmark pressed")
            }) {
                HStack{
                    if self.bookmarked{
                        Text("Unmark")
                        Image(systemName: "bookmark.slash")
                    }
                    Text("Bookmark")
                    Image(systemName: "bookmark")
                }
            }
            
            Button(action:{
                self.setMarkAsRead(article: article)
                print("MarkAsRead pressed")
            }) {
                HStack{
                    if self.read{
                        Text("Unread")
                        Image(systemName: "checkmark.square.fill")
                    }
                    Text("Read")
                    Image(systemName: "checkmark.square")
                }
            }
            
            Button(action:{
                print("Share pressed")
            }){
                HStack{
                    Text("Share")
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }
    
    /**Toggles the boolean bookmarked of an Instance of Article*/
    private func setBookmarked(article: ArticleData) {
        self.article.bookmarked.toggle()
    }
    
    /**Still to be written*/
    private func setShare(article: ArticleData){
        /**Empty*/
    }
    
    /**Still to be written*/
    private func setMarkAsRead(article: ArticleData){
        self.article.read.toggle()
    }
    
    struct ArticleListRow_Previews: PreviewProvider {
        
        @ObservedObject var model: Model = .shared
        
        static var previews: some View {
            ArticleListRow(article: preview_model.stored_article_data[0])
        }
    }
}
