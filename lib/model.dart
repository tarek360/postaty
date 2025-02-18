import 'package:flutter/material.dart';

// Instagram Post Model
class InstagramPost {
  final String title;
  final TextStyle titleStyle;
  final String content;
  final TextStyle contentStyle;
  final String unsplashPhotoKeyword;
  final Color overlayColor;
  final double overlayOpacity;
  final String logoUrl;
  final String? ctaText;
  final TextStyle? ctaStyle;
  final Color? ctaBackground;
  final double? ctaBorderRadius;
  final List<String> hashtags;
  final String engagementEmoji;

  InstagramPost({
    required this.title,
    required this.titleStyle,
    required this.content,
    required this.contentStyle,
    required this.unsplashPhotoKeyword,
    required this.overlayColor,
    required this.overlayOpacity,
    required this.logoUrl,
    required this.ctaText,
    required this.ctaStyle,
    required this.ctaBackground,
    required this.ctaBorderRadius,
    required this.hashtags,
    required this.engagementEmoji,
  });

  factory InstagramPost.fromJson(Map<String, dynamic> json) {
    return InstagramPost(
      title: json['title']['text'],
      titleStyle: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Color(int.parse(json['title']['color'].replaceFirst('#', '0xFF'))),
      ),
      content: json['content']['text'],
      contentStyle: TextStyle(
        fontSize: 16,
        color: Color(int.tryParse(json['content']['color'].replaceFirst('#', '0xFF'))?? 0xFFFFFFFF),
      ),
      overlayColor: Colors.black12,
      overlayOpacity: 0.3,
      logoUrl: 'https://picsum.photos/100/100',
      ctaText: json['cta']?['text'],
      ctaStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: json['cta'] == null ? Color(0xFFFFFFFF) : Color(int.parse(json['cta']['color'].replaceFirst('#', '0xFF'))),
      ),
      ctaBackground:
          json['cta'] == null ? null : Color(int.tryParse(json['cta']?['background']?.replaceFirst('#', '0xFF')) ?? 0xFF5733),
      ctaBorderRadius: json['cta']?['borderRadius']?.toDouble(),
      hashtags: List<String>.from(json['hashtags']),
      engagementEmoji: json['engagementEmoji'],
      unsplashPhotoKeyword: json['unsplashPhotoKeyword'],
    );
  }
}

const exampleJSON = {
  "title": {
    "text": "Exclusive Drop!",
    "color": "#FFFFFF",
    "position": {"x": "center", "y": "top", "offsetY": 50}
  },
  "content": {
    "text": "Limited Edition Sneakers Now Available",
    "color": "#F0F0F0",
    "position": {"x": "center", "y": "top", "offsetY": 120}
  },
  "background": {
    "type": "image",
    "url": "https://picsum.photos/600/600/?blur=2",
    "colorOverlay": "#000000",
    "opacity": 0.5
  },
  "logo": {
    "url": "https://picsum.photos/56/56",
    "size": {"width": 100, "height": 100},
    "position": {"x": "left", "y": "top", "offsetX": 20, "offsetY": 20}
  },
  "cta": {
    "text": "Shop Now",
    "color": "#FFFFFF",
    "background": "#FF5733",
    "borderRadius": 8,
    "padding": {"x": 20, "y": 10},
    "position": {"x": "center", "y": "bottom", "offsetY": 50}
  },
  "hashtags": ["#SneakerDrop", "#LimitedEdition", "#StreetStyle"],
  "engagementEmoji": "🔥",
  "unsplashPhotoKeyword": "sneakers"
};
