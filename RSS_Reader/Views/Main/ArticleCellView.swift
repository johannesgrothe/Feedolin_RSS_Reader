//
//  ArticleCellView.swift
//  RSS_Reader
//
//  Created by Emircan Duman on 04.11.20.
//

import SwiftUI

/// View that represents a article cell
struct ArticleCellView: View {
    /// Model singleton
    @ObservedObject var model: Model = .shared
    /// articleData to be shown
    @ObservedObject var article: ArticleData
    /// State value that changes case if bookmarks value changes
    @State private var bookmarked: Bool = false
    /// State value that changes case if read value changes
    @State private var read: Bool = false
    /// active when click on it, to manually activate the NavigationLink
    @State private var is_active_link: Bool = false
    @State private var image_loaded: Bool = false
    
    var body: some View {
        // undelaying navigation link and on top the content in HStack
        ZStack {
            // hacky way to hide the navigation link arrow
            NavigationLink(destination: ArticleView(article: article), isActive: $is_active_link){
                EmptyView()
            }
            .opacity(0)
            .buttonStyle(PlainButtonStyle())
            // VStack with HStack on top and Description on bottom
            VStack(alignment: .leading, spacing: 10) {
                // HStack with text to the left and image to the right
                title_details
                    .layoutPriority(1)
                HStack(alignment: .top) {
                    Text(article.description)
                        .font(.caption)
                        .lineLimit(5)
                    Spacer()
                    article.image?.img
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(minWidth: 0, maxWidth: 130, minHeight: 0, maxHeight: 100, alignment: .center)
                        .clipped()
                        .cornerRadius(5)
                        .redacted(reason: image_loaded ? [] : .placeholder)
                }
                .onReceive(article.$image_loaded, perform: { value in
                    image_loaded = value
                })
            }
            .frame(maxHeight: 160, alignment: .top)
            .padding(.all, 10.0)
            .background(Color.article)
            .cornerRadius(10)
            .opacity(self.read ? 0.4 : 1)
        }
        .onTapGesture {
            self.is_active_link = true
        }
        .onAppear(perform: {
            self.bookmarked = article.bookmarked
            self.read = article.read
            self.is_active_link = false
        })
        .onChange(of: article.bookmarked) {value in
            self.bookmarked = value
            self.model.refreshFilter()
        }
        .onChange(of: article.read) {value in
            self.read = value
            self.model.refreshFilter()
        }
        .contextMenu {
            bookmark_button
            read_button
            share_button
        }
    }
    
    // MARK: Title and Details
    
    var title_details: some View {
        // article.title on top following by HStack and article.description
        VStack(alignment: .leading, spacing: 10){
            Text(article.title)
                .font(.subheadline)
                .bold()
                .lineLimit(3)
            // parent_feed indicators to the left than seperator and pubdate to the right
            HStack {
                if self.bookmarked{
                    CustomSystemImage(image: .bookmark, style: .nothing, size: .xxsmall)
                }
                Text("\(article.parent_feeds[0].parent_feed!.token) - \(article.parent_feeds[0].name)")
                    .font(.caption2)
                    .lineLimit(1)
                Text("|").font(.caption2)
                Text(article.timeAgoDateToString())
                    .font(.caption2)
                    .italic()
                    .lineLimit(1)
                
            }
        }
    }
    
    // MARK: Context-Menu Buttons
    
    var bookmark_button: some View {
        Button(action: {
            self.article.bookmarked.toggle()
        }, label: {
            if self.bookmarked {
                DefaultListEntryView(sys_image: CustomSystemImage(image: .unmark, size: .xsmall), text: "Unmark", font: .body)
            } else {
                DefaultListEntryView(sys_image: CustomSystemImage(image: .bookmark, size: .xsmall), text: "Bookmark", font: .body)
            }
        })
    }
    var read_button: some View {
        Button(action:{
            self.article.read.toggle()
        }, label: {
            if self.read {
                DefaultListEntryView(sys_image: CustomSystemImage(image: .close, size: .xsmall), text: "Unread", font: .body)
            } else {
                DefaultListEntryView(sys_image: CustomSystemImage(image: .check, size: .xsmall), text: "Read", font: .body)
            }
        })
    }
    var share_button: some View {
        Button(action:{
            self.setShare(article: article)
        }, label: {
            DefaultListEntryView(sys_image: CustomSystemImage(image: .share, style: .nothing, size: .xsmall), text: "Share", font: .body)
        })
    }
    
    
    /// Opens the Activity View to share a article link
    private func setShare(article: ArticleData){
        // URL instance to the article link
        let link = URL(string: article.link)
        // action_sheet with the link as activity item
        let action_sheet = UIActivityViewController(activityItems:[link!], applicationActivities: nil)
        // presenting the action_sheet
        UIApplication.shared.windows.first?.rootViewController?.present(action_sheet, animated: true, completion: nil)
        // support ipad sheet
        if UIDevice.current.userInterfaceIdiom == .pad {
            action_sheet.popoverPresentationController?.sourceView = UIApplication.shared.windows.first
            action_sheet.popoverPresentationController?.sourceRect = CGRect(
                x: UIScreen.main.bounds.width / 2.1,
                y: UIScreen.main.bounds.height / 2.3,
                width: 200,
                height: 200)
        }
    }
}

struct ArticleListRow_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            ArticleCellView(article: fake_data_preview.stored_article_data[0])
                .frame(width: 400, height: 200)
                .previewLayout(.sizeThatFits)
            ArticleCellView(article: fake_data_preview.stored_article_data[1])
                .frame(width: 400, height: 200)
                .previewLayout(.sizeThatFits)
            ArticleCellView(article: fake_data_preview.stored_article_data[2])
                .frame(width: 400, height: 200)
                .previewLayout(.sizeThatFits)
        }
    }
}
