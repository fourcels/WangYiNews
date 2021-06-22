//
//  ItemView.swift
//  WangYiNews
//
//  Created by Kiyan Gauss on 6/22/21.
//

import SwiftUI
import URLImage

struct ItemView: View {
    let item: Item
    var body: some View {
        HStack(alignment:.top) {
            URLImage(URL(string: item.image)!) { image in
                image.scaledToFit()
            }
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.headline)
                    .lineLimit(2)
                Spacer()
                HStack {
                    Text(item.passtime)
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                }
                    
            }
            
            
        }
        .frame(height: 88)
    }
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView(item: Item(
            path: "https://www.163.com/dy/article/G1OBC8LO0514BCL4.html",
            image: "http://dingyue.ws.126.net/2021/0201/b63f2e50j00qntwfh0020c000hs00npg.jpg?imageView&thumbnail=140y88&quality=85",
            title: "被指偷拿半卷卫生纸 63岁女洗碗工服药自杀 酒店回应",
            passtime: "2021-02-02 10:00:51"
        ))
    }
}
