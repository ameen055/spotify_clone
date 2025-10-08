import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FullLoadingIndicator extends StatelessWidget {
  const FullLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 90, horizontal: 23),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
/// large hero card banner (Shimmer)
            Shimmer.fromColors(
              baseColor: Colors.black12,
              highlightColor: Colors.grey.shade300,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 320,
                  height: 126,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            /// Album list Shimmer (Horizontal)
            SizedBox(
              height: 170,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, __) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.black12,
                      highlightColor: Colors.grey.shade300,
                      child: Container(
                        width: 160,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Shimmer.fromColors(
                      baseColor: Colors.black12,
                      highlightColor: Colors.grey.shade300,
                      child: Container(
                        width: 160,
                        height: 14,
                        color: Colors.black12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Shimmer.fromColors(
                      baseColor: Colors.black12,
                      highlightColor: Colors.grey.shade300,
                      child: Container(
                        width: 120,
                        height: 12,
                        color: Colors.black12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            ///  Playlist Shimmer (Vertical)
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 7,
              separatorBuilder: (_, __) => const SizedBox(height: 20),
              itemBuilder: (_, __) => Shimmer.fromColors(
                baseColor: Colors.black12,
                highlightColor: Colors.grey.shade300,
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      /// Thumbnail
                      Container(
                        width: 50,
                        height: 50,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(width: 3),

                      /// Song Title Placeholder
                      Container(
                        width: 160,
                        height: 20,
                        color: Colors.black12,
                      ),

                      const Spacer(),

                      /// Heart Icon Placeholder
                      Container(
                        width: 38,
                        height: 38,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
