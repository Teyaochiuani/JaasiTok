import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class HomeCard extends StatefulWidget {
  final String profileImageURL;
  final String nickname;
  final String postId;
  final String mediaUrl;
  final String des;
  final bool isVideo;
  final int likesCount;
  final bool isLiked;

  const HomeCard({
    Key? key,
    required this.profileImageURL,
    required this.nickname,
    required this.postId,
    required this.mediaUrl,
    required this.des,
    required this.isVideo,
    required this.likesCount,
    required this.isLiked,
  }) : super(key: key);

  @override
  _HomeCardState createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {
  late VideoPlayerController? _videoController;
  late bool isLiked;
  late int likesCount;
  bool showComments = false;

  @override
  void initState() {
    super.initState();
    isLiked = widget.isLiked;
    likesCount = widget.likesCount;

    if (widget.isVideo) {
      _videoController = VideoPlayerController.network(widget.mediaUrl)
        ..initialize().then((_) {
          setState(() {});
        });
    } else {
      _videoController = null;
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _toggleLike() async {
    final postRef = FirebaseFirestore.instance.collection('posts').doc(widget.postId);
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId == null) return;

    if (isLiked) {
      await postRef.update({
        'likes.$currentUserId': FieldValue.delete(),
        'likesCount': FieldValue.increment(-1),
      });
    } else {
      await postRef.update({
        'likes.$currentUserId': true,
        'likesCount': FieldValue.increment(1),
      });
    }

    setState(() {
      isLiked = !isLiked;
      likesCount += isLiked ? 1 : -1;
    });
  }

  Widget _buildCommentsOverlay() {
  return Positioned.fill(
    child: GestureDetector(
      onTap: () {
        setState(() {
          showComments = false;
        });
      },
      child: Container(
        color: Colors.transparent, // No difumines todo el fondo
        child: Center(
          child: Container(
            padding: EdgeInsets.all(10),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7, // Altura máxima
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white.withOpacity(0.8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Difumina SOLO el fondo de la card
                child: Column(
                  children: [
                    // Lista de comentarios con scroll
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('posts')
                            .doc(widget.postId)
                            .collection('comments')
                            .orderBy('timestamp', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return Center(child: Text("No hay comentarios aún."));
                          }

                          final comments = snapshot.data!.docs;

                          return ListView.builder(
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              final comment = comments[index].data() as Map<String, dynamic>;
                              final timestamp = comment['timestamp'] != null
                                  ? (comment['timestamp'] as Timestamp).toDate()
                                  : null;
                              final formattedTime = timestamp != null
                                  ? "${timestamp.hour}:${timestamp.minute} ${timestamp.day}/${timestamp.month}/${timestamp.year}"
                                  : "Desconocido";

                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(comment['profileimageURL'] ?? ''),
                                ),
                                title: Text(
                                  comment['nickname'] ?? 'Usuario desconocido',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(comment['text'] ?? ''),
                                    Text(
                                      formattedTime,
                                      style: TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    // Campo para escribir un nuevo comentario
                    TextField(
                      onSubmitted: (value) async {
                        final currentUserId = FirebaseAuth.instance.currentUser?.uid;

                        if (currentUserId == null) return;

                        final userDoc = await FirebaseFirestore.instance
                            .collection('users')
                            .doc(currentUserId)
                            .get();
                        if (!userDoc.exists) return;

                        final userData = userDoc.data() as Map<String, dynamic>;

                        await FirebaseFirestore.instance
                            .collection('posts')
                            .doc(widget.postId)
                            .collection('comments')
                            .add({
                          'text': value,
                          'userID': currentUserId,
                          'nickname': userData['nickname'],
                          'profileimageURL': userData['profileimageURL'],
                          'timestamp': FieldValue.serverTimestamp(),
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Escribe un comentario...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(widget.profileImageURL),
                ),
                title: Text(
                  widget.nickname,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              widget.isVideo
                  ? AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio,
                      child: Stack(
                        children: [
                          VideoPlayer(_videoController!),
                          Center(
                            child: IconButton(
                              icon: Icon(
                                _videoController!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                                size: 50,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (_videoController!.value.isPlaying) {
                                    _videoController!.pause();
                                  } else {
                                    _videoController!.play();
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        widget.mediaUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(widget.des),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
                    color: isLiked ? Colors.red : Colors.grey,
                    onPressed: _toggleLike,
                  ),
                  Text("$likesCount likes"),
                  IconButton(
                    icon: Icon(Icons.comment),
                    onPressed: () {
                      setState(() {
                        showComments = !showComments;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        if (showComments) _buildCommentsOverlay(),
      ],
    );
  }
}
