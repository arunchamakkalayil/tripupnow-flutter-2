import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class PackagesSection extends StatelessWidget {
  const PackagesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final packages = [
      {
        'name': 'Munnar',
        'location': 'Idukki, Kerala',
        'rating': '4.8',
        'image': 'https://images.pexels.com/photos/13045091/pexels-photo-13045091.jpeg?auto=compress&cs=tinysrgb&w=400&h=300&dpr=1',
      },
      {
        'name': 'Vagamon',
        'location': 'Idukki, Kerala',
        'rating': '4.7',
        'image': 'https://images.pexels.com/photos/14844302/pexels-photo-14844302.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      },
      {
        'name': 'Meesapulimala',
        'location': 'Idukki, Kerala',
        'rating': '4.9',
        'image': 'https://munnarinfo.in/uploads/profile/1531033411kvutiekb532626.jpg',
      },
      {
        'name': 'Illikal Kallu',
        'location': 'Kottayam, Kerala',
        'rating': '4.6',
        'image': 'https://www.keralatourism.org/_next/image/?url=http%3A%2F%2F127.0.0.1%2Fktadmin%2Fimg%2Fpages%2Flarge-desktop%2Fillikkal-kallu-1727449122_0357636afcabf650ca90.webp&w=1920&q=75',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Trip Packages',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: packages.length,
            itemBuilder: (context, index) {
              final package = packages[index];
              return Container(
                width: 140,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: package['image']!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                color: Colors.grey[300],
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.error,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                package['name']!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                package['location']!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    size: 14,
                                    color: Colors.amber,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    package['rating']!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}