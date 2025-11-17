import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../model/project_model.dart';

class ReviewScreen extends StatefulWidget {
  final List<ReviewModel> revDetails;

  const ReviewScreen({super.key, required this.revDetails});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  bool showAll = false;

  @override
  Widget build(BuildContext context) {
    final reviews = widget.revDetails;
    if (reviews.isEmpty) return const SizedBox();

    Widget buildReview(ReviewModel r) => Padding(
      padding: const EdgeInsets.fromLTRB(10, 12, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl: r.avatar,
                  width: 46,
                  height: 46,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) =>
                      const CircleAvatar(radius: 23, child: Icon(Icons.person)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      r.author,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      r.date,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(r.rating, style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            r.content,
            style: const TextStyle(color: Colors.white70, height: 1.4),
          ),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 20, bottom: 6, top: 10),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'User Reviews',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => showAll = !showAll),
                child: Row(
                  children: [
                    Text(
                      showAll ? 'Show Less' : 'All (${reviews.length})',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: Colors.white70,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showAll)
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: reviews.length,
              itemBuilder: (_, i) => buildReview(reviews[i]),
            ),
          )
        else
          buildReview(reviews.first),
      ],
    );
  }
}
