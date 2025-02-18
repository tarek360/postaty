import 'package:flutter/material.dart';

import 'model.dart';

// Flutter Widget to Render the Instagram Post
class InstagramPostWidget extends StatefulWidget {
  const InstagramPostWidget({
    super.key,
    required this.post,
    required this.photos,
  });

  final InstagramPost post;
  final List<String> photos;

  @override
  State<InstagramPostWidget> createState() => _InstagramPostWidgetState();
}

class _InstagramPostWidgetState extends State<InstagramPostWidget> {
  String _selectedPhoto = '';

  @override
  void initState() {
    super.initState();
    if (widget.photos.isNotEmpty) {
      _selectedPhoto = widget.photos.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 600,
          height: 600,
          child: Stack(
            children: [
              // Background Image with Overlay
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      Image.network(
                        _selectedPhoto,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      Container(color: Color(0xBA000000))
                    ],
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo
                    Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: Image.network(
                              // 'https://ca.slack-edge.com/T03287R3C-U5697F4EL-4d1c242c554a-512',
                              'https://ca.slack-edge.com/T03287R3C-U07MGNR7P3L-2cd3945c0e7e-512',
                              width: 40,
                              height: 40,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Tarek',
                            style: TextStyle(color: Colors.white70, fontSize: 20),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Title
                    Text(
                      widget.post.title,
                      style: widget.post.titleStyle.copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 10),

                    // Subtitle
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Text(
                        widget.post.content,
                        style: widget.post.contentStyle.copyWith(color: Colors.white70),
                        textAlign: TextAlign.start,
                      ),
                    ),

                    const Spacer(),

                    // CTA Button
                    if (widget.post.ctaBackground != null &&
                        widget.post.ctaBorderRadius != null &&
                        widget.post.ctaText != null &&
                        widget.post.ctaBackground != null)
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.post.ctaBackground,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(widget.post.ctaBorderRadius!),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Text(widget.post.ctaText!, style: widget.post.ctaStyle),
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Hashtags
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: widget.post.hashtags
                          .map((tag) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(
                                  tag,
                                  style: TextStyle(color: Colors.white70, fontSize: 16),
                                ),
                              ))
                          .toList(),
                    ),

                    const SizedBox(height: 10),

                    // Engagement Emojis
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Text(
                            widget.post.engagementEmoji,
                            style: const TextStyle(fontSize: 24),
                          ),
                        )
                      ],
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        BackgroundPhotoSelector(
          photos: widget.photos,
          selectedPhotoIndex: widget.photos.indexOf(_selectedPhoto),
          onPhotoSelected: (photo) {
            setState(() {
              _selectedPhoto = photo;
            });
          },
        ),
      ],
    );
  }
}

// background photo selector, horizontal list of photos
class BackgroundPhotoSelector extends StatefulWidget {
  const BackgroundPhotoSelector({
    super.key,
    required this.photos,
    required this.selectedPhotoIndex,
    required this.onPhotoSelected,
  });

  final List<String> photos;
  final int selectedPhotoIndex;
  final ValueChanged<String> onPhotoSelected;

  @override
  State<BackgroundPhotoSelector> createState() => _BackgroundPhotoSelectorState();
}

class _BackgroundPhotoSelectorState extends State<BackgroundPhotoSelector> {
  int _selectedPhotoIndex = 0;

  @override
  void initState() {
    super.initState();
    autoChangePhoto();
  }

  void autoChangePhoto() {
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        _selectedPhotoIndex = (_selectedPhotoIndex + 1) % widget.photos.length;
      });
      autoChangePhoto();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < widget.photos.length; i++)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => widget.onPhotoSelected(widget.photos[i]),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: i == widget.selectedPhotoIndex ? Colors.black54 : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.photos[i],
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
