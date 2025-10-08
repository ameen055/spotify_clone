import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 90, horizontal: 23),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
            ],
          ),
        ),
      ),
    );
  }
}

class AlbumShimmer extends StatelessWidget {
  const AlbumShimmer({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        separatorBuilder: (_, __) => SizedBox(width: 12),
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
            SizedBox(height: 6),
            Shimmer.fromColors(
              baseColor: Colors.black12,
              highlightColor: Colors.grey.shade300,
              child: Container(width: 160, height: 14, color: Colors.black12),
            ),
            SizedBox(height: 2),
            Shimmer.fromColors(
              baseColor: Colors.black12,
              highlightColor: Colors.grey.shade300,
              child: Container(width: 120, height: 12, color: Colors.black12),
            ),
          ],
        ),
      ),
    );
  }
}

class PlayListShimmer extends StatelessWidget {
  const PlayListShimmer({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) => Shimmer.fromColors(
          baseColor: Colors.black12,
          highlightColor: Colors.grey.shade300,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(20),
            ),
            height: 70,
            width: double.infinity,
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                SizedBox(width: 3),
                Container(width: 160, height: 20, color: Colors.black12),
                SizedBox(width: 71),
                Container(
                  width: 38,
                  height: 38,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
          ),
        ),
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemCount: 7,
      ),
    );
  }
}
