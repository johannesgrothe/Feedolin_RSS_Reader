//
//  FakeDataForPreview.swift
//  RSS_Reader
//
//  Created by Kenanja Nuding on 5/1/21.
//

import Foundation

var fake_data_preview = Model(
    article_data: [
        ArticleData(article_id: "https://www.spiegel.de/politik/deutschland/peter-michael-diestel-die-cdu-hat-einen-tragischen-weg-vor-sich-a-e0e08773-6285-4b92-b9bc-9a8bfb2b6b40",
                    title: "Peter-Michael Diestel:»Die CDU hat einen tragischen Weg vor sich«",
                    description: "Er war der letzte Innenminister der DDR, nach der Wende wurde er CDU-Mitglied. Jetzt verlässt Peter-Michael Diestel die Partei und sagt: Für die Union habe er sich zuletzt geschämt.",
                    link: "https://www.spiegel.de/politik/deutschland/peter-michael-diestel-die-cdu-hat-einen-tragischen-weg-vor-sich-a-e0e08773-6285-4b92-b9bc-9a8bfb2b6b40#ref=rss",
                    pub_date: Date(timeIntervalSinceReferenceDate: 640822164.0),
                    thumbnail_url: "https://cdn.prod.www.spiegel.de/images/07da45b7-6696-4d73-959e-20fa1245c40b_w520_r2.08_fpx47.34_fpy45.jpg",
                    parent_feeds: [NewsFeed(url: "https://www.spiegel.de/politik/index.rss",
                                            name: "DER SPIEGEL - Politik",
                                            show_in_main: true,
                                            use_filters: false,
                                            parent_feed: NewsFeedProvider(url: "spiegel.de",
                                                                          name: "spiegel.de",
                                                                          token: "spiegel.de",
                                                                          icon_url: "",
                                                                          feeds: []))]),
        ArticleData(article_id: "https://www.nzz.ch/technologie/eine-dezentrale-app-statt-big-brother-ohne-die-kontrolle-der-behoerden-koennte-das-contact-tracing-besser-funktionieren-ld.1614550",
                    title: "KOMMENTAR - Eine dezentrale App statt Big Brother: Ohne die Kontrolle der Behörden könnte das Contact-Tracing besser funktionieren",
                    description: "Wer in ein Restaurant geht, muss für das Contact-Tracing seine Kontaktdaten angeben. Doch viele halten sich nicht daran. Statt die Illusion einer umfassenden Kontrolle aufrechtzuerhalten, sollte der Staat auf Eigenverantwortung und eine neue App setzen.",
                    link: "https://www.nzz.ch/technologie/eine-dezentrale-app-statt-big-brother-ohne-die-kontrolle-der-behoerden-koennte-das-contact-tracing-besser-funktionieren-ld.1614550",
                    pub_date: Date(timeIntervalSinceReferenceDate: 641446200.0),
                    thumbnail_url: "https://img.nzz.ch/C=W792,H792,X2072,Y740/S=W200M,H200M/O=75/https://nzz-img.s3.amazonaws.com/2021/4/29/0e133801-ef4b-47cb-8d41-0bee91b143e4.jpeg",
                    parent_feeds: [NewsFeed(url: "https://www.nzz.ch/technologie.rss",
                                            name: "Technologie – News, Hintergründe & Kommentare | NZZ",
                                            show_in_main: true,
                                            use_filters: false,
                                            parent_feed: NewsFeedProvider(url: "nzz.ch",
                                                                          name: "nzz.ch",
                                                                          token: "nzz.ch",
                                                                          icon_url: "",
                                                                          feeds: []))]),
        ArticleData(article_id: "https://www.chip.de/test/Panasonic-Lumix-DC-G110-im-Test_183588914.html",
                    title: "Panasonic Lumix DC-G110 im Test",
                    description: "Die Panasonic Lumix G110 hat sich im CHIP Test als äußerst flexible Vlogging-Kamera bewiesen. Sie trumpft vor allem durch durchdachte Video-Features auf, überzeugt aber auch durch gute Bildqualität und Ausstattung. Garniert mit jeder Menge Liebe zum praktischen Detail erfüllt die kompakte und leichte DSLM alle an sie gestellten Aufgaben. Auch der günstige Preis spricht für die Lumix G110. Einen zweiten Ersatzakku oder zumindest eine geladene Powerbank sollte man dennoch immer im Gepäck haben.",
                    link: "https://www.nzz.ch/technologie/eine-dezentrale-app-statt-big-brother-ohne-die-kontrolle-der-behoerden-koennte-das-contact-tracing-besser-funktionieren-ld.1614550",
                    pub_date: Date(timeIntervalSinceReferenceDate: 641477640.0),
                    thumbnail_url: nil,
                    parent_feeds: [NewsFeed(url: "https://www.chip.de/rss/chip_komplett.xml",
                                            name: "CHIP",
                                            show_in_main: true,
                                            use_filters: false,
                                            parent_feed: NewsFeedProvider(url: "chip.de",
                                                                          name: "chip.de",
                                                                          token: "chip.de",
                                                                          icon_url: "",
                                                                          feeds: []))]),
    ])
